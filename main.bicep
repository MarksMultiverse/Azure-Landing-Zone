// Setting Parameters
param location string = 'westeurope'

// Setting target scope
targetScope = 'subscription'

// Creating id resource group
resource rgid 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'mh-rg-id-prod-001'
  location: location
}

// Creating id resources
module id './id.bicep' = {
  scope: rgid
  name: 'idDeployment'
  params: {
    location: location
  }
}

// Creating hub resource group
resource rghub 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'mh-rg-hub-prod-001'
  location: location
}

// Creating hub resources
module hub './hub.bicep' = {
  scope: rghub
  name: 'hubDeployment'
  params: {
    location: location
  }
}

resource rgavd 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'mh-rg-avd-prod-001'
  location: location
}

resource rgapp 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'mh-rg-app-prod-001'
  location: location
}

resource rgmgmt 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'mh-rg-mgmt-prod-001'
  location: location
}

// Creating id resources
module mgmt './mgmt.bicep' = {
  scope: rgmgmt
  name: 'mgmtDeployment'
  params: {
    location: location
  }
}
