// Setting Parameters
param location string = resourceGroup().location

// NET parameters
param vnetidname string = 'mh-vnet-id-prod-001'
param vnetidaddressrange string ='10.0.1.0/24'

// Subnet1 parameters
param snet1idname string = 'mh-snet-id-prod-001'
param snet1idaddressrage string = '10.0.1.0/24'

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
        }
      }
    ]
  }
}
module domaincontrollers './domaincontrollers.bicep' = {
  name: 'DomainControllers'
  params: {
    availabilitySetName: 'mh-as-id-prod-001'
    availabilitySetPlatformFaultDomainCount: 2
    availabilitySetPlatformUpdateDomainCount: 5
    CCVMPrefix: 'vm-ctx-cc'
    domainFQDN: 'markws365.eu'
    domainJoinUserName: 'domainjoin'
    domainJoinUserPassword: 'InsertPassword'
    location: location
    OS: 'Server2016'
    ouPath: 'InsertOUPath'
    SubnetName: 'mh-snet-id-prod-001'
    virtualMachineCount: 2
    VMPassword: 'InsertPassword'
    VMSize: 'Standard_B2ms'
    VMUserName: 'azureadmin'
    vNetName: 'mh-snet-id-prod-001'
    vNetResourceGroup: 'mh-rg-id-prod-001'
  }
}
