# =============================================================================
# ESTRATEGIA: Script de Inicio de Entorno Edge Optimizado - Tesis Edge AI
# PROPÓSITO: Iniciar contenedor especializado para pruebas de inferencia en 
#            dispositivos edge con optimizaciones específicas
# COHERENCIA: Verificación → Inicialización → Guías Especializadas → Validación
# ENFOQUE: Optimización para hardware limitado (Raspberry Pi, Jetson, etc.)
# =============================================================================

# -----------------------------------------------------------------------------
# FASE 1: CONTEXTO Y PROPÓSITO ESPECIALIZADO
# Estrategia: Comunicar claramente el enfoque específico para Edge Computing
# -----------------------------------------------------------------------------
Write-Host "📱 INICIANDO ENTORNO EDGE AI OPTIMIZADO" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host ""

Write-Host "🎯 PROPÓSITO ESPECIALIZADO:" -ForegroundColor Yellow
Write-Host "   • Pruebas de inferencia en hardware limitado" -ForegroundColor White
Write-Host "   • Optimización de modelos para edge devices" -ForegroundColor White
Write-Host "   • Validación de performance en recursos restringidos" -ForegroundColor White
Write-Host "   • Preparación para deployment en dispositivos IoT" -ForegroundColor White
Write-Host ""

# -----------------------------------------------------------------------------
# FASE 2: VERIFICACIÓN DE PRE-CONDICIONES ESPECÍFICAS
# Estrategia: Verificar requisitos específicos para entorno Edge
# -----------------------------------------------------------------------------
Write-Host "[1/5] 🔍 VERIFICANDO PRE-CONDICIONES EDGE..." -ForegroundColor Gray

# Verificación 1: Archivo de composición
if (-not (Test-Path "docker-compose.yml")) {
    Write-Host "   ❌ No se encuentra docker-compose.yml" -ForegroundColor Red
    Write-Host "   💡 Ejecuta desde la raíz del proyecto tesis_edge_ai" -ForegroundColor Yellow
    Write-Host "   📍 Directorio actual: $(Get-Location)" -ForegroundColor Gray
    $null = Read-Host "Presiona Enter para salir"
    exit 1
}
Write-Host "   ✅ docker-compose.yml encontrado" -ForegroundColor Green

# Verificación 2: Docker disponible
try {
    $dockerInfo = docker info 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Docker no disponible"
    }
    Write-Host "   ✅ Docker funcionando" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Docker no está ejecutándose" -ForegroundColor Red
    Write-Host "   💡 Inicia Docker Desktop antes de continuar" -ForegroundColor Yellow
    $null = Read-Host "Presiona Enter para salir"
    exit 1
}

# Verificación 3: Imagen Edge disponible
$imagenEdge = docker images --filter "reference=tesis-edge*" --format "{{.Repository}}:{{.Tag}}"
if (-not $imagenEdge) {
    Write-Host "   ⚠️  Imagen edge no encontrada" -ForegroundColor Yellow
    Write-Host "   💡 Ejecuta primero: .\construir_contenedores.ps1" -ForegroundColor White
    Write-Host "   📦 Esto construirá todas las imágenes incluyendo la de edge" -ForegroundColor Gray
}

# -----------------------------------------------------------------------------
# FASE 3: DETECCIÓN DE HARDWARE Y CAPACIDADES
# Estrategia: Identificar capacidades específicas para optimización Edge
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[2/5] 🔧 DETECTANDO CAPACIDADES DE HARDWARE..." -ForegroundColor Gray

# Detectar GPU NVIDIA (para TensorRT)
$nvidiaGpu = nvidia-smi --query-gpu=name --format=csv,noheader 2>$null
if ($nvidiaGpu) {
    Write-Host "   ✅ GPU NVIDIA detectada: $($nvidiaGpu[0])" -ForegroundColor Green
    Write-Host "   🚀 TensorRT disponible para aceleración" -ForegroundColor Cyan
} else {
    Write-Host "   ℹ️  GPU NVIDIA no detectada" -ForegroundColor Gray
}

# Detectar Intel CPU (para OpenVINO)
$intelCpu = (Get-WmiObject -Class Win32_Processor).Name -match "Intel"
if ($intelCpu) {
    Write-Host "   ✅ CPU Intel detectada" -ForegroundColor Green
    Write-Host "   ⚡ OpenVINO disponible para optimización" -ForegroundColor Cyan
} else {
    Write-Host "   ℹ️  CPU Intel no detectada (OpenVINO limitado)" -ForegroundColor Gray
}

# Verificar RAM disponible
$memoryInfo = Get-WmiObject -Class Win32_ComputerSystem
$totalRAM = [math]::Round($memoryInfo.TotalPhysicalMemory / 1GB, 2)
Write-Host "   💾 RAM total: $totalRAM GB" -ForegroundColor $(if ($totalRAM -lt 8) { "Yellow" } else { "Green" })

