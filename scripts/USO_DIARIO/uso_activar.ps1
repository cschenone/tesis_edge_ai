# =============================================================================
# ESTRATEGIA: Script de Inicialización Diaria - Tesis Edge AI
# PROPÓSITO: Preparar entorno de desarrollo de manera consistente y segura
# COHERENCIA: Verificación → Activación → Confirmación → Disponibilidad
# =============================================================================

# -----------------------------------------------------------------------------
# FASE 1: INICIALIZACIÓN Y PRESENTACIÓN
# Estrategia: Establecer contexto claro para el usuario
# -----------------------------------------------------------------------------
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "ACTIVADOR TESIS EDGE AI - POWERSHELL" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Iniciando secuencia de activación del proyecto..." -ForegroundColor Yellow
Write-Host ""

# -----------------------------------------------------------------------------
# FASE 2: CONFIGURACIÓN DEL ENTORNO
# Estrategia: Usar rutas relativas para portabilidad
# -----------------------------------------------------------------------------
Write-Host "[1/4] Configurando directorio de trabajo..." -ForegroundColor Gray

# COHERENCIA MEJORADA: Detectar ruta automáticamente
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
if (Test-Path $scriptDirectory) {
    Set-Location $scriptDirectory
    Write-Host "   ✅ Directorio: $scriptDirectory" -ForegroundColor Green
} else {
    Write-Host "   ❌ No se puede acceder al directorio del proyecto" -ForegroundColor Red
    exit 1
}

# -----------------------------------------------------------------------------
# FASE 3: ACTIVACIÓN DEL ENTORNO VIRTUAL
# Estrategia: Verificación en profundidad
# -----------------------------------------------------------------------------
Write-Host "[2/4] Verificando ambiente virtual..." -ForegroundColor Gray

$venvPath = "venv_tesis"
$activateScript = Join-Path $venvPath "Scripts\Activate.ps1"

if (Test-Path $activateScript) {
    try {
        # Activar el entorno virtual
        & $activateScript
        Write-Host "   ✅ Ambiente virtual activado" -ForegroundColor Green
        
        # VERIFICACIÓN DE COHERENCIA: Confirmar que Python funciona
        Write-Host "[3/4] Verificando Python..." -ForegroundColor Gray
        $pythonVersion = python --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ $pythonVersion" -ForegroundColor Green
        } else {
            Write-Host "   ❌ Python no responde correctamente" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "   ❌ Error al activar el ambiente virtual: $_" -ForegroundColor Red
    }
} else {
    Write-Host "   ❌ No se encuentra el ambiente virtual" -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 SOLUCIÓN: Ejecuta los siguientes comandos:" -ForegroundColor Yellow
    Write-Host "   1. python -m venv venv_tesis" -ForegroundColor White
    Write-Host "   2. .\venv_tesis\Scripts\Activate.ps1" -ForegroundColor White
    Write-Host "   3. pip install -r requirements.txt" -ForegroundColor White
    exit 1
}

# -----------------------------------------------------------------------------
# FASE 4: INFORMACIÓN FINAL Y DISPONIBILIDAD
# Estrategia: Proporcionar guías de acción claras
# -----------------------------------------------------------------------------
Write-Host "[4/4] Resumen del entorno:" -ForegroundColor Gray
Write-Host ""

Write-Host "📍 Ubicación actual:" -ForegroundColor Yellow
Get-Location | ForEach-Object { Write-Host "   $($_.Path)" -ForegroundColor White }

Write-Host "🐍 Entorno Python:" -ForegroundColor Yellow
try {
    $pythonInfo = python -c "import sys; print(f'Python {sys.version} en {sys.prefix}')" 2>$null
    if ($pythonInfo) {
        Write-Host "   $pythonInfo" -ForegroundColor White
    }
} catch {
    Write-Host "   No se pudo obtener información detallada de Python" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🚀 Comandos disponibles:" -ForegroundColor Cyan
Write-Host "   📊 Verificación: .\verificar_sistema_completo.ps1" -ForegroundColor White
Write-Host "   💻 Desarrollo:   .\iniciar_desarrollo.ps1" -ForegroundColor White
Write-Host "   🔬 Experimentos: .\iniciar_experimentos.ps1" -ForegroundColor White
Write-Host "   📓 Jupyter:      jupyter notebook" -ForegroundColor White

Write-Host ""
Write-Host "────────────────────────────────────────────────────────────" -ForegroundColor Cyan
Write-Host "✅ AMBIENTE LISTO - Puedes comenzar a trabajar en tu tesis" -ForegroundColor Green
Write-Host "💡 Cierra esta ventana cuando termines tu jornada" -ForegroundColor Yellow
Write-Host "────────────────────────────────────────────────────────────" -ForegroundColor Cyan

# -----------------------------------------------------------------------------
# ESTRATEGIA MEJORADA: No bloquear la terminal innecesariamente
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Presiona Enter para mantener la ventana abierta..." -ForegroundColor Gray
Write-Host "O cierra la ventana cuando hayas terminado" -ForegroundColor Gray

# Opción interactiva en lugar de bloqueo automático
$null = Read-Host
