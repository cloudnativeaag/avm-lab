# Region/location where resources will be created (e.g. "uksouth")
variable "location" {
  type        = string
  description = "The location/region where the resources will be created. Must be in the short form (e.g. 'uksouth')"

  # Validation: Only allow lowercase letters, numbers, and hyphens
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.location))
    error_message = "The location must only contain lowercase letters, numbers, and hyphens"
  }

  # Validation: Limit the location name to 20 characters max
  validation {
    condition     = length(var.location) <= 20
    error_message = "The location must be 20 characters or less"
  }
}

# Optional short version of the location name (e.g. "uk" for "uksouth")
variable "resource_name_location_short" {
  type        = string
  description = "The short name segment for the location"
  default     = ""

  # Validation: Only lowercase letters allowed, or leave it empty
  validation {
    condition     = length(var.resource_name_location_short) == 0 || can(regex("^[a-z]+$", var.resource_name_location_short))
    error_message = "The short name segment for the location must only contain lowercase letters"
  }

  # Validation: Max 3 characters allowed
  validation {
    condition     = length(var.resource_name_location_short) <= 3
    error_message = "The short name segment for the location must be 3 characters or less"
  }
}

# Workload name (e.g. short name for your app or project)
variable "resource_name_workload" {
  type        = string
  description = "The name segment for the workload"
  default     = "demo"

  # Validation: Only lowercase letters and numbers allowed
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.resource_name_workload))
    error_message = "The name segment for the workload must only contain lowercase letters and numbers"
  }

  # Validation: Max 4 characters allowed
  validation {
    condition     = length(var.resource_name_workload) <= 4
    error_message = "The name segment for the workload must be 4 characters or less"
  }
}

# Environment name (e.g. dev, prod, test)
variable "resource_name_environment" {
  type        = string
  description = "The name segment for the environment"
  default     = "dev"

  # Validation: Only lowercase letters and numbers allowed
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.resource_name_environment))
    error_message = "The name segment for the environment must only contain lowercase letters and numbers"
  }

  # Validation: Max 4 characters allowed
  validation {
    condition     = length(var.resource_name_environment) <= 4
    error_message = "The name segment for the environment must be 4 characters or less"
  }
}

# Number used to help sequence resource names (e.g. 001, 002)
variable "resource_name_sequence_start" {
  type        = number
  description = "The number to use for the resource names"
  default     = 1

  # Validation: Must be between 1 and 999
  validation {
    condition     = var.resource_name_sequence_start >= 1 && var.resource_name_sequence_start <= 999
    error_message = "The number must be between 1 and 999"
  }
}

# A map of templates to define the naming convention for each resource
# These templates are filled in using workload, environment, location, etc.
variable "resource_name_templates" {
  type        = map(string)
  description = "A map of resource names to use"
  default = {
    resource_group_name                 = "rg-$${workload}-$${environment}-$${location}-$${sequence}"
    log_analytics_workspace_name        = "law-$${workload}-$${environment}-$${location}-$${sequence}"
    virtual_network_name                = "vnet-$${workload}-$${environment}-$${location}-$${sequence}"
    network_security_group_name         = "nsg-$${workload}-$${environment}-$${location}-$${sequence}"
    nat_gateway_name                    = "nat-$${workload}-$${environment}-$${location}-$${sequence}"
    nat_gateway_public_ip_name          = "pip-nat-$${workload}-$${environment}-$${location}-$${sequence}"
    key_vault_name                      = "kv$${workload}$${environment}$${location_short}$${sequence}$${uniqueness}"
    storage_account_name                = "sto$${workload}$${environment}$${location_short}$${sequence}$${uniqueness}"
    user_assigned_managed_identity_name = "uami-$${workload}-$${environment}-$${location}-$${sequence}"
    virtual_machine_name                = "vm-$${workload}-$${environment}-$${location}-$${sequence}"
    network_interface_name              = "nic-$${workload}-$${environment}-$${location}-$${sequence}"
    bastion_host_public_ip_name         = "pip-bas-$${workload}-$${environment}-$${location}-$${sequence}"
    bastion_host_name                   = "bas-$${workload}-$${environment}-$${location}-$${sequence}"
  }
}

# The address space for the virtual network (e.g. "10.0.0.0/16")
variable "address_space" {
  type        = string
  description = "The address space that is used the virtual network"
}

# Subnet settings including size and options for NSG and NAT Gateway
variable "subnets" {
  type = map(object({
    size                       = number      # How many IPs the subnet should have
    has_nat_gateway            = bool        # Whether the subnet has a NAT Gateway
    has_network_security_group = bool        # Whether the subnet has an NSG
  }))
  description = "The subnets"
}

# Tags to apply to all resources (e.g. owner, environment)
variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
}

# Option to enable encryption at the host level
variable "enable_encryption_at_host" {
  type        = bool
  description = "Enable encryption at host"
  default     = false
}




Absolutely! Let’s go through your `variables.tf` file in **detailed, beginner-friendly English**, variable by variable. I’ll break it down into what each block does, why it’s useful, and any validations applied.

---

## 🔧 1. `variable "location"`

```hcl
variable "location" {
  type        = string
  description = "The location/region where the resources will be created. Must be in the short form (e.g. 'uksouth')"
```

This defines the **Azure region** (like `uksouth`, `eastus`, etc.) where your resources will be deployed.

