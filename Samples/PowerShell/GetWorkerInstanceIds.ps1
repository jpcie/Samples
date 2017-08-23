$resourceGroupName = "<Resourcegroup name>";
$webAppName = "<WebApp name>";

$username = "`$<WebApp name>" # 発行プロファイルから取得した userName
$password = "<userPWD>" # 発行プロファイルから取得した userPWD

# Kudu 認証用ヘッダ生成
function CreateAuthHeader($username, $password)
{
    $base64AuthInfo = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username, $password)))
    $headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}
    return $headers
}

# 各 Worker インスタンスの Kudu にアクセスするための Cookie 生成
function CreateCookieSession($kuduUrl, $instanceId)
{
    $mySession = New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession
    $myCookie = New-Object -TypeName System.Net.Cookie
    $myCookie.Name = "ARRAffinity"
    $myCookie.Value = $instanceId
    $mySession.Cookies.Add($kuduUrl, $myCookie)

    return $mySession
}

# Web App が使用するインスタンスの ID 一覧を取得
function GetInstanceIds($resourceGroupName, $webAppName)
{
    $instances = Get-AzureRmResource -ResourceGroupName $resourceGroupName -ResourceType Microsoft.Web/sites/instances -ResourceName $webAppName -ApiVersion 2016-08-01
    $instanceIds = @()
    foreach($instance in $instances)
    {
        $instanceIds += $instance.Name
    }

    return $instanceIds
}


$instanceIds = GetInstanceIds $resourceGroupName $webAppName

$kuduapiUrl = "https://$webAppName.scm.azurewebsites.net/api/processes/-1"
$headers = CreateAuthHeader $username $password
$resultTable = @()

foreach ($instanceId in $instanceIds)
{
    $cookieSession = CreateCookieSession "https://$webAppName.scm.azurewebsites.net" $instanceId
    $result = Invoke-RestMethod -Headers $headers -WebSession $cookieSession -Uri $kuduapiUrl -Method Get
    $computerName = $result.environment_variables.COMPUTERNAME;
    $resultTable += @{ComputerName=$computerName; InstanceId=$instanceId; ShortInstanceId=$instanceId.Substring(0, 6)}
}