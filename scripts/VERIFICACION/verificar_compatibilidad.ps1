# =============================================================================
# ESTRATEGIA: Script de Verificación de Compatibilidad de Frameworks ML
# PROPÓSITO: Prevenir conflictos entre PyTorch y TensorFlow en el entorno de tesis
# COHERENCIA: Detección → Diagnóstico → Recomendaciones específicas
# CONTEXTO: PyTorch es el framework principal, TensorFlow solo para comparativas
# =============================================================================

# -----------------------------------------------------------------------------
# FASE 1: ENCABEZADO Y CONTEXTO
# Estrategia: Explicar claramente el problema que se está evitando
# -----------------------------------------------------------------------------
Write-Host "🔍 VERIFICADOR DE COMPATIBILIDAD - FRAMEWORKS DE MACHINE LEARNING" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host "🎯 Objetivo: Prevenir conflictos entre PyTorch y TensorFlow" -ForegroundColor Gray
Write-Host "💡 Contexto: PyTorch (principal) vs TensorFlow (solo comparativos)" -ForegroundColor Gray
Write-Host "⚠️  Problema: Instalaciones simultáneas causan errores CUDA/memoria" -ForegroundColor Gray
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host ""

# -----------------------------------------------------------------------------
# FASE 2: FUNCIONES DE VERIFICACIÓN DETALLADA
# Estrategia: Verificación exhaustiva más allá de la simple existencia
# -----------------------------------------------------------------------------

function Test-PyTorchDetallado {
    <#
    .DESCRIPTION
    Verifica instalación de PyTorch con detalles de versión y capacidades
    #>
    try {
        $comandoPyTorch = @'
import torch
print(f"Version:{torch.__version__}")
print(f"CUDA:{torch.cuda.is_available()}")
print(f"CUDA Version:{torch.version.cuda if torch.cuda.is_available() else 'N/A'}")
print(f"Backend:{torch.backends.cudnn.enabled if hasattr(torch.backends, 'cudnn') else 'N/A'}")
'@
        $resultado = python -c $comandoPyTorch 2>$null
        if ($LASTEXITCODE -eq 0) {
            $lineas = $resultado -split "`n"
            return @{
                Instalado = $true
                Version = $lineas[0].Replace("Version:", "").Trim()
                CUDA = [bool]::Parse($lineas[1].Replace("CUDA:", "").Trim())
                CUDAVersion = $lineas[2].Replace("CUDA Version:", "").Trim()
                Backend = $lineas[3].Replace("Backend:", "").Trim()
            }
        }
    } catch {
        # Error silencioso, se maneja en el retorno
    }
    return @{Instalado = $false}
}

function Test-TensorFlowDetallado {
    <#
    .DESCRIPTION
    Verifica instalación de TensorFlow con detalles de versión y GPU
    #>
    try {
        $comandoTF = @'
import tensorflow as tf
print(f"Version:{tf.__version__}")
print(f"GPU:{tf.test.is_gpu_available()}")
gpu_devices = tf.config.experimental.list_physical_devices('GPU')
print(f"GPUs:{len(gpu_devices)}")
'@
        $resultado = python -c $comandoTF 2>$null
        if ($LASTEXITCODE -eq 0) {
            $lineas = $resultado -split "`n"
            return @{
                Instalado = $true
                Version = $lineas[0].Replace("Version:", "").Trim()
                GPU = [bool]::Parse($lineas[1].Replace("GPU:", "").Trim())
                GPUs = [int]$lineas[2].Replace("GPUs:", "").Trim()
            }
        }
    } catch {
        # Error silencioso, se maneja en el retorno
    }
    return @{Instalado = $false}
}

function Test-CompatibilidadCUDA {
    <#
    .DESCRIPTION
    Verifica si hay conflictos potenciales de versión de CUDA
    #>
    $pytorch = Test-PyTorchDetallado
    $tensorflow = Test-TensorFlowDetallado
    
    if ($pytorch.Instalado -and $tensorflow.Instalado) {
        # Verificar si ambos intentan usar CUDA simultáneamente
        if ($pytorch.CUDA -and $tensorflow.GPU) {
            Write-Host "   ⚠️  AMBOS frameworks configurados para GPU - Riesgo de conflicto" -ForegroundColor Red
            return $false
        }
    }
    return $true
}

