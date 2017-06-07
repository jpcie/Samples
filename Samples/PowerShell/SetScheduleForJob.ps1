$websiteName = "mytest" # Web Job を登録する Web App 名
$webjobName = "TestJob" # Web Job 名

$username = "`$mytest" # 発行プロファイルから取得した userName
$password = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" # 発行プロファイルから取得した userPWD

# スケジュール設定
$base64AuthInfo = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username, $password)))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

$body = '{"schedule": "0 */2 * * * *"}'
Invoke-RestMethod -Headers $headers -Uri https://$websiteName.scm.azurewebsites.net/api/triggeredwebjobs/$webjobName/settings -Method Put -ContentType application/json -Body $body