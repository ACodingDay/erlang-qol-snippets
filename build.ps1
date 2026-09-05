#Requires -Version 7

# Merges snippets-src/*.json into snippets/erlang.json.
# Zed requires all snippets for one language to live in a single file,
# so maintain per-template files in snippets-src/ and run this script
# before reloading the extension (Extensions panel -> Rebuild).
#
# PowerShell 7 (pwsh) is required: ConvertTo-Json formats output
# differently in Windows PowerShell 5.1, which would rewrite the whole
# generated file. CI regenerates this file and fails if it is out of date.
$ErrorActionPreference = "Stop"
$root = $PSScriptRoot

$src = Get-ChildItem (Join-Path $root "snippets-src") -Filter "*.json" | Sort-Object Name
$all = [ordered]@{}
foreach ($f in $src) {
    $obj = Get-Content $f.FullName -Raw | ConvertFrom-Json
    foreach ($p in $obj.PSObject.Properties) {
        if ($all.Contains($p.Name)) {
            throw "Duplicate snippet name '$($p.Name)' in $($f.Name)"
        }
        $all[$p.Name] = $p.Value
    }
}

$out = Join-Path $root "snippets\erlang.json"
[System.IO.File]::WriteAllText($out, ($all | ConvertTo-Json -Depth 100))
Write-Host "Generated snippets/erlang.json with $($all.Count) snippets from $($src.Count) files"

# Check that the README prefix tables and keybinding snippet names
# stay in sync with the snippets (both READMEs are checked).
$prefixes = @()
$names = @()
foreach ($p in $all.GetEnumerator()) {
    $prefixes += $p.Value.prefix
    $names += $p.Key
}
foreach ($readme in "README.md", "README_CN.md") {
    $text = Get-Content (Join-Path $root $readme) -Raw
    $docPrefixes = @(
        foreach ($line in ($text -split "`r?`n" | Where-Object { $_ -match '^\s*\|' })) {
            if ($line -match '^\s*\|\s*([^|]+?)\s*\|') {
                [regex]::Matches($Matches[1], '`([^`]+)`') | ForEach-Object { $_.Groups[1].Value }
            }
        }
    )
    $missing = @($prefixes | Where-Object { $docPrefixes -notcontains $_ })
    $unknown = @($docPrefixes | Where-Object { $prefixes -notcontains $_ })
    if ($missing -or $unknown) {
        throw "$readme prefix table out of sync. Missing: $($missing -join ', '). Unknown: $($unknown -join ', ')"
    }
    $docNames = @([regex]::Matches($text, '"name":\s*"([^"]+)"') | ForEach-Object { $_.Groups[1].Value })
    $unknownNames = @($docNames | Where-Object { $names -notcontains $_ })
    if ($unknownNames) {
        throw "$readme references unknown snippet name(s): $($unknownNames -join ', ')"
    }
}
Write-Host "README prefix tables and keybinding names are in sync"
