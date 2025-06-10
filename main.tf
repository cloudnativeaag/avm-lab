# Create a random string to make resource names unique
resource "random_string" "unique_name" {
  length  = 3          # Length of the random string (3 characters)
  special = false      # Don't include special characters like !@#
  upper   = false      # Use only lowercase letters, no uppercase
  numeric = false      # Don't include numbers, only letters
}

# Example usage:
# This will generate a random string like "abc" or "xyz"
# You can then add this to resource names to avoid naming conflicts
# For example: "myapp-prod-eastus-abc"


module "resource_group" {
  source   = "Azure/avm-res-resources-resourcegroup/azurerm"
  version  = "0.2.1"
  location = var.location
  name     = local.resource_names.resource_group_name
  tags     = var.tags
}
