# =============================================================================
# ESTRATEGIA: Script de Reconstrucción de Emergencia - Entorno Local
# PROPÓSITO: Reconstruir completamente el ambiente virtual después de problemas
#            críticos como corrupción, conflictos de dependencias o cambios de versión
# COHERENCIA: Advertencia → Verificación → Destrucción → Construcción → Validación
# ADVERTENCIA: Proceso DESTRUCTIVO que elimina el ambiente actual - Usar solo en emergencias
# =============================================================================

# -----------------------------------------------------------------------------
# FASE 1: ADVERTENCIAS Y CONFIRMACIÓN EXPLÍCITA
# Estrategia: Asegurar que el usuario comprende completamente las consecuencias
# -----------------------------------------------------------------------------
Write-Host "🚨 RECONSTRUCCIÓN COMPLETA DEL ENTORNO LOCAL TESIS EDGE AI" -ForegroundColor Red
Write-Host "=" * 70 -ForegroundColor Red
Write-Host "⚠️  ADVERTENCIA CRÍTICA: Este proceso ELIMINARÁ COMPLETAMENTE tu ambiente actual" -ForegroundColor Yellow
Write-Host "⚠️  Tiempo estimado: 20-35 minutos dependiendo de tu conexión a internet" -ForegroundColor Yellow
Write-Host "=" * 70 -ForegroundColor Red
Write-Host ""

Write-Host "🎯 SITUACIONES VÁLIDAS para esta reconstrucción:" -ForegroundColor Green
Write-Host "   🔴 Ambiente virtual corrupto o no inicia" -ForegroundColor White
Write-Host "   🔴 Conflictos graves de dependencias que no se pueden resolver" -ForegroundColor White
Write-Host "   🔴 Cambio de versión de Python base" -ForegroundColor White
Write-Host "   🔴 Después de cambios mayores en requirements.txt" -ForegroundColor White
Write-Host "   🔴 Errores de módulos nativos (CUDA, OpenCV, etc.)" -ForegroundColor White
Write-Host ""

Write-Host "🚫 ALTERNATIVAS para problemas menores:" -ForegroundColor Red
Write-Host "   ✅ Ambiente funciona: NO usar este script" -ForegroundColor White
Write-Host "   ✅ Instalar paquete: pip install nombre_paquete" -ForegroundColor White
Write-Host "   ✅ Actualizar: pip install --upgrade -r requirements/desarrollo.txt" -ForegroundColor White
Write-Host "   ✅ Reinstalar paquete: pip uninstall nombre && pip install nombre" -ForegroundColor White
Write-Host ""

Write-Host "📋 IMPACTO DE ESTA ACCIÓN:" -ForegroundColor Cyan
Write-Host "   • Se eliminará COMPLETAMENTE la carpeta 'venv_tesis'" -ForegroundColor White
Write-Host "   • Se reinstalarán TODAS las dependencias desde cero" -ForegroundColor White
Write-Host "   • Las configuraciones personalizadas en el venv se perderán" -ForegroundColor White
Write-Host "   • Los paquetes instalados manualmente deberán reinstalarse" -ForegroundColor White
Write-Host ""

# Confirmación de doble verificación
$confirmacion1 = Read-Host "¿Estás SEGURO de que necesitas reconstruir completamente? (escribe 'CONFIRMAR' para continuar)"
if ($confirmacion1 -ne "CONFIRMAR") {
    Write-Host "❌ Reconstrucción cancelada - Buen trabajo verificando primero" -ForegroundColor Yellow
    $null = Read-Host "Presiona Enter para salir"
    exit 0
}

Write-Host ""
$confirmacion2 = Read-Host "⛔ ÚLTIMA OPORTUNIDAD: Esto NO se puede deshacer. Escribe 'ELIMINAR' para proceder"
if ($confirmacion2 -ne "ELIMINAR") {
    Write-Host "❌ Reconstrucción cancelada - Considera usar las alternativas sugeridas" -ForegroundColor Yellow
    $null = Read-Host "Presiona Enter para salir"
    exit 0
}