# -----------------------------------------------------------------------------
# FASE 3: VERIFICACIÓN PRINCIPAL Y DIAGNÓSTICO
# Estrategia: Análisis comprehensivo del estado de los frameworks
# -----------------------------------------------------------------------------
Write-Host "[1/3] 🔍 ANALIZANDO INSTALACIONES DE FRAMEWORKS..." -ForegroundColor Gray

$pytorchInfo = Test-PyTorchDetallado
$tensorflowInfo = Test-TensorFlowDetallado

Write-Host ""
Write-Host "[2/3] 📊 ESTADO ACTUAL DETECTADO:" -ForegroundColor Gray

$conflictoDetectado = $false

# Mostrar estado de PyTorch
if ($pytorchInfo.Instalado) {
    Write-Host "   🎯 PYTORCH: $($pytorchInfo.Version)" -ForegroundColor Green
    Write-Host "     • CUDA: $($pytorchInfo.CUDA)" -ForegroundColor $(if ($pytorchInfo.CUDA) { "Green" } else { "Yellow" })
    if ($pytorchInfo.CUDA) {
        Write-Host "     • Versión CUDA: $($pytorchInfo.CUDAVersion)" -ForegroundColor White
    }
} else {
    Write-Host "   📭 PyTorch: No instalado" -ForegroundColor Gray
}

# Mostrar estado de TensorFlow
if ($tensorflowInfo.Instalado) {
    Write-Host "   🔄 TENSORFLOW: $($tensorflowInfo.Version)" -ForegroundColor $(if ($pytorchInfo.Instalado) { "Yellow" } else { "Green" })
    Write-Host "     • GPU: $($tensorflowInfo.GPU)" -ForegroundColor $(if ($tensorflowInfo.GPU) { "Green" } else { "Yellow" })
    Write-Host "     • GPUs detectadas: $($tensorflowInfo.GPUs)" -ForegroundColor White
} else {
    Write-Host "   📭 TensorFlow: No instalado" -ForegroundColor Gray
}

# -----------------------------------------------------------------------------
# FASE 4: DETECCIÓN DE CONFLICTOS Y RECOMENDACIONES
# Estrategia: Diagnóstico específico basado en el estado detectado
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[3/3] 🩺 DIAGNÓSTICO DE COMPATIBILIDAD..." -ForegroundColor Gray

if ($pytorchInfo.Instalado -and $tensorflowInfo.Instalado) {
    Write-Host "   ❌ CONFLICTO POTENCIAL: Ambos frameworks instalados" -ForegroundColor Red
    Write-Host "   ⚠️  Problemas comunes:" -ForegroundColor Yellow
    Write-Host "     • Conflictos de memoria GPU" -ForegroundColor White
    Write-Host "     • Versiones incompatibles de CUDA/cuDNN" -ForegroundColor White
    Write-Host "     • Errores de inicialización de dispositivos" -ForegroundColor White
    $conflictoDetectado = $true
    
    # Verificar compatibilidad CUDA específica
    $cudaCompat = Test-CompatibilidadCUDA
    if (-not $cudaCompat) {
        Write-Host "   🚨 CONFLICTO CRÍTICO: Ambos frameworks usando GPU simultáneamente" -ForegroundColor Red
    }
    
} elseif ($pytorchInfo.Instalado) {
    Write-Host "   ✅ CONFIGURACIÓN ÓPTIMA: Solo PyTorch instalado" -ForegroundColor Green
    Write-Host "   🎯 Framework principal para la tesis - Edge AI con PyTorch" -ForegroundColor Cyan
    
} elseif ($tensorflowInfo.Instalado) {
    Write-Host "   ⚠️  CONFIGURACIÓN ALTERNATIVA: Solo TensorFlow instalado" -ForegroundColor Yellow
    Write-Host "   💡 Usar para comparativas, no como framework principal" -ForegroundColor White
    
} else {
    Write-Host "   📋 SISTEMA VACÍO: Ningún framework de ML instalado" -ForegroundColor Blue
    Write-Host "   🔧 Se requiere configuración inicial del entorno" -ForegroundColor White
}

# -----------------------------------------------------------------------------
# FASE 5: PLAN DE ACCIÓN ESPECÍFICO
# Estrategia: Recomendaciones concretas basadas en el diagnóstico
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "💡 PLAN DE ACCIÓN RECOMENDADO:" -ForegroundColor Cyan

