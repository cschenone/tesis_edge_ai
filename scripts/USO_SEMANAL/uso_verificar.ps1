# =============================================================================
# ESTRATEGIA: Script de Verificación Semanal Completa - Tesis Edge AI
# PROPÓSITO: Diagnóstico integral preventivo del sistema de desarrollo e investigación
# COHERENCIA: Verificación en capas → Reporte estructurado → Guías de acción
# FRECUENCIA: Uso semanal para mantenimiento proactivo y detección temprana de problemas
# =============================================================================

# -----------------------------------------------------------------------------
# FASE 1: ENCABEZADO Y CONTEXTO
# Estrategia: Establecer claramente el propósito y alcance de la verificación
# -----------------------------------------------------------------------------
Write-Host "🔍 VERIFICACIÓN COMPLETA DEL SISTEMA TESIS EDGE AI" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host "📅 Verificación semanal de mantenimiento preventivo" -ForegroundColor Gray
Write-Host "🎯 Objetivo: Detectar problemas antes de que afecten la investigación" -ForegroundColor Gray
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host ""

# -----------------------------------------------------------------------------
# FASE 2: VERIFICACIÓN DE INFRAESTRUCTURA BASE
# Estrategia: Comenzar con los componentes fundamentales del sistema
# -----------------------------------------------------------------------------
Write-Host "[1/7] 🔧 INFRAESTRUCTURA DEL SISTEMA..." -ForegroundColor Gray

# Verificación 1.1: PowerShell y permisos
Write-Host "   PowerShell:" -ForegroundColor White
Write-Host "     • Versión: $($PSVersionTable.PSVersion)" -ForegroundColor $(if ($PSVersionTable.PSVersion.Major -ge 5) { "Green" } else { "Yellow" })
Write-Host "     • Ejecución: $(Get-ExecutionPolicy)" -ForegroundColor $(if ((Get-ExecutionPolicy) -ne "Restricted") { "Green" } else { "Red" })

# Verificación 1.2: Recursos del sistema
Write-Host "   Recursos del sistema:" -ForegroundColor White
try {
    $memoryInfo = Get-WmiObject -Class Win32_ComputerSystem
    $totalRAM = [math]::Round($memoryInfo.TotalPhysicalMemory / 1GB, 2)
    Write-Host "     • RAM: $totalRAM GB" -ForegroundColor $(if ($totalRAM -ge 16) { "Green" } elseif ($totalRAM -ge 8) { "Yellow" } else { "Red" })
    
    $diskInfo = Get-PSDrive C
    $freeGB = [math]::Round($diskInfo.Free / 1GB, 2)
    Write-Host "     • Disco libre: $freeGB GB" -ForegroundColor $(if ($freeGB -ge 20) { "Green" } elseif ($freeGB -ge 10) { "Yellow" } else { "Red" })
} catch {
    Write-Host "     • ❌ No se pudieron verificar recursos" -ForegroundColor Red
}

# -----------------------------------------------------------------------------
# FASE 3: VERIFICACIÓN DE PYTHON Y ENTORNO VIRTUAL
# Estrategia: Verificación exhaustiva del entorno de programación
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[2/7] 🐍 ENTORNO PYTHON..." -ForegroundColor Gray

$pythonStatus = "unknown"
$pythonCommands = @("python", "py", "python3")

foreach ($cmd in $pythonCommands) {
    try {
        $versionOutput = & $cmd --version 2>&1
        if ($LASTEXITCODE -eq 0 -and $versionOutput -match "Python (\d+\.\d+)") {
            $pythonVersion = $matches[1]
            Write-Host "   ✅ Python $pythonVersion encontrado (comando: $cmd)" -ForegroundColor Green
            $pythonStatus = "available"
            $pythonCmd = $cmd
            break
        }
    } catch {
        continue
    }
}

