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

param containerRegistryResourceGroup string
param containerRegistryName string

var passwordSecretName = 'registry-password'

resource containerApp 'Microsoft.App/containerApps@2025-02-02-preview' = {
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
      registries: [
        {
          server: '${containerRegistryName}.azurecr.io'
          username: containerRegistryName
          passwordSecretRef: passwordSecretName
        }
      ]
      secrets: [
        {
          name: passwordSecretName
          value: listCredentials(
            resourceId(containerRegistryResourceGroup, 'Microsoft.ContainerRegistry/registries', containerRegistryName),
            '2025-05-01-preview'
          ).passwords[0].value
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
          probes: [
            {
              type: 'Liveness'
              httpGet: {
                path: '/health'
                port: targetPort
              }
              initialDelaySeconds: 10
              periodSeconds: 10
            }
            {
              type: 'Readiness'
              httpGet: {
                path: '/health'
                port: targetPort
              }
              initialDelaySeconds: 5
              periodSeconds: 5
            }
          ]
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
