param name string = '${resourceGroup().name}-client'
param location string = resourceGroup().location

var containerAppsEnvResourceId string = '/subscriptions/375b0f6d-8ad5-412d-9e11-15d36d14dc63/resourceGroups/shared/providers/Microsoft.App/managedEnvironments/shared-containerappsenv'

resource containerApp 'Microsoft.App/containerApps@2025-02-02-preview' = {
  name: name
  location: location
  properties: {
    managedEnvironmentId: containerAppsEnvResourceId
    configuration: {
      ingress: {
        external: true
        targetPort: 8080
      }
    }
    template: {
      containers: [
        {
          name: 'app'
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          resources: {
            cpu: any('0.25')
            memory: '0.5Gi'
          }
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 1
      }
    }
  }
}

output appUrl string = containerApp.properties.configuration.ingress.fqdn