if ($pythonStatus -eq "unknown") {
    Write-Host "   ❌ Python no encontrado en el sistema" -ForegroundColor Red
} else {
    # Verificar versión específica recomendada
    if ($pythonVersion -ge "3.8") {
        Write-Host "   ✅ Versión compatible (3.8+)" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Versión antigua: $pythonVersion (se recomienda 3.10+)" -ForegroundColor Yellow
    }
}

# Verificación profunda del ambiente virtual
Write-Host "   Ambiente virtual:" -ForegroundColor White
if (Test-Path "venv_tesis") {
    Write-Host "     • ✅ Carpeta 'venv_tesis' existe" -ForegroundColor Green
    
    # Verificar que se puede activar
    $activateScript = "venv_tesis\Scripts\Activate.ps1"
    if (Test-Path $activateScript) {
        Write-Host "     • ✅ Script de activación disponible" -ForegroundColor Green
        
        # Verificar dependencias básicas si el ambiente está activo o se puede activar
        if ($env:VIRTUAL_ENV) {
            Write-Host "     • ✅ Ambiente actualmente activo" -ForegroundColor Green
            Test-PythonModules
        } else {
            Write-Host "     • ℹ️  Ambiente no activo (ejecuta .\uso_diario_activar.ps1)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "     • ❌ Script de activación no encontrado" -ForegroundColor Red
    }
} else {
    Write-Host "     • ❌ Ambiente virtual no encontrado" -ForegroundColor Red
    Write-Host "     • 💡 Ejecuta: .\uso_emergencia_reconstruir.ps1" -ForegroundColor White
}

# -----------------------------------------------------------------------------
# FASE 4: VERIFICACIÓN DE DOCKER Y CONTENEDORES
# Estrategia: Verificar el entorno de containerización completo
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[3/7] 🐳 ENTORNO DOCKER..." -ForegroundColor Gray

# Verificación de Docker daemon
try {
    $dockerVersion = docker --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✅ $dockerVersion" -ForegroundColor Green
        
        # Verificar que el daemon esté funcionando
        $dockerInfo = docker info 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ Docker daemon funcionando" -ForegroundColor Green
        } else {
            Write-Host "   ❌ Docker daemon no responde" -ForegroundColor Red
        }
    }
} catch {
    Write-Host "   ❌ Docker no disponible en el sistema" -ForegroundColor Red
}

# -----------------------------------------------------------------------------
# FASE 5: VERIFICACIÓN DE CONTENEDORES DEL PROYECTO
# Estrategia: Estado específico de los contenedores de la tesis
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[4/7] 📦 CONTENEDORES TESIS..." -ForegroundColor Gray

$contenedoresTesis = docker ps -a --filter "name=tesis-" --format "table {{.Names}}\t{{.Status}}\t{{.Image}}" 2>$null
if ($contenedoresTesis -and $contenedoresTesis.Count -gt 1) {
    Write-Host "   Contenedores encontrados:" -ForegroundColor White
    $contenedoresTesis | Select-Object -Skip 1 | ForEach-Object {
        if ($_ -match "Up") {
            Write-Host "     • ✅ $_" -ForegroundColor Green
        } elseif ($_ -match "Exited") {
            Write-Host "     • ⏸️  $_" -ForegroundColor Yellow
        } else {
            Write-Host "     • ❌ $_" -ForegroundColor Red
        }
    }
} else {
    Write-Host "   ℹ️  No hay contenedores tesis en el sistema" -ForegroundColor Yellow
}

# -----------------------------------------------------------------------------
# FASE 6: VERIFICACIÓN DE IMÁGENES DOCKER
# Estrategia: Estado de las imágenes construidas para el proyecto
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[5/7] 🏗️ IMÁGENES DOCKER..." -ForegroundColor Gray

