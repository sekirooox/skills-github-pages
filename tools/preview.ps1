param([switch]$Drafts)
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)
$portableRuby = Join-Path (Get-Location) '.tools/rubyinstaller-3.4.11-1-x64/bin'
if (Test-Path -LiteralPath $portableRuby) {
    $env:PATH = "$portableRuby;$env:PATH"
}
if (-not (Get-Command ruby -ErrorAction SilentlyContinue)) {
    throw 'Ruby not found. Install RubyInstaller 3.4 + Devkit or use docker compose up --build.'
}
$env:BUNDLE_PATH = Join-Path (Get-Location) 'vendor/bundle'
& bundle check
if ($LASTEXITCODE -ne 0) {
    & bundle install
    if ($LASTEXITCODE -ne 0) { throw 'bundle install failed' }
}
$serveArgs = @('exec', 'jekyll', 'serve', '--livereload')
if ($Drafts) { $serveArgs += '--drafts' }
& bundle @serveArgs
if ($LASTEXITCODE -ne 0) { throw 'Jekyll preview failed' }
