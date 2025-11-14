# =============================================
# CREAR DEPENDENCIAS JERÁRQUICAS - TESIS EDGE AI
# =============================================
# 🎯 OBJETIVO: Generar archivos de requerimientos con estructura jerárquica
# 📁 ESTRUCTURA: Base → Desarrollo → Experimentos → Edge
# 🔄 HERENCIA: Cada nivel hereda y extiende del anterior
# 💡 USO: Ejecutar después de crear estructura, antes de configurar entornos
# 🚫 ADVERTENCIA: No modificar manualmente - regenerar con este script

# 🎨 CONFIGURACIÓN DE COLORES
$ColorTitulo = "Cyan"
$ColorExito = "Green"
$ColorAdvertencia = "Yellow"
$ColorError = "Red"
$ColorInfo = "Gray"
$ColorDestacado = "Magenta"

function Test-EstructuraRequerimientos {
    <#
    .DESCRIPTION
    Verifica que exista la estructura de carpetas para requerimientos
    #>
    Write-Host "🔍 Verificando estructura de requerimientos..." -ForegroundColor $ColorAdvertencia
    
    $carpetasRequeridas = @(
        "requerimientos",
        "requerimientos/base",
        "requerimientos/desarrollo", 
        "requerimientos/experimentos",
        "requerimientos/edge"
    )
    
    foreach ($carpeta in $carpetasRequeridas) {
        if (-not (Test-Path $carpeta)) {
            Write-Host "   ❌ Carpeta faltante: $carpeta" -ForegroundColor $ColorError
            Write-Host "   💡 Ejecuta primero: .\scripts\01_crear_estructura.ps1" -ForegroundColor White
            return $false
        }
    }
    Write-Host "   ✅ Estructura de requerimientos verificada" -ForegroundColor $ColorExito
    return $true
}

function New-ArchivoRequerimientos {
    <#
    .DESCRIPTION
    Crea un archivo de requerimientos con encoding UTF8 y verifica escritura
    #>
    param(
        [string]$FilePath,
        [string]$Content,
        [string]$Description
    )
    
    try {
        # Verificar que el directorio padre existe
        $parentDir = Split-Path $FilePath -Parent
        if (-not (Test-Path $parentDir)) {
            New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
        }
        
        $Content | Out-File -FilePath $FilePath -Encoding UTF8
        Write-Host "   ✅ $Description" -ForegroundColor $ColorExito
        return $true
    }
    catch {
        Write-Host "   ❌ Error creando: $FilePath - $_" -ForegroundColor $ColorError
        return $false
    }
}

# 🚀 INICIO DEL SCRIPT
Write-Host "`n🔧 CREANDO ESTRUCTURA JERÁRQUICA DE DEPENDENCIAS" -ForegroundColor $ColorTitulo
Write-Host "==================================================" -ForegroundColor $ColorTitulo

# 🔍 VERIFICACIÓN INICIAL
if (-not (Test-EstructuraRequerimientos)) {
    exit 1
}

Write-Host "`n📋 Generando archivos de requerimientos..." -ForegroundColor $ColorInfo

# 📊 CONTADORES PARA REPORTE
$archivosCreados = 0
$archivosConError = 0

# 1. ARCHIVO BASE COMÚN - DEPENDENCIAS COMPARTIDAS
Write-Host "`n🏗️  Creando BASE COMÚN (dependencias compartidas)..." -ForegroundColor $ColorDestacado

$baseComun = @"
# =============================================
# DEPENDENCIAS BASE COMUNES - TESIS EDGE AI
# =============================================
# ✅ Dependencias compartidas por TODOS los entornos
# 🎯 Versiones compatibles con PyTorch 1.12.1 y TensorFlow 2.10.0
# 💡 NO modificar manualmente - regenerar con script

# 👁️ PROCESAMIENTO VISUAL (compatible con ambos frameworks)
opencv-python==4.6.0.66
Pillow==9.3.0

# 📊 ANÁLISIS DE DATOS (versiones compatibles)
numpy==1.21.6                    # ✅ Compatible con PyTorch 1.12.1
pandas==1.5.3

# 🧮 MATEMÁTICAS Y CIENTÍFICAS
scipy==1.10.1

# 🎯 MACHINE LEARNING TRADICIONAL
scikit-learn==1.2.0

# 📈 VISUALIZACIÓN Y GRÁFICOS
matplotlib==3.6.3
seaborn==0.12.2

