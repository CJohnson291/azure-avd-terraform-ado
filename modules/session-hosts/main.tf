resource "random_password" "admin" {
  length      = 24
  special     = true
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "vm" {
  #checkov:skip=CKV_AZURE_50:AVD session hosts require extensions - host pool registration, Entra login and FSLogix settings
  #checkov:skip=CKV_AZURE_151:Managed disks are encrypted at rest by default - encryption at host is a future improvement
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = random_password.admin.result
  license_type          = "Windows_Client"
  secure_boot_enabled   = true
  vtpm_enabled          = true
  tags                  = var.tags

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = var.image_sku
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "entra_join" {
  name                       = "AADLoginForWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "2.0"
  auto_upgrade_minor_version = true

}

resource "time_rotating" "token" {
  rotation_days = 7
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "token" {
  hostpool_id     = var.host_pool_id
  expiration_date = time_rotating.token.rotation_rfc3339
}

locals {
  fslogix_script = <<-EOT
    reg add "HKLM\SOFTWARE\FSLogix\Profiles" /v Enabled /t REG_DWORD /d 1 /f
    reg add "HKLM\SOFTWARE\FSLogix\Profiles" /v VHDLocations /t REG_MULTI_SZ /d "${var.fslogix_share_path == null ? "" : var.fslogix_share_path}" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters" /v CloudKerberosTicketRetrievalEnabled /t REG_DWORD /d 1 /f
    reg add "HKLM\Software\Policies\Microsoft\AzureADAccount" /v LoadCredKeyFromProfile /t REG_DWORD /d 1 /f
EOT
}

resource "azurerm_virtual_machine_extension" "avd_agent" {
  name                       = "AVDAgent"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    modulesUrl            = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_1.0.02797.442.zip"
    configurationFunction = "Configuration.ps1\\AddSessionHost"
    properties = {
      hostPoolName = var.host_pool_name
      aadJoin      = true
    }
  })

  protected_settings = jsonencode({
    properties = {
      registrationInfoToken = azurerm_virtual_desktop_host_pool_registration_info.token.token
    }
  })
  depends_on = [azurerm_virtual_machine_extension.entra_join]

}

# Switch - if the fslogix_share_path variable is not null, then create the fslogix_config extension
resource "azurerm_virtual_machine_extension" "fslogix_config" {
  count                      = var.fslogix_share_path == null ? 0 : 1
  name                       = "FSLogixConfig"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true
  settings = jsonencode({
    commandToExecute = "powershell -NoProfile -ExecutionPolicy Bypass -EncodedCommand \"${textencodebase64(local.fslogix_script, "UTF-16LE")}\""
  })
}