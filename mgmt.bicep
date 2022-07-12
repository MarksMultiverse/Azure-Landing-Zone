// Setting Parameters
param location string = resourceGroup().location
// NET parameters
param vnetmgmtname string = 'mh-vnet-mgmt-prod-001'
param vnetmgmtaddressrange string ='10.0.2.0/24'
// Subnet1 parameters
param snet1mgmtname string = 'mh-snet-mgmt-prod-001'
param snet1mgmtaddressrage string = '10.0.2.0/24'
// Log analytics workspace parameters
param lawmgmtname string = 'mh-law-mgmt-prod-001'
//Automation account parameters
param aamgmtname string = 'mh-aa-mgmt-prod-001'
// Key vault parameters
param kvmgmtname string = 'mh-kv-mgmt-prod-001'
param tenantid string = 'cd0194ae-31fe-40ee-a6ea-9a15246c6ce9'
// Recovery services vaul parameters
param rsvmgmtname string = 'mh-rsv-mgmt-prod-001'

// targetScope = 'resourceGroup' - not needed since it is the default value

// Creating VNET
resource vnetmgmt 'Microsoft.Network/virtualnetworks@2015-05-01-preview' = {
  name: vnetmgmtname
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetmgmtaddressrange
      ]
    }
    subnets: [
      {
        name: snet1mgmtname
        properties: {
          addressPrefix: snet1mgmtaddressrage
        }
      }
    ]
  }
}

// Creating LAW
resource lawmgmt 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: lawmgmtname
  location: location
  properties: {
    retentionInDays: 120
    features: {
      searchversion: 1
      legacy: 0
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

// Creating update management
resource aamgmt 'Microsoft.Automation/automationAccounts@2021-06-22' = {
  name: aamgmtname
}


// Creating key vault
resource kvmgmt 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: kvmgmtname
  location: location
  properties: {
    sku: {
      family: 'A' 
      name: 'standard'
    }
    tenantId: tenantid
    enablePurgeProtection: true
    enableSoftDelete: true
    enabledForDiskEncryption: true
  }
}

// Creating key vault secrets
resource localadmin 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '/localadminwsserver'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

// Creating recovery services vault
resource rsvmgmt 'Microsoft.RecoveryServices/vaults@2022-04-01' = {
  name: rsvmgmtname
  location: location
  properties: {}
  sku: {
    name: 'Standard'
  }
}