# 📝 UTILIDADES GENERALES
tqdm==4.64.1
requests==2.28.2
psutil==5.9.4
"@

if (New-ArchivoRequerimientos -FilePath "requerimientos/base/requerimientos_base_comun.txt" -Content $baseComun -Description "Base común creada") {
    $archivosCreados++
} else { $archivosConError++ }

# 2. ARCHIVO BASE PYTORCH - STACK PRINCIPAL
Write-Host "`n🧠 Creando BASE PYTORCH (stack principal)..." -ForegroundColor $ColorDestacado

$basePyTorch = @"
# =============================================
# BASE PYTORCH - CEREBRO PRINCIPAL TESIS
# =============================================
# ✅ Stack principal recomendado para la tesis
# 🎯 PyTorch + herramientas de visión + optimización edge
# 💡 USO: Para desarrollo principal y experimentos

# 🔗 INCLUIR DEPENDENCIAS COMUNES (compatibles)
-r requerimientos_base_comun.txt

# 🧠 CORE - PYTORCH (Framework principal)
torch==1.12.1
torchvision==0.13.1
torchaudio==0.12.1

# ⚡ PYTORCH LIGHTNING (Entrenamiento simplificado)
pytorch-lightning==1.9.4

# 🎯 OPTIMIZACIÓN PARA EDGE
onnx==1.14.1
onnxruntime==1.16.1

# 📊 MÉTRICAS Y EVALUACIÓN
torchmetrics==0.11.4

# 🔧 UTILIDADES PYTORCH
torchinfo==1.7.2

# 🚀 ACELERACIÓN (opcional para GPU)
# nvidia-ml-py==12.535.108  # ← OPCIONAL: Solo si hay GPU NVIDIA
"@

if (New-ArchivoRequerimientos -FilePath "requerimientos/base/requerimientos_base_pytorch.txt" -Content $basePyTorch -Description "Base PyTorch creada") {
    $archivosCreados++
} else { $archivosConError++ }

# 3. ARCHIVO BASE TENSORFLOW - COMPARATIVO
Write-Host "`n🤖 Creando BASE TENSORFLOW (comparativo)..." -ForegroundColor $ColorDestacado

$baseTensorFlow = @"
# =============================================
# BASE TENSORFLOW - ALTERNATIVA COMPARATIVA
# =============================================
# ⚠️  ALTERNATIVA: Para experimentos comparativos únicamente
# 🎯 Stack TensorFlow completo para validación cruzada
# ❌ ADVERTENCIA: No instalar junto con PyTorch simultáneamente

# 🔗 INCLUIR DEPENDENCIAS COMUNES
-r requerimientos_base_comun.txt

# 🤖 CORE - TENSORFLOW (equivalente a PyTorch)
tensorflow==2.10.0

# 📊 HERRAMIENTAS TENSORFLOW (equivalente a torchmetrics)
tensorboard==2.10.0

# 👁️ VISIÓN COMPATIBLE TF (equivalente a torchvision)
tf-explain==0.3.1

# 🎯 OPTIMIZACIÓN TF (equivalente a ONNX para PyTorch)
tensorflow-model-optimization==0.7.5

# 🚀 OPTIMIZACIÓN EDGE (equivalente a ONNX Runtime)
tensorflow-lite==2.10.0        # ← NUEVO: Para comparativas edge justas

# 🔧 COMPATIBILIDAD
protobuf==3.20.3
"@

if (New-ArchivoRequerimientos -FilePath "requerimientos/base/requerimientos_base_tensorflow.txt" -Content $baseTensorFlow -Description "Base TensorFlow creada") {
    $archivosCreados++
} else { $archivosConError++ }

# 4. ARCHIVO DESARROLLO COMÚN - HERRAMIENTAS COMPARTIDAS
Write-Host "`n💻 Creando DESARROLLO COMÚN (herramientas compartidas)..." -ForegroundColor $ColorDestacado

$desarrolloComun = @"
# =============================================
# HERRAMIENTAS DESARROLLO COMUNES
# =============================================
# ✅ Herramientas compartidas por AMBOS entornos de desarrollo
# 🎯 No dependen del framework específico

# 🖥️ ENTORNO INTERACTIVO (Jupyter)
jupyter==1.0.0
jupyterlab==4.0.0
ipython==8.12.0
ipywidgets==8.0.6

