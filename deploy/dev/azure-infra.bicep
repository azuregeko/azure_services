resource acr 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' = {
  name: 'azEssLux'
  location: 'eastus'
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: false
  }
}

output loginServer string = acr.properties.loginServer
