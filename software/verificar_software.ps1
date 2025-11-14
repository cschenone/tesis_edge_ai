# Script para verificar que todo el software necesario está instalado
Write-Host "🔍 VERIFICACIÓN DE SOFTWARE REQUERIDO" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green

function Test-Software {
    param($Nombre, $Comando, $VersionEsperada)
    
    try {
        $version = & $Comando 2>$null
        if ($version -like "*$VersionEsperada*") {
            Write-Host "✅ $Nombre: $version" -ForegroundColor Green
            return $true
        } else {
            Write-Host "⚠️  $Nombre: Versión diferente ($version)" -ForegroundColor Yellow
            return $false
        }
    } catch {
        Write-Host "❌ $Nombre: NO INSTALADO" -ForegroundColor Red
        Write-Host "   Instalador disponible en: software/$Nombre/" -ForegroundColor Gray
        return $false
    }
}

# Verificar cada software
$gitOk = Test-Software "Git" "git" "--version" "2.39.1"
$pythonOk = Test-Software "Python" "python" "--version" "3.10.11"
$dockerOk = Test-Software "Docker" "docker" "--version" "28.5.1"

Write-Host ""
Write-Host "📊 RESUMEN:" -ForegroundColor Cyan
Write-Host "✅ Software correcto: $((@($gitOk, $pythonOk, $dockerOk) -eq $true).Count)/3" -ForegroundColor Green

if (-not ($gitOk -and $pythonOk -and $dockerOk)) {
    Write-Host ""
    Write-Host "🚨 SOFTWARE FALTANTE:" -ForegroundColor Red
    Write-Host "   - Revisa la carpeta 'software/' para instaladores" -ForegroundColor Yellow
    Write-Host "   - Sigue las instrucciones en los archivos .txt" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "🎉 ¡TODO EL SOFTWARE ESTÁ INSTALADO CORRECTAMENTE!" -ForegroundColor Green
}
