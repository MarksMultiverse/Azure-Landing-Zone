// Setting Parameters
param location string = resourceGroup().location

// Network security group parameters
param nsg1idname string = 'mh-nsg-id-prod-001'

// Virtual network parameters
param vnetidname string = 'mh-vnet-id-prod-001'
param vnetidaddressrange string ='10.0.1.0/24'

// Subnet1 parameters
param snet1idname string = 'mh-snet-id-prod-001'
param snet1idaddressrage string = '10.0.1.0/24'

// Network interface cards parameters
param nic1dc1name string = 'mh-nic-id-prod-001'
param nic1dc2name string = 'mh-nic-id-prod-002'

// Virtual machines parameters
param adminUsername string = 'PINK_Admin'
param vmdc1name string = 'mh-vm-id-prod-001'
param vmdc2name string = 'mh-vm-id-prod-002'

@secure()
param adminPassword string

// Creating Netwerk security group
resource nsgid1 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: nsg1idname
}

// Creating VNET
resource vnetid 'Microsoft.Network/virtualnetworks@2015-05-01-preview' = {
  name: vnetidname
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetidaddressrange
      ]
    }
    subnets: [
      {
        name: snet1idname
        properties: {
          addressPrefix: snet1idaddressrage
          networkSecurityGroup: {
            id: nsgid1.id
          }
        }
      }
    ]
  }
}

// Creating network interface cards
resource dc1nic1 'Microsoft.Network/networkInterfaces@2022-01-01' = {
  name: nic1dc1name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetid.name,snet1idname)
          }
          privateIPAllocationMethod: 'Static'
        }
      }
    ]
  }
}
resource dc2nic1 'Microsoft.Network/networkInterfaces@2022-01-01' = {
  name: nic1dc2name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetid.name,snet1idname)
          }
          privateIPAllocationMethod: 'Static'
        }
      }
    ]
  }
}

// Creating virtual machines
resource dc1 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: vmdc1name
  location: location
  properties: {
    osProfile: {
      computerName: vmdc1name
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2016-Datacenter-gensecond'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        diskSizeGB: 127
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }

      }
      dataDisks: [
        {
          lun: 0
          createOption: 'Attach'
          caching: 'None'
          diskSizeGB: 8
          managedDisk: {
            storageAccountType: 'Premium_LRS'
          }
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: dc1nic1.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource dc2 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: vmdc2name
  location: location
  properties: {
    osProfile: {
      computerName: vmdc1name
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2016-Datacenter-gensecond'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        diskSizeGB: 127
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }

      }
      dataDisks: [
        {
          lun: 0
          createOption: 'Attach'
          caching: 'None'
          diskSizeGB: 8
          managedDisk: {
            storageAccountType: 'Premium_LRS'
          }
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: dc2nic1.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}