$imagenesTesis = docker images --filter "reference=tesis-*" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}" 2>$null
if ($imagenesTesis -and $imagenesTesis.Count -gt 1) {
    Write-Host "   Imágenes disponibles:" -ForegroundColor White
    $imagenCount = 0
    $imagenesTesis | Select-Object -Skip 1 | ForEach-Object {
        $imagenCount++
        Write-Host "     • ✅ $_" -ForegroundColor Green
    }
    Write-Host "   📊 Total: $imagenCount imágenes tesis" -ForegroundColor Cyan
} else {
    Write-Host "   ❌ No hay imágenes tesis construidas" -ForegroundColor Red
    Write-Host "   💡 Ejecuta: .\construir_contenedores.ps1" -ForegroundColor White
}

# -----------------------------------------------------------------------------
# FASE 7: VERIFICACIÓN DE ESTRUCTURA DEL PROYECTO
# Estrategia: Integridad de archivos y directorios del proyecto
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[6/7] 📁 ESTRUCTURA DEL PROYECTO..." -ForegroundColor Gray

$archivosCriticos = @(
    @{Path = "docker-compose.yml"; Tipo = "Configuración"; Critico = $true},
    @{Path = "Dockerfile"; Tipo = "Construcción"; Critico = $true},
    @{Path = "requirements/base.txt"; Tipo = "Dependencias"; Critico = $true},
    @{Path = "requirements/desarrollo.txt"; Tipo = "Desarrollo"; Critico = $false},
    @{Path = "requirements/experiments.txt"; Tipo = "Experimentación"; Critico = $false},
    @{Path = "codigo/"; Tipo = "Código fuente"; Critico = $true},
    @{Path = "configs/"; Tipo = "Configuraciones"; Critico = $false},
    @{Path = "notebooks/"; Tipo = "Investigación"; Critico = $false},
    @{Path = "datos/"; Tipo = "Datasets"; Critico = $false},
    @{Path = "models/"; Tipo = "Modelos"; Critico = $false}
)

$archivosOk = 0
$archivosTotales = 0
$archivosCriticosOk = 0
$archivosCriticosTotales = 0

foreach ($archivo in $archivosCriticos) {
    $archivosTotales++
    if ($archivo.Critico) { $archivosCriticosTotales++ }
    
    if (Test-Path $archivo.Path) {
        $archivosOk++
        if ($archivo.Critico) { $archivosCriticosOk++ }
        Write-Host "   ✅ $($archivo.Tipo): $($archivo.Path)" -ForegroundColor Green
    } else {
        $color = if ($archivo.Critico) { "Red" } else { "Yellow" }
        $icon = if ($archivo.Critico) { "❌" } else { "⚠️" }
        Write-Host "   $icon $($archivo.Tipo): $($archivo.Path) - FALTANTE" -ForegroundColor $color
    }
}

# -----------------------------------------------------------------------------
# FASE 8: VERIFICACIÓN DE HARDWARE PARA ML
# Estrategia: Recursos específicos para Machine Learning
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[7/7] ⚡ HARDWARE PARA ML..." -ForegroundColor Gray

# Detectar GPU NVIDIA
$nvidiaGpu = nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader 2>$null
if ($nvidiaGpu) {
    $gpuInfo = $nvidiaGpu[0] -split ","
    Write-Host "   ✅ GPU NVIDIA: $($gpuInfo[0].Trim())" -ForegroundColor Green
    Write-Host "     • Memoria: $($gpuInfo[1].Trim())" -ForegroundColor White
    Write-Host "     • Driver: $($gpuInfo[2].Trim())" -ForegroundColor White
} else {
    Write-Host "   ℹ️  GPU NVIDIA no detectada" -ForegroundColor Yellow
    Write-Host "   💡 Los entrenamientos usarán CPU" -ForegroundColor White
}

# Verificar CUDA si está disponible
try {
    $cudaVersion = nvcc --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✅ CUDA disponible" -ForegroundColor Green
    }
} catch {
    Write-Host "   ℹ️  CUDA no disponible" -ForegroundColor Yellow
}

# -----------------------------------------------------------------------------
# FASE 9: REPORTE FINAL Y RECOMENDACIONES
# Estrategia: Resumen ejecutivo con guías de acción específicas
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host "📊 INFORME FINAL DE VERIFICACIÓN" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host ""

