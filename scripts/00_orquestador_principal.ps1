# =============================================
# ORQUESTADOR PRINCIPAL - TESIS EDGE AI
# =============================================
# 🎯 OBJETIVO: Coordinar todas las fases del proyecto de tesis
# 💡 USO: .\00_orquestador_principal.ps1 -Fase diario -Verificar
# 🔧 MANTENIMIENTO: Actualizar rutas si cambia estructura de scripts

# Ejemplos intuitivos:
# .\00_orquestador_principal.ps1 -Help
# .\00_orquestador_principal.ps1 -Fase diario
# .\00_orquestador_principal.ps1 -Fase experimentacion -Hipotesis HS1 -GPU

param(
    [string]$Fase = "diario",           # Fase a ejecutar: diario, validacion, experimentacion, deployment, completo
    [string]$Hipotesis = "",            # Hipótesis a entrenar: HS1, HS2, HS3, HS4, HS5
    [string]$Framework = "pytorch",     # Framework a usar: pytorch, tensorflow
    [switch]$GPU = $false,              # Usar GPU para entrenamiento (si está disponible)
    [switch]$Verificar = $false,        # Ejecutar verificaciones adicionales
    [switch]$Help = $false              # Mostrar ayuda detallada
)

# 📁 CONFIGURACIÓN DE RUTAS - ACTUALIZAR SI CAMBIA ESTRUCTURA
$ScriptsPath = "scripts"
$UsoDiarioPath = "$ScriptsPath\USO_DIARIO"
$UsoSemanalPath = "$ScriptsPath\USO_SEMANAL" 
$UsoEspecialPath = "$ScriptsPath\USO_ESPECIAL"
$UsoEmergenciaPath = "$ScriptsPath\USO_EMERGENCIA"
$VerificacionPath = "$ScriptsPath\VERIFICACION"

# 🎨 CONFIGURACIÓN DE COLORES PARA MEJOR LEGIBILIDAD
$ColorTitulo = "Cyan"
$ColorExito = "Green"
$ColorAdvertencia = "Yellow"
$ColorError = "Red"
$ColorInfo = "Gray"
$ColorDestacado = "Magenta"

function Show-Help {
    Write-Host "`n🎓 AYUDA - ORQUESTADOR TESIS EDGE AI" -ForegroundColor $ColorTitulo
    Write-Host "=" * 50 -ForegroundColor $ColorTitulo
    
    Write-Host "`n📋 PARÁMETROS DISPONIBLES:" -ForegroundColor $ColorDestacado
    Write-Host "   -Fase         : diario, validacion, experimentacion, deployment, completo" -ForegroundColor White
    Write-Host "   -Hipotesis    : HS1, HS2, HS3, HS4, HS5 (requerido para experimentacion)" -ForegroundColor White
    Write-Host "   -Framework    : pytorch (default), tensorflow" -ForegroundColor White
    Write-Host "   -GPU          : Usar GPU para entrenamiento (si está disponible)" -ForegroundColor White
    Write-Host "   -Verificar    : Ejecutar verificaciones adicionales" -ForegroundColor White
    Write-Host "   -Help         : Mostrar esta ayuda" -ForegroundColor White
    
    Write-Host "`n🚀 EJEMPLOS DE USO:" -ForegroundColor $ColorDestacado
    Write-Host "   .\$($MyInvocation.MyCommand.Name) -Fase diario" -ForegroundColor White
    Write-Host "   .\$($MyInvocation.MyCommand.Name) -Fase experimentacion -Hipotesis HS1 -GPU" -ForegroundColor White
    Write-Host "   .\$($MyInvocation.MyCommand.Name) -Fase completo -Verificar" -ForegroundColor White
    Write-Host "   .\$($MyInvocation.MyCommand.Name) -Help" -ForegroundColor White
    
    Write-Host "`n🎯 ESTRATEGIA RECOMENDADA:" -ForegroundColor $ColorExito
    Write-Host "   1. Desarrollo diario: -Fase diario" -ForegroundColor White
    Write-Host "   2. Validación semanal: -Fase validacion -Verificar" -ForegroundColor White
    Write-Host "   3. Experimentación: -Fase experimentacion -Hipotesis HS1 -GPU" -ForegroundColor White
    Write-Host "   4. Deployment edge: -Fase deployment" -ForegroundColor White
}