# -----------------------------------------------------------------------------
# FASE 4: INICIALIZACIÓN DEL CONTENEDOR EDGE
# Estrategia: Iniciar contenedor con verificación de estado
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[3/5] 🐳 INICIANDO CONTENEDOR EDGE OPTIMIZADO..." -ForegroundColor Gray

# Verificar si el contenedor ya está ejecutándose
$contenedorEdgeActivo = docker-compose ps edge --services --filter "status=running" 2>$null

if ($contenedorEdgeActivo -contains "edge") {
    Write-Host "   ℹ️  Contenedor edge ya está ejecutándose" -ForegroundColor Yellow
} else {
    Write-Host "   Iniciando contenedor edge..." -ForegroundColor White
    docker-compose up -d edge
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   ❌ Error al iniciar contenedor edge" -ForegroundColor Red
        Write-Host ""
        Write-Host "   🔧 SOLUCIONES POSIBLES:" -ForegroundColor Cyan
        Write-Host "   1. Construir imágenes: .\construir_contenedores.ps1" -ForegroundColor White
        Write-Host "   2. Verificar puertos: docker-compose logs edge" -ForegroundColor White
        Write-Host "   3. Reiniciar Docker: Cerrar y abrir Docker Desktop" -ForegroundColor White
        Write-Host ""
        $null = Read-Host "Presiona Enter para continuar"
        exit 1
    }
    
    Write-Host "   ✅ Contenedor edge iniciado correctamente" -ForegroundColor Green
}

# -----------------------------------------------------------------------------
# FASE 5: VALIDACIÓN DE HERRAMIENTAS EDGE ESPECÍFICAS
# Estrategia: Verificar que las herramientas de optimización Edge estén disponibles
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[4/5] ✅ VALIDANDO HERRAMIENTAS EDGE..." -ForegroundColor Gray

Write-Host "   Verificando herramientas de optimización..." -ForegroundColor White

$herramientasEdge = @(
    @{Nombre = "ONNX Runtime"; Comando = "python -c \"import onnxruntime as ort; print(f'ONNX Runtime: {ort.__version__}')\""},
    @{Nombre = "OpenVINO"; Comando = "python -c \"try: import openvino as ov; print('OpenVINO: Disponible'); except: print('OpenVINO: No disponible')\""},
    @{Nombre = "TensorRT"; Comando = "python -c \"try: import tensorrt as trt; print('TensorRT: Disponible'); except: print('TensorRT: No disponible')\""},
    @{Nombre = "OpenCV"; Comando = "python -c \"import cv2; print(f'OpenCV: {cv2.__version__}')\""},
    @{Nombre = "NumPy"; Comando = "python -c \"import numpy as np; print(f'NumPy: {np.__version__}')\""}
)

$herramientasDisponibles = 0
foreach ($herramienta in $herramientasEdge) {
    try {
        $resultado = docker exec tesis-edge $herramienta.Comando 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ $($herramienta.Nombre): $resultado" -ForegroundColor Green
            $herramientasDisponibles++
        } else {
            Write-Host "   ❌ $($herramienta.Nombre): No disponible" -ForegroundColor Red
        }
    } catch {
        Write-Host "   ❌ $($herramienta.Nombre): Error de verificación" -ForegroundColor Red
    }
}

# -----------------------------------------------------------------------------
# FASE 6: GUÍAS ESPECIALIZADAS PARA EDGE COMPUTING
# Estrategia: Proporcionar comandos y flujos específicos para desarrollo Edge
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[5/5] 📚 PREPARANDO GUÍAS DE USO EDGE..." -ForegroundColor Gray

Write-Host ""
Write-Host "🎉 ENTORNO EDGE INICIADO CORRECTAMENTE" -ForegroundColor Green
Write-Host "────────────────────────────────────────────────────────────" -ForegroundColor Cyan

Write-Host ""
Write-Host "🚀 FLUJOS DE TRABAJO RECOMENDADOS:" -ForegroundColor Cyan

Write-Host ""
Write-Host "🔧 1. OPTIMIZACIÓN DE MODELOS:" -ForegroundColor Yellow
Write-Host "   • Convertir a ONNX: docker exec -it tesis-edge python scripts/convert_to_onnx.py" -ForegroundColor White
Write-Host "   • Cuantización: docker exec -it tesis-edge python scripts/quantize_model.py" -ForegroundColor White
Write-Host "   • Pruebas de performance: docker exec -it tesis-edge python scripts/benchmark_edge.py" -ForegroundColor White

Write-Host ""
Write-Host "📊 2. PRUEBAS DE INFERENCIA:" -ForegroundColor Yellow
Write-Host "   • Probar modelo ONNX: docker exec -it tesis-edge python -c \"" -ForegroundColor White
Write-Host "     import onnxruntime as ort; sess = ort.InferenceSession('model.onnx')" -ForegroundColor White
Write-Host "     print('ONNX Runtime funcionando')\"" -ForegroundColor White
Write-Host "   • Benchmark: docker exec -it tesis-edge python scripts/test_performance.py" -ForegroundColor White

