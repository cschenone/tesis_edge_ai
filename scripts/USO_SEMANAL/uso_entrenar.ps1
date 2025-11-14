# =============================================================================
# ESTRATEGIA: Script de Inicio de Entorno de Experimentos - Tesis Edge AI
# PROPÓSITO: Iniciar contenedor especializado para entrenamiento de modelos
#            y ejecución de experimentos largos con tracking completo
# COHERENCIA: Verificación → Inicialización → Validación → Guías Especializadas
# ENFOQUE: Optimizado para procesos de ML/DL de larga duración con monitoreo
# =============================================================================

# -----------------------------------------------------------------------------
# FASE 1: CONTEXTO Y PROPÓSITO DE EXPERIMENTACIÓN
# Estrategia: Comunicar claramente el enfoque científico y experimental
# -----------------------------------------------------------------------------
Write-Host "🔬 INICIANDO ENTORNO DE EXPERIMENTOS TESIS EDGE AI" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host ""

Write-Host "🎯 PROPÓSITO CIENTÍFICO:" -ForegroundColor Yellow
Write-Host "   • Validación de hipótesis HS1-HS5 de la tesis" -ForegroundColor White
Write-Host "   • Entrenamiento de modelos de Machine Learning" -ForegroundColor White
Write-Host "   • Experimentos de Deep Learning de larga duración" -ForegroundColor White
Write-Host "   • Tracking y reproducibilidad de resultados" -ForegroundColor White
Write-Host ""

# -----------------------------------------------------------------------------
# FASE 2: VERIFICACIÓN DE PRE-CONDICIONES PARA EXPERIMENTOS
# Estrategia: Verificar requisitos específicos para entrenamiento ML
# -----------------------------------------------------------------------------
Write-Host "[1/6] 🔍 VERIFICANDO PRE-CONDICIONES PARA EXPERIMENTOS..." -ForegroundColor Gray

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

# Verificación 3: Imagen de experimentos disponible
$imagenExperiments = docker images --filter "reference=tesis-experiments*" --format "{{.Repository}}:{{.Tag}}"
if (-not $imagenExperiments) {
    Write-Host "   ⚠️  Imagen experiments no encontrada" -ForegroundColor Yellow
    Write-Host "   💡 Ejecuta primero: .\construir_contenedores.ps1" -ForegroundColor White
}

# -----------------------------------------------------------------------------
# FASE 3: VERIFICACIÓN DE RECURSOS PARA ENTRENAMIENTO
# Estrategia: Evaluar recursos del sistema críticos para experimentos ML
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[2/6] 📊 ANALIZANDO RECURSOS DEL SISTEMA..." -ForegroundColor Gray

# Detectar GPU NVIDIA (crítico para entrenamiento DL)
$nvidiaGpu = nvidia-smi --query-gpu=name,memory.total --format=csv,noheader 2>$null
if ($nvidiaGpu) {
    $gpuInfo = $nvidiaGpu[0] -split ","
    Write-Host "   ✅ GPU NVIDIA: $($gpuInfo[0].Trim()) - $($gpuInfo[1].Trim())" -ForegroundColor Green
    Write-Host "   🚀 Aceleración CUDA disponible para entrenamiento" -ForegroundColor Cyan
} else {
    Write-Host "   ⚠️  GPU NVIDIA no detectada" -ForegroundColor Yellow
    Write-Host "   🐌 Los entrenamientos usarán CPU (pueden ser más lentos)" -ForegroundColor White
}

# Verificar RAM disponible (importante para datasets grandes)
$memoryInfo = Get-WmiObject -Class Win32_ComputerSystem
$totalRAM = [math]::Round($memoryInfo.TotalPhysicalMemory / 1GB, 2)
$ramStatus = if ($totalRAM -lt 16) { "Yellow" } elseif ($totalRAM -lt 32) { "Green" } else { "Cyan" }
Write-Host "   💾 RAM total: $totalRAM GB" -ForegroundColor $ramStatus