function Test-ScriptExiste {
    param([string]$ScriptPath)
    
    if (-not (Test-Path $ScriptPath)) {
        Write-Host "❌ Script no encontrado: $ScriptPath" -ForegroundColor $ColorError
        return $false
    }
    return $true
}

function Invoke-Phase {
    param([string]$PhaseName, [string]$Description, [scriptblock]$Action)
    
    Write-Host "`n🎯 $PhaseName" -ForegroundColor $ColorTitulo
    Write-Host "   $Description" -ForegroundColor $ColorInfo
    Write-Host "   Ejecutando..." -ForegroundColor $ColorInfo
    
    try {
        & $Action
        Write-Host "   ✅ $PhaseName completado" -ForegroundColor $ColorExito
        return $true
    }
    catch {
        Write-Host "   ❌ Error en $PhaseName : $_" -ForegroundColor $ColorError
        return $false
    }
}

# 🚀 INICIO DEL ORQUESTADOR
Write-Host "`n🎓 ORQUESTADOR TESIS DOCTORAL - EDGE AI" -ForegroundColor $ColorTitulo
Write-Host "==========================================" -ForegroundColor $ColorTitulo
Write-Host "Framework: $Framework | GPU: $GPU | Verificación: $Verificar" -ForegroundColor $ColorInfo

if ($Help) {
    Show-Help
    exit 0
}

# 🔍 VERIFICACIÓN INICIAL DE ESTRUCTURA
Write-Host "`n🔍 Verificando estructura de scripts..." -ForegroundColor $ColorAdvertencia
if (-not (Test-Path $ScriptsPath)) {
    Write-Host "❌ Carpeta de scripts no encontrada. Ejecuta desde la raíz del proyecto." -ForegroundColor $ColorError
    exit 1
}

# 🎯 EJECUCIÓN PRINCIPAL POR FASES
$success = $true

switch ($Fase.ToLower()) {
    "diario" {
        Write-Host "`n💻 FASE 1: DESARROLLO DIARIO" -ForegroundColor $ColorExito
        Write-Host "   Activando entorno de desarrollo $Framework..." -ForegroundColor $ColorInfo
        
        $success = $success -and (Invoke-Phase "Activación" "Preparando entorno de desarrollo" {
            & "$UsoDiarioPath\uso_activar.ps1" -Framework $Framework
        })
        
        $success = $success -and (Invoke-Phase "Jupyter" "Iniciando entorno interactivo" {
            & "$UsoDiarioPath\uso_jupyter.ps1"
        })
    }
    
    "validacion" {
        Write-Host "`n🐳 FASE 2: VALIDACIÓN" -ForegroundColor $ColorAdvertencia
        
        $success = $success -and (Invoke-Phase "Verificación" "Validando sistema completo" {
            & "$UsoSemanalPath\uso_verificar.ps1" -Framework $Framework
        })
        
        $success = $success -and (Invoke-Phase "Contenedores" "Iniciando entorno Docker" {
            Write-Host "   Iniciando contenedores de desarrollo..." -ForegroundColor $ColorInfo
            docker-compose up "desarrollo-$Framework" -d
            Write-Host "   ✅ Jupyter disponible: http://localhost:8888" -ForegroundColor $ColorExito
            Write-Host "   ✅ MLflow disponible: http://localhost:5000" -ForegroundColor $ColorExito
        })
    }
    
    "experimentacion" {
        Write-Host "`n🔬 FASE 3: EXPERIMENTACIÓN" -ForegroundColor $ColorDestacado
        
        if (-not $Hipotesis) {
            Write-Host "❌ Parámetro -Hipotesis requerido para experimentación" -ForegroundColor $ColorError
            Write-Host "   Opciones: HS1, HS2, HS3, HS4, HS5" -ForegroundColor White
            $success = $false
            break
        }
        
        $success = $success -and (Invoke-Phase "Entrenamiento" "Ejecutando experimento $Hipotesis" {
            & "$UsoSemanalPath\uso_entrenar.ps1" -Hipotesis $Hipotesis -Framework $Framework -GPU:$GPU
        })
    }
    
    "deployment" {
        Write-Host "`n📱 FASE 4: DEPLOYMENT EDGE" -ForegroundColor "Blue"
        
        $success = $success -and (Invoke-Phase "Preparación Edge" "Preparando modelo para Raspberry Pi" {
            & "$UsoEspecialPath\uso_edge.ps1" -Framework $Framework
        })
    }
    
    "completo" {
        Write-Host "`n🚀 EJECUCIÓN COMPLETA DEL SISTEMA" -ForegroundColor White -BackgroundColor DarkBlue
        
        # 🔧 FASE 0: CONFIGURACIÓN INICIAL
        $success = $success -and (Invoke-Phase "Estructura" "Creando estructura de carpetas M1-M9" {
            & "$ScriptsPath\01_crear_estructura.ps1"
        })
        
        $success = $success -and (Invoke-Phase "Dependencias" "Generando archivos de requerimientos" {
            & "$ScriptsPath\02_crear_dependencias.ps1"
        })
        
        $success = $success -and (Invoke-Phase "Sincronización" "Sincronizando estructura de requerimientos" {
            & "$ScriptsPath\05_sincronizar_requerimientos.ps1"
        })
        
        # 🧠 FASE 1: CONFIGURACIÓN FRAMEWORK
        $configScript = if ($Framework -eq "pytorch") { "03a_configurar_pytorch.ps1" } else { "03b_configurar_tensorflow.ps1" }
        $success = $success -and (Invoke-Phase "Framework" "Configurando $Framework" {
            & "$ScriptsPath\$configScript"
        })
        
        # 🚀 FASE 2: VERIFICACIÓN FINAL
        $success = $success -and (Invoke-Phase "Activación" "Probando entorno configurado" {
            & "$UsoDiarioPath\uso_activar.ps1" -Framework $Framework
        })
        
        $success = $success -and (Invoke-Phase "Verificación" "Validando instalación completa" {
            & "$UsoSemanalPath\uso_verificar.ps1" -Framework $Framework
        })
    }
    
    default {
        Write-Host "❌ Fase no reconocida: '$Fase'" -ForegroundColor $ColorError
        Write-Host "💡 Opciones válidas: diario, validacion, experimentacion, deployment, completo" -ForegroundColor White
        $success = $false
    }
}

