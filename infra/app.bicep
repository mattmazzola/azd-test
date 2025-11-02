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

resource containerApp 'Microsoft.App/containerApps@2023-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    managedEnvironmentId: containerAppsEnvResourceId
    configuration: {
      ingress: {
        external: external
        targetPort: targetPort
      }
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
