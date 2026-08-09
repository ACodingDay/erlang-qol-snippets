# Merges snippets-src/*.json into snippets/erlang.json.
# Zed requires all snippets for one language to live in a single file,
# so maintain per-template files in snippets-src/ and run this script
# before reloading the extension (Extensions panel -> Rebuild).
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