# 🔍 VERIFICACIÓN ADICIONAL SI SE SOLICITA
if ($Verificar -and $success) {
    Write-Host "`n🔍 VERIFICACIÓN ADICIONAL SOLICITADA..." -ForegroundColor $ColorAdvertencia
    
    $success = $success -and (Invoke-Phase "Verificación Estructura" "Validando estructura de proyecto" {
        & "$VerificacionPath\verificar_estructura.ps1"
    })
    
    $success = $success -and (Invoke-Phase "Verificación Sistema" "Validando estado del sistema" {
        & "$UsoSemanalPath\uso_verificar.ps1" -Framework $Framework
    })
}

# 📊 REPORTE FINAL
Write-Host "`n" + "="*50 -ForegroundColor $ColorTitulo
if ($success) {
    Write-Host "🎉 ORQUESTACIÓN COMPLETADA EXITOSAMENTE" -ForegroundColor $ColorExito -BackgroundColor DarkGreen
    Write-Host "   Fase ejecutada: $Fase" -ForegroundColor White
    Write-Host "   Framework: $Framework" -ForegroundColor White
    if ($Hipotesis) { Write-Host "   Hipótesis: $Hipotesis" -ForegroundColor White }
} else {
    Write-Host "❌ ORQUESTACIÓN CON ERRORES" -ForegroundColor $ColorError -BackgroundColor DarkRed
    Write-Host "   Revisa los mensajes de error arriba" -ForegroundColor White
}

Write-Host "`n💡 PRÓXIMOS PASOS SUGERIDOS:" -ForegroundColor $ColorAdvertencia
switch ($Fase.ToLower()) {
    "diario" { Write-Host "   - Abre Jupyter en: http://localhost:8888" -ForegroundColor White }
    "validacion" { Write-Host "   - Verifica métricas en MLflow: http://localhost:5000" -ForegroundColor White }
    "experimentacion" { Write-Host "   - Revisa resultados en: experimentos/cap5_resultados/" -ForegroundColor White }
    "deployment" { Write-Host "   - Transfiere modelo a Raspberry Pi" -ForegroundColor White }
    "completo" { Write-Host "   - Comienza a desarrollar en: codigo/Componentes/" -ForegroundColor White }
}

exit $(if ($success) { 0 } else { 1 })