# Calcular métricas de salud del sistema
$healthScore = 0
$maxScore = 7

if ($pythonStatus -eq "available") { $healthScore++ }
if (Test-Path "venv_tesis") { $healthScore++ }
if ($dockerVersion) { $healthScore++ }
if ($imagenesTesis -and $imagenesTesis.Count -gt 1) { $healthScore++ }
if ($archivosCriticosOk -eq $archivosCriticosTotales) { $healthScore++ }
if ($nvidiaGpu) { $healthScore++ }
if ($contenedoresTesis -and $contenedoresTesis.Count -gt 1) { $healthScore++ }

Write-Host "🏥 PUNTAJE DE SALUD DEL SISTEMA: $healthScore/$maxScore" -ForegroundColor $(
    if ($healthScore -ge 6) { "Green" } elseif ($healthScore -ge 4) { "Yellow" } else { "Red" }
)

Write-Host ""
Write-Host "🎯 ESTADO GENERAL:" -ForegroundColor Cyan

if ($healthScore -eq $maxScore) {
    Write-Host "   🎉 ¡SISTEMA EN ESTADO ÓPTIMO!" -ForegroundColor Green
    Write-Host "   ✅ Todos los componentes funcionan correctamente" -ForegroundColor White
} elseif ($healthScore -ge 5) {
    Write-Host "   ✅ Sistema funcional con algunas advertencias" -ForegroundColor Green
} elseif ($healthScore -ge 3) {
    Write-Host "   ⚠️  Sistema necesita atención" -ForegroundColor Yellow
} else {
    Write-Host "   ❌ Sistema requiere intervención inmediata" -ForegroundColor Red
}

Write-Host ""
Write-Host "🚀 PLAN DE ACCIÓN RECOMENDADO:" -ForegroundColor Cyan

if (-not (Test-Path "venv_tesis")) {
    Write-Host "   1. 🔧 Reconstruir ambiente: .\uso_emergencia_reconstruir.ps1" -ForegroundColor White
}

if (-not $imagenesTesis -or $imagenesTesis.Count -le 1) {
    Write-Host "   2. 🐳 Construir contenedores: .\construir_contenedores.ps1" -ForegroundColor White
}

if ($archivosCriticosOk -ne $archivosCriticosTotales) {
    Write-Host "   3. 📁 Verificar estructura del proyecto" -ForegroundColor White
}

if ($healthScore -ge 5) {
    Write-Host "   4. 💻 Comenzar a trabajar: .\uso_diario_activar.ps1" -ForegroundColor White
}

Write-Host ""
Write-Host "💡 RECOMENDACIONES DE MANTENIMIENTO:" -ForegroundColor Cyan
Write-Host "   • Ejecuta esta verificación SEMANALMENTE" -ForegroundColor White
Write-Host "   • Mantén los contenedores actualizados" -ForegroundColor White
Write-Host "   • Backup regular de modelos y datos importantes" -ForegroundColor White
Write-Host "   • Monitorea uso de disco y RAM" -ForegroundColor White

Write-Host ""
Write-Host "📞 SOPORTE Y AYUDA:" -ForegroundColor Cyan
Write-Host "   • Scripts de emergencia para problemas críticos" -ForegroundColor White
Write-Host "   • Documentación en README.md" -ForegroundColor White
Write-Host "   • Logs detallados en scripts/logs/" -ForegroundColor White

Write-Host ""
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host "🔍 Verificación completada - $(Get-Date)" -ForegroundColor Gray
Write-Host "=" * 70 -ForegroundColor Cyan

$null = Read-Host "`nPresiona Enter para cerrar este reporte"

# Función auxiliar para verificar módulos de Python (si se necesita)
function Test-PythonModules {
    # Esta función se podría expandir para verificar módulos específicos
    Write-Host "     • 🔍 Verificando módulos Python..." -ForegroundColor Gray
    # Implementación opcional para verificar dependencias críticas
}