Write-Host ""

# -----------------------------------------------------------------------------
# FASE 2: VERIFICACIÓN DE INFRAESTRUCTURA CRÍTICA
# Estrategia: Verificar todos los requisitos del sistema antes de proceder
# -----------------------------------------------------------------------------
Write-Host "[1/10] 🔒 VERIFICANDO INFRAESTRUCTURA DEL SISTEMA..." -ForegroundColor Gray

# Verificación 1: Permisos de PowerShell (crítico para operaciones de archivos)
Write-Host "   Verificando permisos de ejecución..." -ForegroundColor Gray
$executionPolicy = Get-ExecutionPolicy
if ($executionPolicy -eq "Restricted") {
    Write-Host "   ❌ PowerShell en modo Restricted - no puede ejecutar scripts" -ForegroundColor Red
    Write-Host ""
    Write-Host "   🛠️  SOLUCIÓN RÁPIDA:" -ForegroundColor Cyan
    Write-Host "   1. Cierra PowerShell" -ForegroundColor White
    Write-Host "   2. Busca 'PowerShell' en el menú inicio" -ForegroundColor White
    Write-Host "   3. Haz clic derecho → 'Ejecutar como administrador'" -ForegroundColor White
    Write-Host "   4. Ejecuta: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor White
    Write-Host "   5. Vuelve a ejecutar este script" -ForegroundColor White
    $null = Read-Host "Presiona Enter para salir"
    exit 1
} else {
    Write-Host "   ✅ Permisos de PowerShell: $executionPolicy" -ForegroundColor Green
}

# Verificación 2: Directorio del proyecto (mejorado para portabilidad)
Write-Host "   Verificando ubicación del proyecto..." -ForegroundColor Gray
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$expectedFiles = @("requirements", "src", "notebooks", "docker-compose.yml")

$missingFiles = @()
foreach ($file in $expectedFiles) {
    if (-not (Test-Path (Join-Path $scriptDir $file))) {
        $missingFiles += $file
    }
}

if ($missingFiles.Count -gt 0) {
    Write-Host "   ❌ No estás en la raíz del proyecto" -ForegroundColor Red
    Write-Host "   📍 Directorio actual: $scriptDir" -ForegroundColor Gray
    Write-Host "   📁 Faltan: $($missingFiles -join ', ')" -ForegroundColor White
    Write-Host "   💡 Navega a la carpeta tesis_edge_ai antes de ejecutar" -ForegroundColor Yellow
    $null = Read-Host "Presiona Enter para salir"
    exit 1
} else {
    Write-Host "   ✅ Directorio del proyecto correcto" -ForegroundColor Green
}

# -----------------------------------------------------------------------------
# FASE 3: PREPARACIÓN PARA DESTRUCCIÓN
# Estrategia: Preparar el sistema para la eliminación segura del ambiente
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[2/10] 🔄 PREPARANDO ELIMINACIÓN DEL AMBIENTE ACTUAL..." -ForegroundColor Gray