if ($conflictoDetectado) {
    Write-Host "   🚨 SITUACIÓN: Conflicto detectado - Se requiere acción" -ForegroundColor Red
    Write-Host ""
    Write-Host "   1. 🎯 OPCIÓN RECOMENDADA (PyTorch principal):" -ForegroundColor White
    Write-Host "      • Desinstalar TensorFlow: pip uninstall tensorflow" -ForegroundColor Gray
    Write-Host "      • Verificar: .\verificar_compatibilidad.ps1" -ForegroundColor Gray
    Write-Host ""
    Write-Host "   2. 🔄 OPCIÓN ALTERNATIVA (Solo comparativas):" -ForegroundColor White
    Write-Host "      • Desinstalar PyTorch: pip uninstall torch" -ForegroundColor Gray
    Write-Host "      • Usar TensorFlow temporalmente" -ForegroundColor Gray
    Write-Host ""
    Write-Host "   3. 🗑️  OPCIÓN NUCLEAR (Reset completo):" -ForegroundColor White
    Write-Host "      • Reconstruir ambiente: .\uso_emergencia_reconstruir.ps1" -ForegroundColor Gray
    Write-Host "      • Configurar solo PyTorch" -ForegroundColor Gray
    
} elseif ($pytorchInfo.Instalado) {
    Write-Host "   ✅ SITUACIÓN: Configuración óptima detectada" -ForegroundColor Green
    Write-Host ""
    Write-Host "   • Continuar con desarrollo en PyTorch" -ForegroundColor White
    Write-Host "   • Para comparativas, usar contenedores aislados" -ForegroundColor White
    Write-Host "   • Ejecutar experimentos: .\uso_semanal_entrenar.ps1" -ForegroundColor White
    
} elseif ($tensorflowInfo.Instalado) {
    Write-Host "   ⚠️  SITUACIÓN: Configuración subóptima" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "   • Migrar a PyTorch para desarrollo principal" -ForegroundColor White
    Write-Host "   • Usar TensorFlow solo para validación comparativa" -ForegroundColor White
    Write-Host "   • Configurar PyTorch: Revisar requirements/desarrollo.txt" -ForegroundColor White
    
} else {
    Write-Host "   🔧 SITUACIÓN: Configuración requerida" -ForegroundColor Blue
    Write-Host ""
    Write-Host "   1. 🎯 CONFIGURACIÓN PRINCIPAL (Recomendada):" -ForegroundColor White
    Write-Host "      • Instalar PyTorch: pip install -r requirements/desarrollo.txt" -ForegroundColor Gray
    Write-Host ""
    Write-Host "   2. 🔄 CONFIGURACIÓN COMPARATIVA (Opcional):" -ForegroundColor White
    Write-Host "      • Instalar TensorFlow: pip install tensorflow" -ForegroundColor Gray
    Write-Host "      • Solo para experimentos de comparación" -ForegroundColor Gray
}

# -----------------------------------------------------------------------------
# FASE 6: INFORMACIÓN ADICIONAL Y JUSTIFICACIÓN
# Estrategia: Educar al usuario sobre las decisiones de diseño
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "🎓 JUSTIFICACIÓN TÉCNICA:" -ForegroundColor Cyan
Write-Host "   • PyTorch: Framework principal para investigación en Edge AI" -ForegroundColor White
Write-Host "   • TensorFlow: Solo para validación comparativa de resultados" -ForegroundColor White
Write-Host "   • Separación: Evita conflictos de dependencias y memoria GPU" -ForegroundColor White
Write-Host "   • Contenedores: Usar Docker para experimentos aislados" -ForegroundColor White

Write-Host ""
Write-Host "📚 FLUJOS DE TRABAJO SEGUROS:" -ForegroundColor Cyan
Write-Host "   • Desarrollo principal: Ambiente PyTorch" -ForegroundColor White
Write-Host "   • Comparativas: Contenedores Docker aislados" -ForegroundColor White
Write-Host "   • Experimentos: Scripts especializados por framework" -ForegroundColor White

Write-Host ""
Write-Host "=" * 70 -ForegroundColor Cyan
if ($conflictoDetectado) {
    Write-Host "⚠️  VERIFICACIÓN COMPLETADA - SE REQUIERE ACCIÓN" -ForegroundColor Red
} else {
    Write-Host "✅ VERIFICACIÓN COMPLETADA - SISTEMA COMPATIBLE" -ForegroundColor Green
}
Write-Host "=" * 70 -ForegroundColor Cyan