# 🔧 PROFILING, DEBUGGING Y DIAGNÓSTICO
debugpy==1.6.7
pdbpp==0.10.3
py-spy==0.3.14
psutil==5.9.4                    # ← MANTENER: Funciona sin GPU

# ✨ INTERFAZ MEJORADA
rich==13.6.0

# 📓 EXPERIMENTACIÓN Y TRACKING
wandb==0.15.12
mlflow==2.10.1

# 📁 CONTROL DE VERSIONES DE DATOS
dvc==2.38.0
dvc[gdrive]==2.38.0

# 🎯 CALIDAD DE CÓDIGO
black==23.3.0
flake8==6.0.0
pylint==2.17.4
"@

if (New-ArchivoRequerimientos -FilePath "requerimientos/desarrollo/requerimientos_desarrollo_comun.txt" -Content $desarrolloComun -Description "Desarrollo común creado") {
    $archivosCreados++
} else { $archivosConError++ }

# 5. ARCHIVO DESARROLLO PYTORCH - HERRAMIENTAS ESPECÍFICAS
Write-Host "`n🔧 Creando DESARROLLO PYTORCH (herramientas específicas)..." -ForegroundColor $ColorDestacado

$desarrolloPyTorch = @"
# =============================================
# DESARROLLO PYTORCH - HERRAMIENTAS ESPECÍFICAS
# =============================================
# ✅ Stack completo desarrollo PyTorch
# 🎯 Incluye herramientas específicas para debugging y profiling

# 🔗 BASE PYTORCH + HERRAMIENTAS DESARROLLO COMUNES
-r ../base/requerimientos_base_pytorch.txt
-r requerimientos_desarrollo_comun.txt

# 🔧 HERRAMIENTAS ESPECÍFICAS PYTORCH
torchviz==0.0.2
torch-tb-profiler==0.4.1
torchsummary==1.5.1

# 🎯 NOTEBOOKS PYTORCH
torch-tb-profiler[notebook]==0.4.1

# 🚀 OPTIMIZACIÓN DESARROLLO (opcional)
# cuda-python==11.8.1  # ← Solo si hay GPU NVIDIA
"@

if (New-ArchivoRequerimientos -FilePath "requerimientos/desarrollo/requerimientos_desarrollo_pytorch.txt" -Content $desarrolloPyTorch -Description "Desarrollo PyTorch creado") {
    $archivosCreados++
} else { $archivosConError++ }

# 6. ARCHIVO DESARROLLO TENSORFLOW - HERRAMIENTAS ESPECÍFICAS
Write-Host "`n🔧 Creando DESARROLLO TENSORFLOW (herramientas específicas)..." -ForegroundColor $ColorDestacado

$desarrolloTensorFlow = @"
# =============================================
# DESARROLLO TENSORFLOW - HERRAMIENTAS ESPECÍFICAS
# =============================================
# ⚠️  Stack desarrollo TensorFlow para comparativas
# 🎯 Herramientas específicas debugging y profiling TensorFlow

# 🔗 BASE TENSORFLOW + HERRAMIENTAS DESARROLLO COMUNES
-r ../base/requerimientos_base_tensorflow.txt
-r requerimientos_desarrollo_comun.txt

# 🔧 HERRAMIENTAS ESPECÍFICAS TENSORFLOW
tensorboard-plugin-profile==2.10.0
tf-explain==0.3.1

# 📊 VISUALIZACIÓN TF
tensorflow-datasets==4.9.2
"@

if (New-ArchivoRequerimientos -FilePath "requerimientos/desarrollo/requerimientos_desarrollo_tensorflow.txt" -Content $desarrolloTensorFlow -Description "Desarrollo TensorFlow creado") {
    $archivosCreados++
} else { $archivosConError++ }

# 7. ARCHIVO EXPERIMENTOS COMÚN - HERRAMIENTAS EXPERIMENTACIÓN
Write-Host "`n🔬 Creando EXPERIMENTOS COMÚN (herramientas experimentación)..." -ForegroundColor $ColorDestacado

$experimentosComun = @"
# =============================================
# HERRAMIENTAS EXPERIMENTACIÓN COMUNES
# =============================================
# ✅ Herramientas compartidas para experimentación profesional
# 🎯 No dependen del framework específico

# 📊 SEGUIMIENTO Y METADATOS
mlflow==2.10.1
wandb==0.15.12

# ⚡ OPTIMIZACIÓN DE HIPERPARÁMETROS
optuna==3.1.0
ray[tune]==2.4.0