# Verificar espacio en disco (para modelos y logs)
$diskInfo = Get-PSDrive C | Select-Object Used, Free
$freeGB = [math]::Round($diskInfo.Free / 1GB, 2)
$diskStatus = if ($freeGB -lt 10) { "Red" } elseif ($freeGB -lt 20) { "Yellow" } else { "Green" }
Write-Host "   💽 Espacio libre: $freeGB GB" -ForegroundColor $diskStatus

if ($freeGB -lt 10) {
    Write-Host "   ⚠️  Espacio en disco bajo - los experimentos pueden fallar" -ForegroundColor Red
}

# -----------------------------------------------------------------------------
# FASE 4: INICIALIZACIÓN DEL CONTENEDOR DE EXPERIMENTOS
# Estrategia: Iniciar contenedor con verificación de estado y recursos
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[3/6] 🐳 INICIANDO CONTENEDOR DE EXPERIMENTOS..." -ForegroundColor Gray

# Verificar si el contenedor ya está ejecutándose
$contenedorExperimentsActivo = docker-compose ps experiments --services --filter "status=running" 2>$null

if ($contenedorExperimentsActivo -contains "experiments") {
    Write-Host "   ℹ️  Contenedor experiments ya está ejecutándose" -ForegroundColor Yellow
} else {
    Write-Host "   Iniciando contenedor experiments..." -ForegroundColor White
    
    # Iniciar con variables de entorno para optimización
    if ($nvidiaGpu) {
        Write-Host "   🚀 Configurando para GPU NVIDIA..." -ForegroundColor Cyan
    }
    
    docker-compose up -d experiments
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   ❌ Error al iniciar contenedor experiments" -ForegroundColor Red
        Write-Host ""
        Write-Host "   🔧 SOLUCIONES POSIBLES:" -ForegroundColor Cyan
        Write-Host "   1. Construir imágenes: .\construir_contenedores.ps1" -ForegroundColor White
        Write-Host "   2. Verificar recursos: docker system df" -ForegroundColor White
        Write-Host "   3. Liberar espacio: docker system prune" -ForegroundColor White
        Write-Host "   4. Verificar logs: docker-compose logs experiments" -ForegroundColor White
        Write-Host ""
        $null = Read-Host "Presiona Enter para continuar"
        exit 1
    }
    
    Write-Host "   ✅ Contenedor experiments iniciado correctamente" -ForegroundColor Green
}

# -----------------------------------------------------------------------------
# FASE 5: VALIDACIÓN DE HERRAMIENTAS DE EXPERIMENTACIÓN
# Estrategia: Verificar que las herramientas de ML y tracking estén disponibles
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[4/6] ✅ VALIDANDO HERRAMIENTAS DE EXPERIMENTACIÓN..." -ForegroundColor Gray

Write-Host "   Verificando frameworks de ML y tracking..." -ForegroundColor White

$herramientasML = @(
    @{Nombre = "PyTorch"; Comando = "python -c \"import torch; print(f'PyTorch {torch.__version__} - CUDA: {torch.cuda.is_available()}')\""},
    @{Nombre = "TensorFlow"; Comando = "python -c \"import tensorflow as tf; print(f'TensorFlow {tf.__version__}')\""},
    @{Nombre = "MLflow"; Comando = "python -c \"import mlflow; print(f'MLflow {mlflow.__version__}')\""},
    @{Nombre = "WandB"; Comando = "python -c \"try: import wandb; print('WandB: Disponible'); except: print('WandB: No configurado')\""},
    @{Nombre = "Scikit-learn"; Comando = "python -c \"import sklearn; print(f'scikit-learn: {sklearn.__version__}')\""},
    @{Nombre = "NumPy"; Comando = "python -c \"import numpy as np; print(f'NumPy: {np.__version__}')\""}
)

