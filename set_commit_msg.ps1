$content = "create: VIPERベースプロトコルを追加"
[System.IO.File]::WriteAllText($args[0], $content, [System.Text.UTF8Encoding]::new($false))