# 🔬 PROFILING Y MONITOREO
# gpustat==1.0.0                    # ← MANTENER: Para experimentación con GPU
                                    # ⚠️  Solo para sistemas con GPU NVIDIA
                                    # 💡 En sistemas sin GPU, usar try/except al importar

# 📈 VISUALIZACIÓN AVANZADA
plotly==5.17.0
bokeh==3.3.0
plotly-express==0.4.1

# 🚀 ACELERACIÓN NUMÉRICA
numexpr==2.8.7
numba==0.57.1

# 📊 ANÁLISIS ESTADÍSTICO
scipy==1.10.1
statsmodels==0.13.5
scikit-posthocs==0.7.0

# 🎯 GESTIÓN DE CONFIGURACIONES (NUEVO - ALTA CONVENIENCIA)
hydra-core==1.3.2
omegaconf==2.3.0
"@

if (New-ArchivoRequerimientos -FilePath "requerimientos/experimentos/requerimientos_experimentos_comun.txt" -Content $experimentosComun -Description "Experimentos común creado") {
    $archivosCreados++
} else { $archivosConError++ }

# 8. ARCHIVO EXPERIMENTOS PYTORCH - ENTRENAMIENTO PROFESIONAL
Write-Host "`n⚡ Creando EXPERIMENTOS PYTORCH (entrenamiento profesional)..." -ForegroundColor $ColorDestacado

$experimentosPyTorch = @"
# =============================================
# EXPERIMENTOS PYTORCH - ENTRENAMIENTO PROFESIONAL
# =============================================
# ✅ Stack completo para experimentación PyTorch
# 🎯 Incluye herramientas específicas para entrenamiento distribuido y profiling

# 🔗 DESARROLLO PYTORCH + HERRAMIENTAS EXPERIMENTACIÓN COMUNES
-r ../desarrollo/requerimientos_desarrollo_pytorch.txt
-r requerimientos_experimentos_comun.txt

# 🚀 ENTRENAMIENTO DISTRIBUIDO PYTORCH
pytorch-lightning==1.9.4
torchmetrics==0.11.4

# 🔧 PROFILING ESPECÍFICO PYTORCH
torch-tb-profiler==0.4.1
torch-profiler==0.1.0

# 📊 VISUALIZACIÓN TENSORBOARD (NUEVO - ALTA CONVENIENCIA)
tensorboardX==2.6          # ← Esencial para PyTorch + TensorBoard

# ⚡ OPTIMIZACIÓN MEMORIA
fvcore==0.1.5.post20220512

# 📊 VISUALIZACIÓN MODELOS PYTORCH
torchviz==0.0.2
"@

if (New-ArchivoRequerimientos -FilePath "requerimientos/experimentos/requerimientos_experimentos_pytorch.txt" -Content $experimentosPyTorch -Description "Experimentos PyTorch creados") {
    $archivosCreados++
} else { $archivosConError++ }

# 9. ARCHIVO EXPERIMENTOS TENSORFLOW - COMPARATIVAS PROFESIONALES
Write-Host "`n⚡ Creando EXPERIMENTOS TENSORFLOW (comparativas profesionales)..." -ForegroundColor $ColorDestacado

$experimentosTensorFlow = @"
# =============================================
# EXPERIMENTOS TENSORFLOW - COMPARATIVAS PROFESIONALES
# =============================================
# ⚠️  Stack experimentación TensorFlow para comparativas justas
# 🎯 Equivalencias funcionales con herramientas PyTorch

# 🔗 DESARROLLO TENSORFLOW + HERRAMIENTAS EXPERIMENTACIÓN COMUNES
-r ../desarrollo/requerimientos_desarrollo_tensorflow.txt
-r requerimientos_experimentos_comun.txt

# 🚀 ENTRENAMIENTO DISTRIBUIDO TENSORFLOW
tensorflow-datasets==4.9.2

# 🔧 PROFILING ESPECÍFICO TENSORFLOW
tensorboard-plugin-profile==2.10.0

# ⚡ ESTRATEGIAS DISTRIBUIDAS
tensorflow-io==0.31.0

# 📊 OPTIMIZACIÓN MODELOS TF
tensorflow-model-optimization==0.7.5
"@

if (New-ArchivoRequerimientos -FilePath "requerimientos/experimentos/requerimientos_experimentos_tensorflow.txt" -Content $experimentosTensorFlow -Description "Experimentos TensorFlow creados") {
    $archivosCreados++
} else { $archivosConError++ }

