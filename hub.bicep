// Setting Parameters
param location string = resourceGroup().location

// NET parameters
param vnethubname string = 'mh-vnet-hub-prod-001'
param vnethubaddressrange string ='10.0.0.0/24'

// Subnet1 parameters
param snet1hubname string = 'mh-snet-hub-prod-001'
param snet1hubaddressrage string = '10.0.0.0/25'

// GatewaySubnet param
param gatewaysubnetaddressrange string = '10.0.0.128/27'


// targetScope = 'resourceGroup' - not needed since it is the default value

// Creating VNET
resource vnethub 'Microsoft.Network/virtualnetworks@2015-05-01-preview' = {
  name: vnethubname
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnethubaddressrange
      ]
    }
    subnets: [
      {
        name: snet1hubname
        properties: {
          addressPrefix: snet1hubaddressrage
        }
      }
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: gatewaysubnetaddressrange
        }
      }
    ]
  }
}
