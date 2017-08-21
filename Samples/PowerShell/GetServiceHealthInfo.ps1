# AAD テナント名 (例：contoso.onmicrosoft.com)
$AADTenant = "AAD テナント名"

# サブスクリプション ID
$subscriptionId = "サブスクリプション ID"

# 情報取得開始日および終了日 (UTC 時間。日本時間 - 9 時間)
$StartDate = "2017-07-01T00:00:00Z"
$EndDate = "2017-08-01T00:00:00Z"

# 認証用モジュールのロード
$adal = "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ResourceManager\AzureResourceManager\AzureRM.Profile\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
$adalforms = "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ResourceManager\AzureResourceManager\AzureRM.Profile\Microsoft.IdentityModel.Clients.ActiveDirectory.WindowsForms.dll"
[System.Reflection.Assembly]::LoadFrom($adal)
[System.Reflection.Assembly]::LoadFrom($adalforms)

# PowerShell の Client ID および Redirect URI を設定 (固定値)
$clientId = "1950a258-227b-4e31-a9cf-717495945fc2" 
$redirectUri = "urn:ietf:wg:oauth:2.0:oob"

# Set Resource App URI as ARM (固定値)
$resourceAppIdURI = "https://management.azure.com/"

# Set Authority to Azure AD Tenant (固定値)
$authority = "https://login.microsoftonline.com/$AADTenant"

# Create Authentication Context tied to Azure AD Tenant
$authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority

# Acquire token
$authResult = $authContext.AcquireToken($resourceAppIdURI, $clientId, $redirectUri, "always")

# Output bearer token
$authHeader = $authResult.CreateAuthorizationHeader()

$contentType = "application/json;charset=utf-8"
$apiVersion = "2017-03-01-preview"
$filter = "eventTimestamp ge '$StartDate' and eventTimestamp le '$EndDate' and categories eq 'ServiceHealth' and levels eq 'Critical, Error, Warning, Informational'"
$url = "https://management.azure.com/subscriptions/$subscriptionId/providers/microsoft.insights/eventtypes/management/values?api-version=$apiVersion&`$filter=$filter"

$requestHeader = @{
 Authorization = $authHeader
}

$serviceHealth = (Invoke-RestMethod -Uri $url -Headers $requestHeader -Method Get -ContentType $contentType).value