# 10. ARCHIVO EDGE COMÚN - DEPENDENCIAS RASPBERRY PI
Write-Host "`n📱 Creando EDGE COMÚN (dependencias Raspberry Pi)..." -ForegroundColor $ColorDestacado

$edgeComun = @"
# =============================================
# DEPENDENCIAS EDGE COMUNES - RASPBERRY PI OPTIMIZADO
# =============================================
# ✅ Dependencias específicas para ARM/Raspberry Pi
# 🎯 Versiones compatibles y optimizadas para hardware limitado

# 👁️ VISIÓN COMPUTACIONAL OPTIMIZADA
opencv-python==4.5.3.56          # ✅ Versión estable ARM
Pillow==9.0.0                    # ✅ Compatible con ARM

# 📊 ANÁLISIS BÁSICO (versiones ARM compatibles)
numpy==1.21.6                    # ✅ Compatible con PyTorch ARM
scikit-learn==1.0.2              # ✅ Versión ligera ARM

# 🔧 MONITOREO RECURSOS (esencial para edge)
psutil==5.8.0                    # ✅ Estable en ARM
gpiozero==1.6.2                  # ✅ Control GPIO Raspberry Pi
RPi.GPIO==0.7.0                  # ✅ Acceso hardware

# 📷 CÁMARA RASPBERRY PI
picamera2==0.3.7

# 🚀 UTILIDADES EDGE
pyserial==3.5                    # ✅ Comunicación serial
adafruit-blinka==6.19.0          # ✅ Soporte hardware Adafruit
"@

if (New-ArchivoRequerimientos -FilePath "requerimientos/edge/requerimientos_edge_comun.txt" -Content $edgeComun -Description "Edge común creado") {
    $archivosCreados++
} else { $archivosConError++ }

# 11. ARCHIVO EDGE PYTORCH - RASPBERRY PI COMPATIBLE
Write-Host "`n🍓 Creando EDGE PYTORCH (Raspberry Pi compatible)..." -ForegroundColor $ColorDestacado

$edgePyTorch = @"
# =============================================
# EDGE PYTORCH - RASPBERRY PI COMPATIBLE
# =============================================
# ✅ PyTorch específico para ARM architecture
# 🎯 Versiones oficialmente soportadas en Raspberry Pi

# 🔗 BASE EDGE COMÚN (optimizado para ARM)
-r requerimientos_edge_comun.txt

# 🧠 PYTORCH PARA ARM (✅ versiones reales ARM)
torch==1.8.0                     # ✅ Última versión oficial ARM
torchvision==0.9.0               # ✅ Compatible con torch 1.8.0

# 🎯 INFERENCIA OPTIMIZADA
onnxruntime==1.16.1              # ✅ Soporta ARM
onnx==1.14.1                     # ✅ Para conversión de modelos

# ⚡ OPTIMIZACIONES ESPECÍFICAS
piheatsink==0.0.6                # ✅ Monitoreo temperatura
rpi-hardware-pwm==0.1.0          # ✅ Control PWM para ventiladores
"@

if (New-ArchivoRequerimientos -FilePath "requerimientos/edge/requerimientos_edge_pytorch.txt" -Content $edgePyTorch -Description "Edge PyTorch creado") {
    $archivosCreados++
} else { $archivosConError++ }

# 12. ARCHIVO EDGE TENSORFLOW - TENSORFLOW LITE
Write-Host "`n🍓 Creando EDGE TENSORFLOW (TensorFlow Lite)..." -ForegroundColor $ColorDestacado

$edgeTensorFlow = @"
# =============================================
# EDGE TENSORFLOW - TENSORFLOW LITE OPTIMIZADO
# =============================================
# ⚠️  Stack TensorFlow Lite para edge
# 🎯 Máxima optimización para recursos limitados

# 🔗 BASE EDGE COMÚN (optimizado para ARM)
-r requerimientos_edge_comun.txt

# 🤖 TENSORFLOW LITE (✅ versión específica ARM)
tflite-runtime==2.10.0           # ✅ Correcto para edge
tensorflow==2.10.0               # ✅ Para conversión de modelos

# 🎯 HERRAMIENTAS CONVERSIÓN
tf2onnx==1.13.0                  # ✅ Conversión TF → ONNX

# ⚡ OPTIMIZACIÓN MODELOS
tensorflow-model-optimization==0.7.5  # ✅ Cuantización modelos
"@

