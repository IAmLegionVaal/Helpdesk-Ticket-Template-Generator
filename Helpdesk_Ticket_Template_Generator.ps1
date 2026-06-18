#requires -Version 5.1
<#
.SYNOPSIS
    Helpdesk Ticket Template Generator.
.DESCRIPTION
    Generates structured markdown and HTML helpdesk ticket notes.
#>
[CmdletBinding()]
param([string]$OutputPath)

$RunStamp = Get-Date -Format 'yyyyMMdd_HHmmss'
if ([string]::IsNullOrWhiteSpace($OutputPath)) { $OutputPath = Join-Path ([Environment]::GetFolderPath('Desktop')) 'Helpdesk_Ticket_Templates' }
New-Item -Path $OutputPath -ItemType Directory -Force | Out-Null
Write-Host '1. Incident' ; Write-Host '2. Service Request' ; Write-Host '3. Escalation' ; Write-Host '4. Callback Note'
$type = Read-Host 'Choose template type'
$user = Read-Host 'User / requester'
$contact = Read-Host 'Contact details'
$asset = Read-Host 'Asset / hostname'
$summary = Read-Host 'Short summary'
$impact = Read-Host 'Impact / urgency'
$steps = Read-Host 'Steps already taken'
$next = Read-Host 'Next action'
$title = switch($type){ '2' {'Service Request'} '3' {'Escalation Note'} '4' {'Callback Note'} default {'Incident Note'} }
$md = @()
$md += "# $title"
$md += ""
$md += "- Date: $(Get-Date)"
$md += "- Requester: $user"
$md += "- Contact: $contact"
$md += "- Asset: $asset"
$md += "- Summary: $summary"
$md += "- Impact/Urgency: $impact"
$md += ""
$md += "## Troubleshooting / Work Notes"
$md += $steps
$md += ""
$md += "## Next Action"
$md += $next
$md += ""
$md += "## Closure Criteria"
$md += "- User confirms issue is resolved or request is completed."
$md += "- Evidence and notes are attached if escalation is required."
$name = ($title -replace '\s+','_').ToLower()
$mdPath = Join-Path $OutputPath "$name`_$RunStamp.md"
$htmlPath = Join-Path $OutputPath "$name`_$RunStamp.html"
$md -join [Environment]::NewLine | Set-Content $mdPath -Encoding UTF8
$escaped = ($md -join [Environment]::NewLine) -replace '&','&amp;' -replace '<','&lt;' -replace '>','&gt;'
"<html><body><pre>$escaped</pre></body></html>" | Set-Content $htmlPath -Encoding UTF8
Write-Host "Template created: $mdPath" -ForegroundColor Green
Start-Process explorer.exe -ArgumentList "`"$OutputPath`"" -ErrorAction SilentlyContinue
