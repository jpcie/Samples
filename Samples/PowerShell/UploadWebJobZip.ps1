$websiteName = "mytest" # Web Job を登録する Web App 名
$webjobName = "TestJob" # Web Job 名

$fileName = "WebJob1.zip" # Web Job を格納した ZIP ファイル名
$localFilePath = "C:\temp\WebJob1.zip" # Web Job を格納した ZIP ファイルのパス

$username = "`$mytest" # 発行プロファイルから取得した userName
$password = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" # 発行プロファイルから取得した userPWD

# Web ジョブ アップロード
$base64AuthInfo = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username, $password)))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo); "Content-Disposition"=("attachement; filename={0}" -f $fileName)}

# Triggered
Invoke-RestMethod -Headers $headers -Uri https://$websiteName.scm.azurewebsites.net/api/triggeredwebjobs/$webjobName -Method Put -ContentType application/zip -InFile $localFilePath

# Continuous
# Invoke-RestMethod -Headers $headers -Uri https://$websiteName.scm.azurewebsites.net/api/continuouswebjobs/$webjobName -Method Put -ContentType application/zip -InFile $localFilePath