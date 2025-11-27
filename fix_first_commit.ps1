$content = Get-Content $args[0]
$content[0] = $content[0] -replace '^pick', 'reword'
$content | Set-Content $args[0]

