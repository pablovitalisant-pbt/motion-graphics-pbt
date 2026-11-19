# Busca (y opcionalmente descarga) imagenes o audio con licencia CC en Openverse.
# Uso:
#   pwsh -File openverse.ps1 -Type audio -Query "whoosh" -License cc0
#   pwsh -File openverse.ps1 -Type images -Query "mountain sunrise" -LicenseType commercial -Download -Out .\assets -Count 5
# Escribe CREDITS.txt con la atribucion de cada archivo descargado.
param(
  [ValidateSet('audio', 'images')][string]$Type = 'images',
  [Parameter(Mandatory)][string]$Query,
  [string]$License = '',                    # cc0, by, by-sa, pdm ... (coma-separado)
  [string]$LicenseType = 'commercial',      # commercial | modification | all
  [int]$Count = 10,
  [switch]$Download,
  [string]$Out = '.\openverse'
)
$q = [uri]::EscapeDataString($Query)
$url = "https://api.openverse.org/v1/$Type/?q=$q&page_size=$Count"
if ($License) { $url += "&license=$License" }
if ($LicenseType -and $LicenseType -ne 'all') { $url += "&license_type=$LicenseType" }
$r = Invoke-RestMethod -Uri $url -TimeoutSec 60
Write-Host "resultados: $($r.result_count)  (mostrando $($r.results.Count))"
$i = 0
foreach ($x in $r.results) {
  $i++
  $dur = if ($x.duration) { " dur=$([math]::Round($x.duration/1000,1))s" } else { '' }
  Write-Host ("[{0}] {1} | {2} {3} | {4}{5}" -f $i, $x.title, $x.license, $x.license_version, $x.creator, $dur)
  Write-Host ("     " + $x.url)
}
if ($Download) {
  New-Item -ItemType Directory -Force $Out | Out-Null
  $credits = Join-Path $Out 'CREDITS.txt'
  foreach ($x in $r.results) {
    $ext = [IO.Path]::GetExtension(([uri]$x.url).AbsolutePath); if (-not $ext) { $ext = if ($Type -eq 'audio') { '.mp3' } else { '.jpg' } }
    $name = ($x.id + $ext)
    try {
      Invoke-WebRequest -Uri $x.url -OutFile (Join-Path $Out $name) -TimeoutSec 120
      Add-Content $credits ("{0}: ""{1}"" by {2} - {3} {4} - {5}" -f $name, $x.title, $x.creator, $x.license.ToUpper(), $x.license_version, $x.foreign_landing_url)
      Write-Host "descargado $name"
    } catch { Write-Host "fallo $($x.url): $($_.Exception.Message)" }
  }
  Write-Host "atribuciones en $credits"
}
