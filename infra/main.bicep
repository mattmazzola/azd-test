targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment (e.g., dev, staging, prod)')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

param sharedRgName string
param sharedContainerAppsEnvironmentName string
param sharedAcrName string

resource sharedRg 'Microsoft.Resources/resourceGroups@2025-04-01' existing = {
  name: sharedRgName
}

var sharedRgToken = take(uniqueString(sharedRg.id), 6)

resource sharedContainerAppsEnv 'Microsoft.App/managedEnvironments@2025-02-02-preview' existing = {
  name: sharedContainerAppsEnvironmentName
  scope: sharedRg
}

resource sharedAcr 'Microsoft.ContainerRegistry/registries@2025-05-01-preview' existing = {
  name: sharedAcrName
  scope: sharedRg
}

var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var tags = {
  'azd-env-name': environmentName
}

var rgSlug = 'azd-test'

resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'rg-${rgSlug}-${environmentName}'
  location: location
  tags: tags
}

param pythonClientAppName string = 'python-client'
param pythonClientImageName string = ''
var defaultImageName = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

module containerApp 'app.bicep' = {
  name: 'containerAppModule'
  scope: rg
  params: {
    name: 'ca-${rgSlug}-${pythonClientAppName}'
    location: location
    tags: union(tags, { 'azd-service-name': pythonClientAppName })
    containerAppsEnvResourceId: sharedContainerAppsEnv.id
    containerImage: !empty(pythonClientImageName) ? pythonClientImageName : defaultImageName
    containerRegistryResourceGroup: sharedRg.name
    containerRegistryName: sharedAcr.name
  }
}

// Outputs required by azd
output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
output AZURE_RESOURCE_GROUP string = rg.name

// Outputs for the services
output SERVICE_PYTHON_CLIENT_NAME string = containerApp.outputs.name
output SERVICE_PYTHON_CLIENT_ENDPOINT string = containerApp.outputs.appUrl
