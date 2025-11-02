targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment (e.g., dev, staging, prod)')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

// Generate a unique token for resource names
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var tags = {
  'azd-env-name': environmentName
}

// Create the resource group
resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'rg-azd-test-${environmentName}'
  location: location
  tags: tags
}

// Reference to existing shared Container Apps Environment
var containerAppsEnvResourceId = '/subscriptions/375b0f6d-8ad5-412d-9e11-15d36d14dc63/resourceGroups/shared/providers/Microsoft.App/managedEnvironments/shared-containerappsenv'

// Deploy the container app in the resource group
module containerApp 'app.bicep' = {
  name: 'container-app-deployment'
  scope: rg
  params: {
    name: 'ca-app-${resourceToken}'
    location: location
    tags: union(tags, { 'azd-service-name': 'app' })
    containerAppsEnvResourceId: containerAppsEnvResourceId
    containerImage: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
  }
}

// Outputs required by azd
output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
output AZURE_RESOURCE_GROUP string = rg.name
output SERVICE_APP_ENDPOINT string = containerApp.outputs.appUrl
