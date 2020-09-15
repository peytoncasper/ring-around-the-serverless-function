resource "azurerm_resource_group" "consul" {
  name     = "consul-demo"
  location = "East US"
}

resource "azurerm_virtual_network" "consul" {
  name                = "consul-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.consul.location
  resource_group_name = azurerm_resource_group.consul.name
}

resource "azurerm_subnet" "consul" {
  name                 = "consul-subnet"
  resource_group_name  = azurerm_resource_group.consul.name
  virtual_network_name = azurerm_virtual_network.consul.name
  address_prefix       = "10.0.2.0/24"
}


resource "azurerm_storage_account" "function" {
  name                     = "consul-function"
  resource_group_name      = azurerm_resource_group.consul.name
  location                 = azurerm_resource_group.consul.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_environment" "function" {
  name                         = "consul-function-env"
  subnet_id                    = azurerm_subnet.consul.id
  pricing_tier                 = "I1"
  front_end_scale_factor       = 5
  internal_load_balancing_mode = "None"
}


resource "azurerm_app_service_plan" "function" {
  name                = "consul-function-service-plan"
  location            = azurerm_resource_group.consul.location
  resource_group_name = azurerm_resource_group.consul.name
  app_service_environment_id = azurerm_app_service_environment.function.id

  sku {
    tier = "Premium"
    size = "EP1"
  }
}

resource "azurerm_function_app" "function" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.consul.location
  resource_group_name        = azurerm_resource_group.consul.name
  app_service_plan_id        = azurerm_app_service_plan.function.id
  storage_account_name       = azurerm_storage_account.function.name
  storage_account_access_key = azurerm_storage_account.function.primary_access_key
}


# resource "azurerm_network_interface" "consul" {
#   name                = "consul-server-nic"
#   location            = azurerm_resource_group.consul.location
#   resource_group_name = azurerm_resource_group.consul.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.consul.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_linux_virtual_machine" "consul" {
#   name                = "consul-server"
#   resource_group_name = azurerm_resource_group.consul.name
#   location            = azurerm_resource_group.consul.location
#   size                = "Standard_Fsv2"

#   network_interface_ids = [
#     azurerm_network_interface.consul.id,
#   ]

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("~/.ssh/id_rsa.pub")
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }
# }