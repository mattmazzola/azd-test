targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment (e.g., dev, staging, prod)')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

@description('Container image for python-client service')
param pythonClientImageName string = ''

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
    name: 'ca-python-client-${resourceToken}'
    location: location
    tags: union(tags, { 'azd-service-name': 'python-client' })
    containerAppsEnvResourceId: containerAppsEnvResourceId
    containerImage: !empty(pythonClientImageName)
      ? pythonClientImageName
      : 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
    containerRegistryResourceGroup: 'shared'
    containerRegistryName: 'sharedklgoyiacr'
  }
}

// Outputs required by azd
output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
output AZURE_RESOURCE_GROUP string = rg.name
output SERVICE_PYTHON_CLIENT_NAME string = containerApp.outputs.name
output SERVICE_PYTHON_CLIENT_ENDPOINT string = containerApp.outputs.appUrl