Write-Host ""
Write_Host "🎯 3. HERRAMIENTAS ESPECÍFICAS:" -ForegroundColor Yellow
Write-Host "   • OpenVINO Toolkit: Optimización para CPU Intel" -ForegroundColor White
Write-Host "   • TensorRT: Aceleración para GPU NVIDIA" -ForegroundColor White
Write-Host "   • ONNX Runtime: Ejecución cross-platform" -ForegroundColor White

Write-Host ""
Write-Host "🔍 COMANDOS DE DIAGNÓSTICO:" -ForegroundColor Cyan
Write-Host "   📊 Estado del sistema: docker exec -it tesis-edge python -c \"" -ForegroundColor White
Write-Host "     import psutil; print(f'RAM: {psutil.virtual_memory().percent}%')\"" -ForegroundColor White
Write-Host "   ⚡ Performance: docker exec -it tesis-edge python scripts/check_performance.py" -ForegroundColor White
Write-Host "   🔍 Ver logs: docker-compose logs edge --tail=20" -ForegroundColor White

Write-Host ""
Write-Host "🛠️  OPERACIONES COMUNES:" -ForegroundColor Cyan
Write-Host "   🖥️  Entrar al contenedor: docker exec -it tesis-edge bash" -ForegroundColor White
Write-Host "   📁 Explorar archivos: docker exec -it tesis-edge ls -la /app/" -ForegroundColor White
Write-Host "   ⏹️  Detener contenedor: docker-compose stop edge" -ForegroundColor White
Write-Host "   🔄 Reiniciar: docker-compose restart edge" -ForegroundColor White

Write-Host ""
Write-Host "💡 MEJORES PRÁCTICAS PARA EDGE:" -ForegroundColor Cyan
Write-Host "   • Usa modelos cuantizados para menor uso de memoria" -ForegroundColor White
Write-Host "   • Prueba con diferentes batch sizes para optimizar throughput" -ForegroundColor White
Write-Host "   • Monitorea uso de RAM y CPU durante inferencia" -ForegroundColor White
Write-Host "   • Considera trade-offs entre precisión y velocidad" -ForegroundColor White

Write-Host ""
Write-Host "📋 EJEMPLOS DE USO AVANZADO:" -ForegroundColor Cyan
Write-Host "   # Probar modelo con diferentes proveedores de ejecución" -ForegroundColor DarkGray
Write-Host "   docker exec -it tesis-edge python -c \"" -ForegroundColor DarkGray
Write-Host "   import onnxruntime as ort" -ForegroundColor DarkGray
Write-Host "   providers = ort.get_available_providers()" -ForegroundColor DarkGray
Write-Host "   print('Proveedores disponibles:', providers)\"" -ForegroundColor DarkGray

Write-Host ""
Write-Host "🎯 DISPOSITIVOS COMPATIBLES:" -ForegroundColor Cyan
Write-Host "   • Raspberry Pi (con OpenVINO o ONNX Runtime)" -ForegroundColor White
Write-Host "   • NVIDIA Jetson (con TensorRT)" -ForegroundColor White
Write-Host "   • Intel NUC (con OpenVINO)" -ForegroundColor White
Write-Host "   • Dispositivos ARM con Linux" -ForegroundColor White

Write-Host ""
Write-Host "────────────────────────────────────────────────────────────" -ForegroundColor Cyan
Write-Host "✅ ENTORNO EDGE LISTO - $herramientasDisponibles/$($herramientasEdge.Count) herramientas disponibles" -ForegroundColor Green
Write-Host "💻 Optimizado para deployment en dispositivos con recursos limitados" -ForegroundColor Yellow
Write-Host "────────────────────────────────────────────────────────────" -ForegroundColor Cyan

# -----------------------------------------------------------------------------
# ESTRATEGIA MEJORADA: Ofrecer opciones específicas basadas en hardware detectado
# -----------------------------------------------------------------------------
if ($nvidiaGpu) {
    Write-Host ""
    Write-Host "🚀 RECOMENDACIÓN: Usa TensorRT para máxima aceleración en tu GPU NVIDIA" -ForegroundColor Green
}

if ($intelCpu) {
    Write-Host ""
    Write-Host "⚡ RECOMENDACIÓN: Optimiza con OpenVINO para tu CPU Intel" -ForegroundColor Green
}

if (-not $nvidiaGpu -and -not $intelCpu) {
    Write-Host ""
    Write-Host "ℹ️  RECOMENDACIÓN: Usa ONNX Runtime para compatibilidad máxima" -ForegroundColor Yellow
}

Write-Host ""
$null = Read-Host "Presiona Enter para cerrar esta ventana (contenedor edge seguirá ejecutándose)"