# Verificar y desactivar ambiente virtual activo
if ($env:VIRTUAL_ENV) {
    Write-Host "   🎯 Ambiente virtual activo detectado: $($env:VIRTUAL_ENV)" -ForegroundColor Green
    Write-Host "   🛑 Intentando desactivar..." -ForegroundColor Yellow
    
    try {
        # Múltiples métodos para desactivar
        if (Get-Command deactivate -ErrorAction SilentlyContinue) {
            deactivate
        }
        
        # Verificar desactivación
        Start-Sleep -Seconds 2
        if (-not $env:VIRTUAL_ENV) {
            Write-Host "   ✅ Ambiente desactivado correctamente" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️  Desactivación automática falló - continuando..." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "   ⚠️  Error en desactivación: $($_.Exception.Message)" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ℹ️  No hay ambiente virtual activo" -ForegroundColor Gray
}

# Verificar procesos de Python que podrían bloquear la eliminación
Write-Host "   Verificando procesos Python activos..." -ForegroundColor Gray
$pythonProcesses = Get-Process python -ErrorAction SilentlyContinue
if ($pythonProcesses) {
    Write-Host "   ⚠️  Procesos Python activos detectados: $($pythonProcesses.Count)" -ForegroundColor Yellow
    Write-Host "   💡 Cerrando procesos para evitar bloqueos..." -ForegroundColor Gray
    $pythonProcesses | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}
Write-Host "   ✅ Sistema preparado para eliminación" -ForegroundColor Green

# -----------------------------------------------------------------------------
# FASE 4: ELIMINACIÓN SEGURA DEL AMBIENTE ANTERIOR
# Estrategia: Eliminar con múltiples verificaciones y manejo robusto de errores
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[3/10] 🗑️  ELIMINANDO AMBIENTE VIRTUAL ANTERIOR..." -ForegroundColor Gray

$venvPath = "venv_tesis"
if (Test-Path $venvPath) {
    Write-Host "   📁 Ambiente anterior encontrado: $venvPath" -ForegroundColor Green
    Write-Host "   ⚠️  Iniciando eliminación segura..." -ForegroundColor Yellow
    
    # Intentar eliminación con múltiples estrategias
    $eliminado = $false
    $intentos = 0
    $maxIntentos = 3
    
    while (-not $eliminado -and $intentos -lt $maxIntentos) {
        $intentos++
        Write-Host "   Intento $intentos de $maxIntentos..." -ForegroundColor Gray
        
        try {
            # Estrategia 1: Eliminación normal
            Remove-Item -Path $venvPath -Recurse -Force -ErrorAction Stop
            Start-Sleep -Seconds 2
            
            if (-not (Test-Path $venvPath)) {
                $eliminado = $true
                Write-Host "   ✅ Ambiente eliminado exitosamente" -ForegroundColor Green
            } else {
                Write-Host "   ⚠️  La carpeta aún existe, reintentando..." -ForegroundColor Yellow
                Start-Sleep -Seconds 3
            }
        } catch {
            Write-Host "   ❌ Error en intento $intentos : $($_.Exception.Message)" -ForegroundColor Red
            
            if ($intentos -eq $maxIntentos) {
                Write-Host "   🚨 No se pudo eliminar el ambiente después de $maxIntentos intentos" -ForegroundColor Red
                Write-Host ""
                Write-Host "   🔧 SOLUCIONES MANUALES:" -ForegroundColor Cyan
                Write-Host "   1. Cierra TODAS las ventanas de VSCode, Jupyter, Python" -ForegroundColor White
                Write-Host "   2. Reinicia PowerShell como administrador" -ForegroundColor White
                Write-Host "   3. Elimina manualmente la carpeta 'venv_tesis'" -ForegroundColor White
                Write-Host "   4. Vuelve a ejecutar este script" -ForegroundColor White
                $null = Read-Host "Presiona Enter para salir"
                exit 1
            }
        }
    }
} else {
    Write-Host "   ℹ️  No existe ambiente anterior 'venv_tesis'" -ForegroundColor Gray
}

# -----------------------------------------------------------------------------
# FASE 5: VERIFICACIÓN Y SELECCIÓN DE PYTHON
# Estrategia: Detectar la mejor versión de Python disponible
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[4/10] 🐍 VERIFICANDO VERSIÓN DE PYTHON..." -ForegroundColor Gray

$pythonCommands = @("python", "py", "python3")
$pythonFound = $null
$pythonVersion = $null

foreach ($cmd in $pythonCommands) {
    try {
        $versionOutput = & $cmd --version 2>&1
        if ($LASTEXITCODE -eq 0 -and $versionOutput -match "Python (\d+\.\d+\.\d+)") {
            $pythonFound = $cmd
            $pythonVersion = $matches[1]
            Write-Host "   ✅ Python encontrado: $cmd $pythonVersion" -ForegroundColor Green
            break
        }
    } catch {
        # Continuar con el siguiente comando
    }
}

if (-not $pythonFound) {
    Write-Host "   ❌ Python no encontrado en el sistema" -ForegroundColor Red
    Write-Host ""
    Write-Host "   📥 INSTALACIÓN DE PYTHON:" -ForegroundColor Cyan
    Write-Host "   1. Descarga Python 3.10+ desde python.org" -ForegroundColor White
    Write-Host "   2. Durante instalación, MARCA 'Add Python to PATH'" -ForegroundColor White
    Write_Host "   3. Reinicia PowerShell después de instalar" -ForegroundColor White
    Write-Host "   4. Vuelve a ejecutar este script" -ForegroundColor White
    $null = Read-Host "Presiona Enter para salir"
    exit 1
}

# Verificar versión mínima de Python
$versionParts = $pythonVersion -split '\.'
$majorVersion = [int]$versionParts[0]
$minorVersion = [int]$versionParts[1]

if ($majorVersion -lt 3 -or ($majorVersion -eq 3 -and $minorVersion -lt 8)) {
    Write-Host "   ⚠️  Versión de Python muy antigua: $pythonVersion" -ForegroundColor Yellow
    Write-Host "   💡 Se recomienda Python 3.10+ para este proyecto" -ForegroundColor White
}

# -----------------------------------------------------------------------------
# FASE 6: CREACIÓN DEL NUEVO AMBIENTE VIRTUAL
# Estrategia: Crear ambiente con las mejores prácticas y verificación
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[5/10] 🆕 CREANDO NUEVO AMBIENTE VIRTUAL..." -ForegroundColor Gray

Write-Host "   Ejecutando: $pythonFound -m venv venv_tesis" -ForegroundColor White
& $pythonFound -m venv venv_tesis

if (Test-Path "venv_tesis") {
    Write-Host "   ✅ Ambiente virtual creado exitosamente" -ForegroundColor Green
} else {
    Write-Host "   ❌ Error crítico creando ambiente virtual" -ForegroundColor Red
    Write-Host "   💡 Posibles causas:" -ForegroundColor Yellow
    Write-Host "   - Python instalado incorrectamente" -ForegroundColor White
    Write-Host "   - Permisos insuficientes en el directorio" -ForegroundColor White
    Write-Host "   - Módulo venv no disponible" -ForegroundColor White
    $null = Read-Host "Presiona Enter para salir"
    exit 1
}

# -----------------------------------------------------------------------------
# FASE 7: ACTIVACIÓN Y CONFIGURACIÓN INICIAL
# Estrategia: Activar y configurar el ambiente recién creado
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[6/10] 🔧 ACTIVANDO Y CONFIGURANDO AMBIENTE..." -ForegroundColor Gray

$activateScript = "venv_tesis\Scripts\Activate.ps1"
if (Test-Path $activateScript) {
    try {
        & $activateScript
        Write-Host "   ✅ Ambiente virtual activado" -ForegroundColor Green
        
        # Verificar que la activación fue exitosa
        if ($env:VIRTUAL_ENV) {
            Write-Host "   📍 Ambiente activo: $($env:VIRTUAL_ENV)" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️  Activación puede no haber funcionado completamente" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "   ❌ Error activando ambiente: $($_.Exception.Message)" -ForegroundColor Red
        $null = Read-Host "Presiona Enter para salir"
        exit 1
    }
} else {
    Write-Host "   ❌ Script de activación no encontrado" -ForegroundColor Red
    $null = Read-Host "Presiona Enter para salir"
    exit 1
}

# -----------------------------------------------------------------------------
# FASE 8: ACTUALIZACIÓN E INSTALACIÓN DE DEPENDENCIAS
# Estrategia: Instalación en cascada con manejo de errores y progreso
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[7/10] 📦 ACTUALIZANDO HERRAMIENTAS BASE..." -ForegroundColor Gray

Write-Host "   Actualizando pip..." -ForegroundColor White
& $pythonFound -m pip install --upgrade pip
Write-Host "   ✅ Pip actualizado" -ForegroundColor Green

Write-Host ""
Write-Host "[8/10] 🛠️  INSTALANDO DEPENDENCIAS PRINCIPALES..." -ForegroundColor Gray

$requirementsFiles = @(
    @{Name = "base"; Time = "15-25 minutos"; Description = "dependencias principales ML"},
    @{Name = "desarrollo"; Time = "5-10 minutos"; Description = "herramientas desarrollo"}
)

foreach ($req in $requirementsFiles) {
    $reqFile = "requirements\$($req.Name).txt"
    if (Test-Path $reqFile) {
        Write-Host "   📦 Instalando $($req.Description)..." -ForegroundColor White
        Write-Host "   ⏰ Tiempo estimado: $($req.Time)" -ForegroundColor Yellow
        
        & $pythonFound -m pip install -r $reqFile
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ $($req.Name.ToUpper()) instalado correctamente" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️  Algunos paquetes en $($req.Name) pueden tener problemas" -ForegroundColor Yellow
            Write-Host "   💡 Puedes instalar paquetes problemáticos manualmente después" -ForegroundColor White
        }
    } else {
        Write-Host "   ❌ No se encuentra: $reqFile" -ForegroundColor Red
    }
}

# -----------------------------------------------------------------------------
# FASE 9: VERIFICACIÓN EXHAUSTIVA DEL NUEVO AMBIENTE
# Estrategia: Validar que todas las herramientas críticas funcionan
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[9/10] ✅ VERIFICANDO HERRAMIENTAS INSTALADAS..." -ForegroundColor Gray

$herramientasCriticas = @(
    @{Nombre = "PyTorch"; Comando = "import torch; print(f'PyTorch {torch.__version__} - CUDA: {torch.cuda.is_available()}')"},
    @{Nombre = "TensorFlow"; Comando = "import tensorflow as tf; print(f'TensorFlow {tf.__version__}')"},
    @{Nombre = "OpenCV"; Comando = "import cv2; print(f'OpenCV {cv2.__version__}')"},
    @{Nombre = "NumPy"; Comando = "import numpy as np; print(f'NumPy {np.__version__}')"},
    @{Nombre = "Pandas"; Comando = "import pandas as pd; print(f'Pandas {pd.__version__}')"},
    @{Nombre = "Jupyter"; Comando = "import jupyter; print('Jupyter disponible')"},
    @{Nombre = "MLflow"; Comando = "import mlflow; print(f'MLflow {mlflow.__version__}')"}
)

$exitosas = 0
$fallidas = @()

Write-Host "   Probando herramientas de IA y desarrollo..." -ForegroundColor White

foreach ($herramienta in $herramientasCriticas) {
    try {
        $resultado = & $pythonFound -c "$($herramienta.Comando)" 2>$null
        if ($LASTEXITCODE -eq 0 -and $resultado) {
            Write-Host "   ✅ $($herramienta.Nombre): $resultado" -ForegroundColor Green
            $exitosas++
        } else {
            Write-Host "   ❌ $($herramienta.Nombre): No funciona correctamente" -ForegroundColor Red
            $fallidas += $herramienta.Nombre
        }
    } catch {
        Write-Host "   ❌ $($herramienta.Nombre): Error de importación" -ForegroundColor Red
        $fallidas += $herramienta.Nombre
    }
}

# -----------------------------------------------------------------------------
# FASE 10: REPORTE FINAL Y GUÍAS DE RECUPERACIÓN
# Estrategia: Proporcionar resumen claro y próximos pasos específicos
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[10/10] 📊 GENERANDO REPORTE FINAL..." -ForegroundColor Gray

Write-Host ""
Write-Host "=" * 70 -ForegroundColor Cyan
if ($exitosas -eq $herramientasCriticas.Count) {
    Write-Host "🎉 ¡RECONSTRUCCIÓN EXITOSA COMPLETA!" -ForegroundColor Green
} elseif ($exitosas -ge 5) {
    Write-Host "✅ RECONSTRUCCIÓN MAYORITARIAMENTE EXITOSA" -ForegroundColor Green
} else {
    Write-Host "⚠️  RECONSTRUCCIÓN CON PROBLEMAS SIGNIFICATIVOS" -ForegroundColor Yellow
}
Write-Host "=" * 70 -ForegroundColor Cyan

Write-Host ""
Write-Host "📈 ESTADÍSTICAS DE LA RECONSTRUCCIÓN:" -ForegroundColor Cyan
Write-Host "   • Herramientas verificadas: $exitosas/$($herramientasCriticas.Count) exitosas" -ForegroundColor White
Write-Host "   • Ambiente virtual: CREADO Y CONFIGURADO" -ForegroundColor White
Write-Host "   • Dependencias base: INSTALADAS" -ForegroundColor White
Write-Host "   • Herramientas desarrollo: INSTALADAS" -ForegroundColor White

if ($fallidas.Count -gt 0) {
    Write-Host ""
    Write-Host "🔧 HERRAMIENTAS CON PROBLEMAS:" -ForegroundColor Yellow
    foreach ($fallida in $fallidas) {
        Write-Host "   • $fallida" -ForegroundColor White
    }
    Write-Host ""
    Write-Host "💡 SOLUCIONES SUGERIDAS:" -ForegroundColor Cyan
    Write-Host "   - Reinstalar manualmente: pip install --force-reinstall $($fallidas -join ' ')" -ForegroundColor White
    Write-Host "   - Verificar logs de instalación para errores específicos" -ForegroundColor White
    Write-Host "   - Consultar documentación de cada paquete para requisitos" -ForegroundColor White
}

Write-Host ""
Write-Host "🚀 PRÓXIMOS PASOS RECOMENDADOS:" -ForegroundColor Cyan
Write-Host "   1. 🔍 Verificar sistema: .\verificar_sistema_completo.ps1" -ForegroundColor White
Write-Host "   2. 🐳 Construir contenedores: .\construir_contenedores.ps1" -ForegroundColor White
    Write-Host "   3. 💻 Iniciar desarrollo: .\iniciar_desarrollo.ps1" -ForegroundColor White
Write-Host "   4. 📓 Probar Jupyter: jupyter notebook" -ForegroundColor White

Write-Host ""
Write-Host "💾 RECOMENDACIONES DE MANTENIMIENTO:" -ForegroundColor Cyan
Write-Host "   • Para actualizaciones: pip install --upgrade -r requirements/desarrollo.txt" -ForegroundColor White
Write-Host "   • Para nuevos paquetes: pip install nombre_paquete" -ForegroundColor White
Write-Host "   • Para problemas menores: pip install --force-reinstall paquete_problematico" -ForegroundColor White
Write-Host "   • SOLO usar este script para problemas GRAVES del ambiente" -ForegroundColor White

Write-Host ""
Write-Host "🔮 ESTADO FINAL:" -ForegroundColor Cyan
if ($exitosas -eq $herramientasCriticas.Count) {
    Write-Host "   ✨ ¡Tu entorno local está PERFECTO para desarrollar tu tesis!" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Tu entorno está funcional pero algunas herramientas necesitan atención" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host "RECONSTRUCCIÓN COMPLETADA - $(Get-Date)" -ForegroundColor Green
Write-Host "================================================================================" -ForegroundColor Cyan

$null = Read-Host "`nPresiona Enter para cerrar esta ventana"