$herramientasDisponibles = 0
foreach ($herramienta in $herramientasML) {
    try {
        $resultado = docker exec tesis-experiments $herramienta.Comando 2>$null
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
# FASE 6: GUÍAS ESPECIALIZADAS PARA EXPERIMENTACIÓN CIENTÍFICA
# Estrategia: Proporcionar flujos de trabajo específicos para investigación
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[5/6] 📚 PREPARANDO GUÍAS DE EXPERIMENTACIÓN..." -ForegroundColor Gray

Write-Host ""
Write-Host "🎉 ENTORNO DE EXPERIMENTOS INICIADO CORRECTAMENTE" -ForegroundColor Green
Write-Host "────────────────────────────────────────────────────────────" -ForegroundColor Cyan

Write-Host ""
Write-Host "🔬 FLUJOS DE TRABAJO CIENTÍFICOS:" -ForegroundColor Cyan

Write-Host ""
Write-Host "📈 1. EJECUCIÓN DE HIPÓTESIS:" -ForegroundColor Yellow
Write-Host "   • HS1 - Arquitectura eficiente:" -ForegroundColor White
Write-Host "     docker exec -it tesis-experiments python codigo/experiments/hipotesis_HS1/main.py" -ForegroundColor Gray
Write-Host "   • HS2 - Optimización para edge:" -ForegroundColor White
Write-Host "     docker exec -it tesis-experiments python codigo/experiments/hipotesis_HS2/main.py" -ForegroundColor Gray
Write-Host "   • HS3 - Transfer learning:" -ForegroundColor White
Write-Host "     docker exec -it tesis-experiments python codigo/experiments/hipotesis_HS3/main.py" -ForegroundColor Gray
Write-Host "   • HS4 - Data augmentation:" -ForegroundColor White
Write-Host "     docker exec -it tesis-experiments python codigo/experiments/hipotesis_HS4/main.py" -ForegroundColor Gray
Write-Host "   • HS5 - Modelos híbridos:" -ForegroundColor White
Write-Host "     docker exec -it tesis-experiments python codigo/experiments/hipotesis_HS5/main.py" -ForegroundColor Gray

Write-Host ""
Write-Host "📊 2. TRACKING Y EXPERIMENTACIÓN:" -ForegroundColor Yellow
Write-Host "   • Iniciar MLflow local:" -ForegroundColor White
Write-Host "     docker exec -d tesis-experiments mlflow server --host 0.0.0.0 --port 5000" -ForegroundColor Gray
Write-Host "   • Ver UI MLflow: http://localhost:5000" -ForegroundColor White
Write-Host "   • Configurar WandB:" -ForegroundColor White
Write-Host "     docker exec -it tesis-experiments wandb login" -ForegroundColor Gray
Write-Host "   • Ejecutar con tracking:" -ForegroundColor White
Write-Host "     docker exec -it tesis-experiments python script.py --tracking mlflow" -ForegroundColor Gray

Write-Host ""
Write-Host "⚡ 3. ENTRENAMIENTO AVANZADO:" -ForegroundColor Yellow
Write-Host "   • Entrenamiento distribuido:" -ForegroundColor White
Write-Host "     docker exec -it tesis-experiments python -m torch.distributed.launch train.py" -ForegroundColor Gray
Write-Host "   • Fine-tuning modelos:" -ForegroundColor White
Write-Host "     docker exec -it tesis-experiments python scripts/fine_tune.py --model resnet50" -ForegroundColor Gray
Write-Host "   • Hyperparameter tuning:" -ForegroundColor White
Write-Host "     docker exec -it tesis-experiments python scripts/hyperparam_tuning.py" -ForegroundColor Gray

Write-Host ""
Write-Host "🔍 HERRAMIENTAS DE ANÁLISIS:" -ForegroundColor Cyan
Write-Host "   📈 Monitoreo GPU: docker exec -it tesis-experiments nvidia-smi" -ForegroundColor White
Write-Host "   📊 Uso de memoria: docker exec -it tesis-experiments python -c \"" -ForegroundColor White
Write-Host "     import psutil; print(f'RAM: {psutil.virtual_memory().percent}%')\"" -ForegroundColor Gray
Write-Host "   📝 Logs en tiempo real: docker-compose logs -f experiments" -ForegroundColor White
Write-Host "   🎯 Metricas live: docker exec -it tesis-experiments tail -f /app/logs/training.log" -ForegroundColor White

Write-Host ""
Write-Host "🛠️  OPERACIONES DE MANTENIMIENTO:" -ForegroundColor Cyan
Write-Host "   🖥️  Shell interactivo: docker exec -it tesis-experiments bash" -ForegroundColor White
Write-Host "   📁 Explorar resultados: docker exec -it tesis-experiments ls -la /app/experiments/" -ForegroundColor White
Write-Host "   💾 Backup modelos: docker exec -it tesis-experiments tar -czf models_backup.tar.gz /app/models/" -ForegroundColor White
Write-Host "   ⏹️  Detener entrenamiento: docker-compose stop experiments" -ForegroundColor White
Write-Host "   🔄 Reiniciar: docker-compose restart experiments" -ForegroundColor White

Write-Host ""
Write-Host "💡 MEJORES PRÁCTICAS PARA EXPERIMENTOS:" -ForegroundColor Cyan
Write-Host "   • Usa MLflow para tracking de todos los experimentos" -ForegroundColor White
Write-Host "   • Configura checkpointing para entrenamientos largos" -ForegroundColor White
Write-Host "   • Monitorea recursos durante entrenamiento" -ForegroundColor White
Write-Host "   • Documenta cada experimento en el README correspondiente" -ForegroundColor White
Write-Host "   • Versiona datasets y modelos con DVC o git-lfs" -ForegroundColor White

Write-Host ""
Write-Host "🚀 COMANDOS RÁPIDOS PARA INVESTIGACIÓN:" -ForegroundColor Cyan
Write-Host "   # Probar dataset y modelo básico" -ForegroundColor DarkGray
Write-Host "   docker exec -it tesis-experiments python -c \"" -ForegroundColor DarkGray
Write-Host "   from codigo.data.load_dataset import load_training_data" -ForegroundColor DarkGray
Write-Host "   data = load_training_data(); print(f'Dataset: {len(data)} muestras')\"" -ForegroundColor DarkGray

Write-Host ""
Write-Host "   # Verificar configuración de experimento" -ForegroundColor DarkGray
Write-Host "   docker exec -it tesis-experiments python scripts/validate_experiment.py --hypothesis HS1" -ForegroundColor DarkGray

Write-Host ""
Write-Host "🎯 RECOMENDACIONES PARA TESIS:" -ForegroundColor Cyan
Write-Host "   • Ejecuta cada hipótesis en contenedores separados para aislamiento" -ForegroundColor White
Write-Host "   • Guarda logs detallados para la sección de metodología" -ForegroundColor White
Write-Host "   • Exporta gráficas y métricas para resultados" -ForegroundColor White
Write-Host "   • Documenta hyperparámetros y configuraciones" -ForegroundColor White

Write-Host ""
Write-Host "────────────────────────────────────────────────────────────" -ForegroundColor Cyan
Write-Host "✅ ENTORNO DE EXPERIMENTOS LISTO - $herramientasDisponibles/$($herramientasML.Count) herramientas disponibles" -ForegroundColor Green
Write-Host "🔬 Optimizado para investigación científica y validación de hipótesis" -ForegroundColor Yellow
Write-Host "────────────────────────────────────────────────────────────" -ForegroundColor Cyan

# -----------------------------------------------------------------------------
# FASE 7: VERIFICACIÓN FINAL Y RECOMENDACIONES
# Estrategia: Proporcionar resumen y recomendaciones específicas
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[6/6] 📋 RESUMEN Y RECOMENDACIONES FINALES..." -ForegroundColor Gray

if ($nvidiaGpu) {
    Write-Host "   🚀 HARDWARE: GPU disponible - entrenamientos acelerados" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  HARDWARE: Solo CPU - considera tiempos más largos" -ForegroundColor Yellow
}

if ($herramientasDisponibles -eq $herramientasML.Count) {
    Write-Host "   📦 FRAMEWORKS: Todas las herramientas disponibles" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  FRAMEWORKS: Algunas herramientas no disponibles" -ForegroundColor Yellow
}

Write-Host "   💡 PRÓXIMOS PASOS: Ejecuta una hipótesis específica o configura tracking" -ForegroundColor Cyan

Write-Host ""
$null = Read-Host "Presiona Enter para cerrar esta ventana (contenedor experiments seguirá ejecutándose)"
