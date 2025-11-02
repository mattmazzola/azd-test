param name string
param location string = resourceGroup().location
param tags object = {}

param containerAppsEnvResourceId string
param containerImage string
param targetPort int = 8080
param external bool = true
param containerCpuCoreCount string = '0.25'
param containerMemory string = '0.5Gi'
param minReplicas int = 0
param maxReplicas int = 1
param acrName string
param acrResourceGroup string

// Reference to existing ACR
resource acr 'Microsoft.ContainerRegistry/registries@2025-05-01-preview' existing = {
  name: acrName
  scope: resourceGroup(acrResourceGroup)
}

resource containerApp 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: name
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    managedEnvironmentId: containerAppsEnvResourceId
    configuration: {
      ingress: {
        external: external
        targetPort: targetPort
      }
      registries: [
        {
          server: acr.properties.loginServer
          identity: 'system'
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'app'
          image: containerImage
          resources: {
            cpu: json(containerCpuCoreCount)
            memory: containerMemory
          }
        }
      ]
      scale: {
        minReplicas: minReplicas
        maxReplicas: maxReplicas
      }
    }
  }
}



output id string = containerApp.id
output name string = containerApp.name
output appUrl string = 'https://${containerApp.properties.configuration.ingress.fqdn}'
output principalId string = containerApp.identity.principalId
