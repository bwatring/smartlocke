# BEGIN SCRIPT - MUST RUN WITH ADMIN ACCOUNT

<# NOTES
STEP 1 - rewrite this script (from scratch if desired) so function better and more efficiently
the goal is to automatically unlock a user if they are locked without prompting again, and let the tech user know whether they were locked or not
- for future: replace getting the abc123 by a mandatory parameter
- get the email from the abc123 from Active Directory (see line 8)
- want to run SLStatusTool with the email and analyze output (can be an object)
- depending on output, do the following:
    - if FamiliarLockout is True, log the info and run SLStatusTool again with the -FAM switch on
    - if UnknownLockout is True, log the info and run SLStatusTool again with the -UNK switch on
    - if both lockouts are True, then run the SLStatusTool with both switches on
    - if both are false, then do nothing
log all the info and send back as message explaining what was done, whether user was locked or not, and if they were unlocked as well

power automate piece - reads message from teams and sends https request to gitlab
gitlab gets triggered by the http request, and runs a yml file
yml file runs the main script

1. this script will be a function, it will have paratemers, like abc123
2. gets the email from the users abc123, and sends it to the smartlock script
3. depending on the output frrom smatlock script, take action

send output back to power automate thru an http request
#>
# How to run : .\newsmart.ps1 -userId 'abc123'

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $userId,
    [String]
    $ChatId,
    [switch]$UNK=$false,
    [switch]$FAM=$false
)

$email = (Get-ADUser $userId -Properties userprincipalname).UserPrincipalName
$message = ""
# $ChatID = "19:b6c4c4646e4b448dac3aad1b772c44a9@thread.v2" # this is for testing purposes
#$style = 'style="background-color:#0c2340; color:#f15a23"' 

$psCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($env:AD_SMARTLOCK_USER, (ConvertTo-SecureString $env:AD_SMARTLOCK_PASSWORD -AsPlainText -Force))
$PSDefaultParameterValues.Add('*:Server', $env:POWERSHELL_ACTIVEDIRECTORY_SERVER)
$PSDefaultParameterValues.Add('*:Credential', $psCred)


#if($lockOutType.FamiliarLockout -eq "True" -or $lockOutType.UnknownLockout -eq "True"){
#    $style = 'style="background-color:#f15a23; color:#0c2340"' 
#    else
#    $style = 'style="background-color:#0c2340; color:#f15a23"' 
#}

$lockOutType = .\SLStatusTool.ps1 -UPN $email

if($lockOutType.FamiliarLockout -eq "True"){
    $style = 'style="background-color:#f15a23; color:#0c2340"' 
    $FAM= $True
    $message += ('<br> <h3 {0}><i> Familiar lockout detected for: </h3></i> <br> <code {0}> email: {1} <br>abc123: {2}<br> </code>' -f $style, $email,  $userId)
}

if($lockOutType.UnknownLockout -eq "True"){
    $style = 'style="background-color:#f15a23; color:#0c2340"' 
    $UNK=$True
    $message += ('<br>  <h3 {0}><i> Unknown lockout detected for: </h3></i> <code {0}> email: {1} <br>abc123: {2}<br> </code>' -f $style, $email,  $userId)
}

if($lockOutType.FamiliarLockout -eq "False" -and $lockOutType.UnknownLockout -eq "False"){
    $style = 'style="background-color:#0c2340; color:#f15a23"' 
    $message += ('<br> <h2 {0}><i> No lockout detected for: </h2></i> <code {0}> email: {1} <br>abc123: {2}<br> </code>' -f $style, $email,  $userId)
    
}

if($FAM){
    $familiarLockie += .\SLStatusTool.ps1 -UPN $email -FAM
    $style = 'style="background-color:#0c2340; color:#f15a23"' 
    $message += ('<br> <h3 {0}><i> Familiar lockout ran, you are now unlocked!</h3></i>'-f $style)
}

if($UNK){
    $unknownLockie += .\SLStatusTool.ps1 -UPN $email -UNK
    $style = 'style="background-color:#0c2340; color:#f15a23"' 
    $message += ('<br> <h3 {0}><i> Unknown lockout ran, you are now unlocked!</h3></i> '-f $style)
}

Write-host $message

#Begin Connecting it to Teams

$Body = @{
    Message = $message
    ChatID = $ChatId
} | ConvertTo-JSON -Compress

$RestMethod = @{
    Uri = "https://prod-156.westus.logic.azure.com:443/workflows/bd0ceac8c7ec40369b25999ea778155f/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=1AG7jx5asITFCxFd6AQZlh3ii8tj5jXx1g07ap-FdC4"
    Body = $Body
    Method = 'POST'
    ContentType = "application/json"
}

Invoke-RestMethod @RestMethod


#connecting to gitlab  upload /  connect to gitlab ^-^ dev ops and automation / yml files 

#last piece is going to be connect from teams to gitlab!