if (New-ArchivoRequerimientos -FilePath "requerimientos/edge/requerimientos_edge_tensorflow.txt" -Content $edgeTensorFlow -Description "Edge TensorFlow creado") {
    $archivosCreados++
} else { $archivosConError++ }

# 🔄 SINCRONIZACIÓN AUTOMÁTICA
Write-Host "`n🔄 Ejecutando sincronización de estructura..." -ForegroundColor $ColorAdvertencia

if (Test-Path "scripts\05_sincronizar_requerimientos.ps1") {
    try {
        & "scripts\05_sincronizar_requerimientos.ps1"
        Write-Host "   ✅ Sincronización completada" -ForegroundColor $ColorExito
    }
    catch {
        Write-Host "   ⚠️  Sincronización con advertencias: $_" -ForegroundColor $ColorAdvertencia
    }
} else {
    Write-Host "   ⚠️  Script de sincronización no encontrado" -ForegroundColor $ColorAdvertencia
}

# 📊 REPORTE FINAL
Write-Host "`n" + "="*50 -ForegroundColor $ColorTitulo

if ($archivosConError -eq 0) {
    Write-Host "🎉 ESTRUCTURA DE DEPENDENCIAS CREADA EXITOSAMENTE!" -ForegroundColor White -BackgroundColor DarkGreen
} else {
    Write-Host "⚠️  ESTRUCTURA CREADA CON ALGUNOS ERRORES" -ForegroundColor $ColorAdvertencia -BackgroundColor DarkRed
}

Write-Host "📊 RESUMEN DE CREACIÓN:" -ForegroundColor $ColorDestacado
Write-Host "   • Archivos creados exitosamente: $archivosCreados" -ForegroundColor $ColorExito
Write-Host "   • Archivos con errores: $archivosConError" -ForegroundColor $(if ($archivosConError -gt 0) { $ColorError } else { $ColorExito })
Write-Host "   • Total de archivos generados: 12" -ForegroundColor White

Write-Host "🏗️  JERARQUÍA IMPLEMENTADA:" -ForegroundColor $ColorDestacado
Write-Host "   • 📦 BASE (3 archivos): Común + PyTorch + TensorFlow" -ForegroundColor White
Write-Host "   • 💻 DESARROLLO (3 archivos): Común + PyTorch + TensorFlow" -ForegroundColor White
Write-Host "   • 🔬 EXPERIMENTOS (3 archivos): Común + PyTorch + TensorFlow" -ForegroundColor White
Write-Host "   • 📱 EDGE (3 archivos): Común + PyTorch + TensorFlow" -ForegroundColor White

Write-Host "🎯 ESTRATEGIA DE INSTALACIÓN:" -ForegroundColor $ColorAdvertencia
Write-Host "   1. Desarrollo diario: requerimientos/desarrollo/requerimientos_desarrollo_pytorch.txt" -ForegroundColor White
Write-Host "   2. Experimentación: requerimientos/experimentos/requerimientos_experimentos_pytorch.txt" -ForegroundColor White
Write-Host "   3. Deployment edge: requerimientos/edge/requerimientos_edge_pytorch.txt" -ForegroundColor White
Write-Host "   4. Comparativas: Usar archivos TensorFlow equivalentes" -ForegroundColor White

Write-Host "🚀 PRÓXIMOS PASOS RECOMENDADOS:" -ForegroundColor $ColorAdvertencia
Write-Host "   1. Configurar PyTorch: .\scripts\03a_configurar_pytorch.ps1" -ForegroundColor White
Write-Host "   2. Verificar instalación: .\scripts\USO_SEMANAL\uso_verificar.ps1" -ForegroundColor White
Write-Host "   3. Comenzar desarrollo: .\scripts\USO_DIARIO\uso_activar.ps1" -ForegroundColor White

Write-Host "💡 INFORMACIÓN IMPORTANTE:" -ForegroundColor $ColorInfo
Write-Host "   • Versiones NumPy corregidas para compatibilidad PyTorch" -ForegroundColor White
Write-Host "   • PyTorch edge usa versiones REALES para ARM" -ForegroundColor White
Write-Host "   • Estructura evita duplicación con archivos comunes" -ForegroundColor White
Write-Host "   • Herramientas específicas por framework para mejor experiencia" -ForegroundColor White

exit $(if ($archivosConError -eq 0) { 0 } else { 1 })