```hcl
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.location))
    error_message = "The location must only contain lowercase letters, numbers, and hyphens"
  }
```

This makes sure the location contains only:

* lowercase letters (a–z)
* numbers (0–9)
* hyphens (-)

```hcl
  validation {
    condition     = length(var.location) <= 20
    error_message = "The location must be 20 characters or less"
  }
}
```

Also checks that the region name is no more than 20 characters.

---

## 🧭 2. `resource_name_location_short`

```hcl
variable "resource_name_location_short" {
  type        = string
  description = "The short name segment for the location"
  default     = ""
```

This is an **optional short code** for the region, like `uk` for `uksouth`. Used in naming conventions.

```hcl
  validation {
    condition     = length(var.resource_name_location_short) == 0 || can(regex("^[a-z]+$", var.resource_name_location_short))
    error_message = "The short name segment for the location must only contain lowercase letters"
  }
```

* Either leave it blank (allowed)
* Or, it must be only lowercase letters

```hcl
  validation {
    condition     = length(var.resource_name_location_short) <= 3
    error_message = "The short name segment for the location must be 3 characters or less"
  }
}
```

It can’t be longer than 3 characters.

---

## 🧱 3. `resource_name_workload`

```hcl
variable "resource_name_workload" {
  type        = string
  description = "The name segment for the workload"
  default     = "demo"
```

This defines a **short code for the app or workload** — e.g., `web1`, `ml01`, etc. Default is `demo`.

```hcl
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.resource_name_workload))
    error_message = "The name segment for the workload must only contain lowercase letters and numbers"
  }
```

Only lowercase letters and numbers are allowed.

```hcl
  validation {
    condition     = length(var.resource_name_workload) <= 4
    error_message = "The name segment for the workload must be 4 characters or less"
  }
}
```

Max 4 characters — useful to keep resource names short and Azure-compliant.

---

## 🌱 4. `resource_name_environment`

```hcl
variable "resource_name_environment" {
  type        = string
  description = "The name segment for the environment"
  default     = "dev"
```

This sets the **environment** (e.g., `dev`, `prod`, `test`), usually part of the naming pattern.

Same validations apply:

* Only lowercase letters/numbers
* Max 4 characters

---

## 🔢 5. `resource_name_sequence_start`

```hcl
variable "resource_name_sequence_start" {
  type        = number
  description = "The number to use for the resource names"
  default     = 1
```

This is a **number used in naming**, often for uniqueness like `001`, `002`, etc.

```hcl
  validation {
    condition     = var.resource_name_sequence_start >= 1 && var.resource_name_sequence_start <= 999
    error_message = "The number must be between 1 and 999"
  }
}
```

The value must be between 1 and 999. Later in code, it can be padded with leading zeroes (`001`).

---

## 🧩 6. `resource_name_templates`

```hcl
variable "resource_name_templates" {
  type        = map(string)
  description = "A map of resource names to use"
```

This is a map (key-value pair) that defines **naming formats** for each Azure resource type.

```hcl
  default = {
    resource_group_name                 = "rg-$${workload}-$${environment}-$${location}-$${sequence}"
    log_analytics_workspace_name        = "law-$${workload}-$${environment}-$${location}-$${sequence}"
    ...
    key_vault_name                      = "kv$${workload}$${environment}$${location_short}$${sequence}$${uniqueness}"
```

Each value uses placeholders like:

* `$${workload}`
* `$${environment}`
* `$${location}`
* `$${sequence}`

These are dynamically replaced using a `locals` block in your code.

➡ Example output name:

```hcl
kvdemo-dev-uk001abc
```

This helps standardize and automate naming across environments.

---

## 🌐 7. `address_space`

```hcl
variable "address_space" {
  type        = string
  description = "The address space that is used the virtual network"
}
```

Defines the IP range (CIDR block) for the virtual network, e.g. `"10.0.0.0/16"`.

---

## 🧱 8. `subnets`

```hcl
variable "subnets" {
  type = map(object({
    size                       = number
    has_nat_gateway            = bool
    has_network_security_group = bool
  }))
  description = "The subnets"
}
```

Defines **a map of subnets** and their configuration.

Each subnet must specify:

* `size`: how big the subnet is (number of bits or address count)
* `has_nat_gateway`: whether it uses a NAT gateway
* `has_network_security_group`: whether it has an NSG attached

Used when dynamically creating subnets.

---

## 🏷️ 9. `tags`

```hcl
variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
}
```

A list of tags (key-value pairs) to apply to every resource. Useful for cost tracking, ownership, and automation in Azure.

Example:

```hcl
tags = {
  environment = "dev"
  owner       = "team-a"
}
```

---

## 🔐 10. `enable_encryption_at_host`

```hcl
variable "enable_encryption_at_host" {
  type        = bool
  description = "Enable encryption at host"
  default     = false
}
```

Boolean flag to **enable encryption at the physical host level** for VMs.

* `true` = on
* `false` = off (default)

Used to meet high-security requirements in some organizations.

---

## ✅ Summary

This `variables.tf` defines:

* How your Azure infrastructure is named
* Where it's deployed
* How it's segmented (subnets, network)
* How secure features like host encryption are configured

It also ensures consistency, reusability, and validation across all environments (dev, prod, test).

---

Would you like me to generate the matching `locals.tf` or `main.tf` that uses these variables next?

