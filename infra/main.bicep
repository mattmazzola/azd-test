targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment (e.g., dev, staging, prod)')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

param pythonClientAppName string = 'python-client'

@description('Container image for python-client service')
param pythonClientImageName string = ''
var defaultImageName = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var tags = {
  'azd-env-name': environmentName
}

resource sharedRg 'Microsoft.Resources/resourceGroups@2025-04-01' existing = {
  name: 'shared'
}

resource sharedContainerAppsEnv 'Microsoft.App/managedEnvironments@2025-02-02-preview' existing = {
  name: 'shared-containerappsenv'
  scope: sharedRg
}

resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'rg-azd-test-${environmentName}'
  location: location
  tags: tags
}

module containerApp 'app.bicep' = {
  name: 'container-app-deployment'
  scope: rg
  params: {
    name: 'ca-${pythonClientAppName}-${resourceToken}'
    location: location
    tags: union(tags, { 'azd-service-name': pythonClientAppName })
    containerAppsEnvResourceId: sharedContainerAppsEnv.id
    containerImage: !empty(pythonClientImageName) ? pythonClientImageName : defaultImageName
    containerRegistryResourceGroup: sharedRg.name
    containerRegistryName: 'sharedklgoyiacr'
  }
}

// Outputs required by azd
output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
output AZURE_RESOURCE_GROUP string = rg.name

// Outputs for the services
output SERVICE_PYTHON_CLIENT_NAME string = containerApp.outputs.name
output SERVICE_PYTHON_CLIENT_ENDPOINT string = containerApp.outputs.appUrl
