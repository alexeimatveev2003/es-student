param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("1.3.2", "1.3.3", "1.3.4", "1.3.6", "1.3.7")]
    [string]$Task
)
$ErrorActionPreference = "Stop"
$folders = @{
    "1.3.2" = "131-hello-usb"
    "1.3.3" = "133-led-button-usb"
    "1.3.4" = "133-led-button-usb"
    "1.3.6" = "134-led-module"
    "1.3.7" = "134-led-module"
}
$packages = Join-Path $PSScriptRoot "build/python-packages"
if (-not (Test-Path -LiteralPath (Join-Path $packages "serial"))) {
    & python -m pip install --target $packages -r (Join-Path $PSScriptRoot "requirements.txt")
    if ($LASTEXITCODE -ne 0) { throw "Не удалось установить pyserial." }
}
$previousPythonPath = $env:PYTHONPATH
try {
    $env:PYTHONPATH = $packages + [IO.Path]::PathSeparator + $previousPythonPath
    $scriptName = "check-" + $Task.Replace(".", "-") + ".py"
    & python (Join-Path (Join-Path $PSScriptRoot $folders[$Task]) $scriptName)
    if ($LASTEXITCODE -ne 0) { throw "Ошибка обмена с платой." }
} finally {
    $env:PYTHONPATH = $previousPythonPath
}
