# =============================================
# CREAR ESTRUCTURA DE PROYECTO - TESIS EDGE AI
# =============================================
# 🎯 OBJETIVO: Crear estructura completa de carpetas M1-M9 para tesis doctoral
# 📁 ORGANIZACIÓN: Componentes modulares, experimentos, datos, modelos, resultados
# 💡 USO: Ejecutar una vez al inicio del proyecto o cuando se necesite regenerar
# 🔧 MANTENIMIENTO: Actualizar array $estructura si se agregan nuevas carpetas

# 🎨 CONFIGURACIÓN DE COLORES PARA MEJOR VISUALIZACIÓN
$ColorTitulo = "Cyan"
$ColorExito = "Green"
$ColorAdvertencia = "Yellow"
$ColorError = "Red"
$ColorInfo = "Gray"
$ColorDestacado = "Magenta"

function Test-PermisosEscritura {
    <#
    .DESCRIPTION
    Verifica que el script tenga permisos de escritura en el directorio actual
    #>
    Write-Host "🔐 Verificando permisos de escritura..." -ForegroundColor $ColorAdvertencia
    
    try {
        $testFile = "test_permisos_$([System.Guid]::NewGuid().ToString().Substring(0,8)).txt"
        "test" | Out-File -FilePath $testFile -ErrorAction Stop
        Remove-Item $testFile -ErrorAction Stop
        Write-Host "   ✅ Permisos de escritura verificados" -ForegroundColor $ColorExito
        return $true
    }
    catch {
        Write-Host "   ❌ Error: Sin permisos de escritura en este directorio" -ForegroundColor $ColorError
        Write-Host "   💡 Solución: Ejecuta PowerShell como administrador o cambia de carpeta" -ForegroundColor White
        return $false
    }
}

function Backup-EstructuraExistente {
    <#
    .DESCRIPTION
    Crea backup de estructura existente antes de regenerar
    #>
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupDir = "backups/estructura_$timestamp"
    
    Write-Host "📦 Creando backup en: $backupDir" -ForegroundColor $ColorAdvertencia
    
    try {
        New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        
        # Copiar solo carpetas críticas (excluir datos grandes)
        $carpetasBackup = @("codigo", "configs", "documentacion", "modelos", "scripts")
        foreach ($carpeta in $carpetasBackup) {
            if (Test-Path $carpeta) {
                Copy-Item -Path $carpeta -Destination "$backupDir/" -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host "   ✅ Backup: $carpeta" -ForegroundColor $ColorExito
            }
        }
        return $true
    }
    catch {
        Write-Host "   ⚠️  No se pudo crear backup completo: $_" -ForegroundColor $ColorAdvertencia
        return $false
    }
}

# 🚀 INICIO DEL SCRIPT
Write-Host "`n🏗️  CREANDO ESTRUCTURA DE CARPETAS - TESIS EDGE AI" -ForegroundColor $ColorTitulo
Write-Host "==================================================" -ForegroundColor $ColorTitulo

# 🔍 VERIFICACIÓN INICIAL
if (-not (Test-PermisosEscritura)) {
    exit 1
}

# 📋 DEFINICIÓN COMPLETA DE ESTRUCTURA - ACTUALIZADA CON ESTRUCTURA REAL
Write-Host "`n📋 Definición de estructura del proyecto..." -ForegroundColor $ColorInfo

$estructura = @(
    # 🧩 COMPONENTES DEL SISTEMA (M1-M9)
    "codigo/Componentes/M1_entrada",                    # Captura y preprocesamiento de datos
    "codigo/Componentes/M2_procesamiento_visual",       # Análisis de imágenes/video
    "codigo/Componentes/M3_temporal",                   # Procesamiento de secuencias temporales
    "codigo/Componentes/M4_fusion",                     # Fusión multimodal de características
    "codigo/Componentes/M5_clasificacion",              # Modelos de clasificación
    "codigo/Componentes/M6_almacenamiento",             # Gestión de datos y modelos
    "codigo/Componentes/M7_visualizacion",              # Visualización de resultados
    "codigo/Componentes/M8_control",                    # Orquestación del sistema
    "codigo/Componentes/M9_retroalimentacion",          # Aprendizaje continuo
    
    # 🔧 CÓDIGO DE ENTRENAMIENTO Y EVALUACIÓN
    "codigo/entrenamiento/configs",                     # Configuraciones de entrenamiento
    "codigo/entrenamiento/optimizacion",                # Optimización de hiperparámetros
    "codigo/entrenamiento/scripts",                     # Scripts de entrenamiento
    
    "codigo/evaluacion/metricas",                       # Cálculo de métricas de evaluación
    "codigo/evaluacion/pruebas",                        # Pruebas unitarias y de integración
    "codigo/evaluacion/validacion_cruzada",             # Validación cruzada de modelos
    
    # 🔬 EXPERIMENTOS POR HIPÓTESIS
    "codigo/experimentos/hipotesis_HS1",                # Hipótesis específica 1
    "codigo/experimentos/hipotesis_HS2",                # Hipótesis específica 2
    "codigo/experimentos/hipotesis_HS3",                # Hipótesis específica 3
    "codigo/experimentos/hipotesis_HS4",                # Hipótesis específica 4
    "codigo/experimentos/hipotesis_HS5",                # Hipótesis específica 5
    
    # 🛠️ UTILIDADES Y HERRAMIENTAS
    "codigo/utils/logging",                             # Sistema de logging
    "codigo/utils/profiling",                           # Profiling de rendimiento
    "codigo/utils/visualizacion",                       # Utilidades de visualización
    
    # ⚙️ CONFIGURACIONES
    "configs/environment_configs",                      # Configuraciones de entorno
    "configs/experiment_configs",                       # Configuraciones de experimentos
    "configs/model_configs",                            # Configuraciones de modelos
    
    # 📊 GESTIÓN DE DATOS
    "datos/external",                                   # Datos externos (descargados)
    "datos/processed/augmented",                        # Datos aumentados
    "datos/processed/features",                         # Características extraídas
    "datos/processed/frames",                           # Frames de video procesados
    "datos/raw/imagenes",                               # Imágenes originales
    "datos/raw/metadata",                               # Metadatos de los datos
    "datos/raw/videos",                                 # Videos originales
    "datos/synthetic",                                  # Datos sintéticos generados
    
    # 📚 DOCUMENTACIÓN
    "documentacion/gestion_proyecto",                   # Gestion de proyecto con Git
    "documentacion/configuraciones",                    # Documentación de configuraciones
    "documentacion/procedimientos",                     # Procedimientos y protocolos
    "documentacion/protocolos",                         # Protocolos experimentales
    
    # 🔬 RESULTADOS DE EXPERIMENTOS
    "experimentos/cap4_implementacion",                 # Resultados capítulo 4
    "experimentos/cap5_resultados/escalabilidad",       # Pruebas de escalado
    "experimentos/cap5_resultados/evaluacion_edge",     # Evaluación en dispositivos edge
    "experimentos/cap5_resultados/impacto_optimizacion", # Impacto de optimizaciones
    "experimentos/cap5_resultados/rendimiento_base",    # Línea base de performance
    "experimentos/cap5_resultados/tiempo_real",         # Pruebas en tiempo real
    "experimentos/cap5_resultados/validacion_cruzada",  # Validación estadística
    "experimentos/comparativas",                        # Comparativas entre enfoques
    
    # 🤖 MODELOS DE IA
    "modelos/base/fusion",                              # Modelos base de fusión
    "modelos/base/temporal",                            # Modelos base temporales
    "modelos/base/vision",                              # Modelos base de visión
    "modelos/checkpoints",                              # Puntos de guardado
    "modelos/deployed",                                 # Modelos desplegados
    "modelos/optimized/onnx",                           # Modelos optimizados ONNX
    "modelos/optimized/pruned",                         # Modelos podados
    "modelos/optimized/quantized",                      # Modelos cuantizados
    
    # 📓 NOTEBOOKS JUPYTER
    "notebooks/experimentos/comparativas",              # Comparativas entre modelos
    "notebooks/experimentos/hipotesis_HS1",             # Experimentos hipótesis 1
    "notebooks/experimentos/hipotesis_HS2",             # Experimentos hipótesis 2
    "notebooks/experimentos/hipotesis_HS3",             # Experimentos hipótesis 3
    "notebooks/experimentos/hipotesis_HS4",             # Experimentos hipótesis 4
    "notebooks/experimentos/hipotesis_HS5",             # Experimentos hipótesis 5
    "notebooks/experimentos/modelos_base",              # Experimentos con modelos base
    "notebooks/experimentos/optimizacion",              # Optimización de modelos
    
    "notebooks/exploracion/caracteristicas",            # Exploración de características
    "notebooks/exploracion/datos",                      # Exploración de datasets
    "notebooks/exploracion/estadisticas",               # Análisis estadístico
    "notebooks/exploracion/preprocesamiento",           # Preprocesamiento de datos
    
    "notebooks/prototipos/componentes",                 # Prototipos de componentes M1-M9
    "notebooks/prototipos/demo",                        # Demostraciones
    "notebooks/prototipos/edge",                        # Prototipos para edge
    "notebooks/prototipos/pipeline",                    # Prototipos de pipeline completo
    
    "notebooks/visualizacion/datos",                    # Visualización de datos
    "notebooks/visualizacion/interactivas",             # Visualizaciones interactivas
    "notebooks/visualizacion/metricas",                 # Visualización de métricas
    "notebooks/visualizacion/modelos",                  # Visualización de modelos
    "notebooks/visualizacion/resultados",               # Visualización de resultados
    
    # 📈 RESULTADOS Y ANÁLISIS
    "resultados/analisis",                              # Análisis de resultados
    "resultados/figuras",                               # Figuras para publicaciones
    "resultados/metricas_finales",                      # Métricas finales
    "resultados/tablas",                                # Tablas de resultados
    
    # 🔧 SCRIPTS Y HERRAMIENTAS (NUEVO - ESTRUCTURA ACTUAL)
    "scripts/USO_DIARIO",                               # Scripts de uso diario
    "scripts/USO_SEMANAL",                              # Scripts de uso semanal
    "scripts/USO_EMERGENCIA",                           # Scripts de emergencia
    "scripts/USO_ESPECIAL",                             # Scripts de uso especial
    "scripts/VERIFICACION",                             # Scripts de verificación
    
    # 📦 REQUERIMIENTOS (NUEVO - ESTRUCTURA JERÁRQUICA)
    "requerimientos/base",                              # Dependencias base
    "requerimientos/desarrollo",                        # Dependencias desarrollo
    "requerimientos/experimentos",                      # Dependencias experimentos
    "requerimientos/edge",                              # Dependencias edge
    
    # 💾 BACKUPS Y SOFTWARE
    "backups",                                          # Backups del proyecto
    "software/docker",                                  # Configuraciones Docker
    "software/git",                                     # Configuraciones Git
    "software/otros",                                   # Otros software
    "software/python",                                  # Configuraciones Python
    
    # 🐍 ENTORNO VIRTUAL
    "venv_tesis"                                        # Entorno virtual Python
)

# 🔍 VERIFICAR SI ESTRUCTURA YA EXISTE
$estructuraExistente = (Test-Path "codigo") -and (Test-Path "datos") -and (Test-Path "modelos")
if ($estructuraExistente) {
    Write-Host "⚠️  Estructura de proyecto ya existe." -ForegroundColor $ColorAdvertencia
    $respuesta = Read-Host "¿Regenerar estructura completa? Esto hará backup (s/N)"
    
    if ($respuesta -eq 's') {
        Backup-EstructuraExistente
        Write-Host "🔄 Regenerando estructura..." -ForegroundColor $ColorAdvertencia
    } else {
        Write-Host "✅ Manteniendo estructura existente." -ForegroundColor $ColorExito
        exit 0
    }
}

# 📁 CREACIÓN DE CARPETAS
Write-Host "`n📁 Creando estructura de carpetas..." -ForegroundColor $ColorDestacado

$carpetasCreadas = 0
$carpetasExistentes = 0

foreach ($carpeta in $estructura) {
    if (-not (Test-Path $carpeta)) {
        try {
            New-Item -ItemType Directory -Path $carpeta -Force | Out-Null
            Write-Host "   ✅ $carpeta" -ForegroundColor $ColorExito
            $carpetasCreadas++
        }
        catch {
            Write-Host "   ❌ Error creando: $carpeta - $_" -ForegroundColor $ColorError
        }
    } else {
        Write-Host "   📁 $carpeta (ya existe)" -ForegroundColor $ColorInfo
        $carpetasExistentes++
    }
}

# 📝 CREACIÓN DE ARCHIVOS README CON DOCUMENTACIÓN
Write-Host "`n📝 Creando documentación básica..." -ForegroundColor $ColorDestacado

$readmes = @{
    "codigo/Componentes/README.md" = @"
# 🧩 COMPONENTES DEL SISTEMA - TESIS EDGE AI

## Arquitectura Modular M1-M9:

### M1_entrada - Captura de Datos
**Propósito:** Captura y preprocesamiento de datos multimedia

### M2_procesamiento_visual - Análisis de Imágenes
**Propósito:** Extracción de características visuales y detección de rostros

### M3_temporal - Procesamiento Secuencial  
**Propósito:** Análisis de secuencias temporales de microexpresiones

### M4_fusion - Fusión Multimodal
**Propósito:** Combinación de características visuales y temporales

### M5_clasificacion - Modelos de Clasificación
**Propósito:** Clasificación de microexpresiones en categorías

### M6_almacenamiento - Gestión de Datos
**Propósito:** Almacenamiento eficiente de datos y modelos

### M7_visualizacion - Visualización de Resultados
**Propósito:** Visualización interactiva de resultados y métricas

### M8_control - Orquestación del Sistema
**Propósito:** Coordinación de todos los componentes del sistema

### M9_retroalimentacion - Aprendizaje Continuo
**Propósito:** Mejora adaptativa del sistema basada en feedback

## Flujo de Datos:
M1 → M2 → M3 → M4 → M5 → [M6, M7, M8, M9]
"@

    "experimentos/README.md" = @"
# 🔬 EXPERIMENTOS - TESIS EDGE AI

## Estructura Experimental:

### Capítulo 4 - Implementación
**Objetivo:** Desarrollo y validación de componentes individuales

### Capítulo 5 - Resultados  
**Objetivo:** Evaluación completa del sistema y comparativas

#### Subcarpetas:
- **escalabilidad/**: Pruebas de escalado del sistema
- **evaluacion_edge/**: Rendimiento en dispositivos edge
- **impacto_optimizacion/**: Efecto de técnicas de optimización
- **rendimiento_base/**: Línea base de performance
- **tiempo_real/**: Pruebas en condiciones de tiempo real
- **validacion_cruzada/**: Validación estadística robusta

### Comparativas/
**Propósito:** Comparación entre diferentes enfoques
"@

    "modelos/README.md" = @"
# 🤖 MODELOS - TESIS EDGE AI

## Estructura de Modelos:

### base/ - Modelos Base
- **vision/**: Modelos para procesamiento visual
- **temporal/**: Modelos para secuencias temporales
- **fusion/**: Modelos para fusión multimodal

### checkpoints/ - Puntos de Guardado
**Propósito:** Guardado incremental durante entrenamiento

### deployed/ - Modelos para Producción
**Propósito:** Modelos optimizados y listos para deployment

### optimized/ - Modelos Optimizados
- **onnx/**: Modelos convertidos a ONNX
- **pruned/**: Modelos con pruning aplicado
- **quantized/**: Modelos cuantizados
"@

    "requerimientos/README.md" = @"
# 📦 REQUERIMIENTOS - TESIS EDGE AI

## Estructura Jerárquica de Dependencias:

### base/ - Dependencias Fundamentales
- **requerimientos_base_comun.txt**: Dependencias universales
- **requerimientos_base_pytorch.txt**: Stack PyTorch principal
- **requerimientos_base_tensorflow.txt**: Stack TensorFlow comparativo

### desarrollo/ - Herramientas de Desarrollo
- **requerimientos_desarrollo_comun.txt**: Herramientas desarrollo universales
- **requerimientos_desarrollo_pytorch.txt**: Herramientas específicas PyTorch
- **requerimientos_desarrollo_tensorflow.txt**: Herramientas específicas TensorFlow

### experimentos/ - Experimentación Profesional  
- **requerimientos_experimentos_comun.txt**: Herramientas experimentación
- **requerimientos_experimentos_pytorch.txt**: Experimentación PyTorch
- **requerimientos_experimentos_tensorflow.txt**: Experimentación TensorFlow

### edge/ - Deployment en Raspberry Pi
- **requerimientos_edge_comun.txt**: Dependencias ARM optimizadas
- **requerimientos_edge_pytorch.txt**: PyTorch para ARM
- **requerimientos_edge_tensorflow.txt**: TensorFlow Lite

## Estrategia de Instalación:
1. Base → Desarrollo → Experimentos → Edge
2. Elegir UN framework por entorno
3. Usar entornos virtuales separados
"@
}

$readmesCreados = 0
foreach ($readme in $readmes.GetEnumerator()) {
    $ruta = $readme.Key
    $contenido = $readme.Value
    
    if (-not (Test-Path $ruta)) {
        try {
            # Asegurar que existe el directorio padre
            $directorioPadre = Split-Path $ruta -Parent
            if (-not (Test-Path $directorioPadre)) {
                New-Item -ItemType Directory -Path $directorioPadre -Force | Out-Null
            }
            
            $contenido | Out-File -FilePath $ruta -Encoding UTF8
            Write-Host "   ✅ $ruta" -ForegroundColor $ColorExito
            $readmesCreados++
        }
        catch {
            Write-Host "   ❌ Error creando: $ruta - $_" -ForegroundColor $ColorError
        }
    } else {
        Write-Host "   📄 $ruta (ya existe)" -ForegroundColor $ColorInfo
    }
}

# 📊 REPORTE FINAL
Write-Host "`n" + "="*50 -ForegroundColor $ColorTitulo
Write-Host "🎉 ESTRUCTURA DE TESIS CREADA EXITOSAMENTE!" -ForegroundColor White -BackgroundColor DarkGreen

Write-Host "📊 RESUMEN DE CREACIÓN:" -ForegroundColor $ColorDestacado
Write-Host "   • Carpetas en estructura: $($estructura.Count)" -ForegroundColor White
Write-Host "   • Carpetas creadas: $carpetasCreadas" -ForegroundColor $ColorExito
Write-Host "   • Carpetas existentes: $carpetasExistentes" -ForegroundColor $ColorInfo
Write-Host "   • Archivos README creados: $readmesCreados" -ForegroundColor $ColorExito

Write-Host "`🏗️  ORGANIZACIÓN POR ÁREAS:" -ForegroundColor $ColorDestacado
Write-Host "   • 🧩 Componentes: 9 módulos M1-M9" -ForegroundColor White
Write-Host "   • 🔬 Experimentos: 5 hipótesis + 6 categorías resultados" -ForegroundColor White
Write-Host "   • 📊 Datos: Raw → Processed → Synthetic" -ForegroundColor White
Write-Host "   • 🤖 Modelos: Base → Optimized → Deployed" -ForegroundColor White
Write-Host "   • 📓 Notebooks: Exploración → Experimentos → Prototipos" -ForegroundColor White

Write-Host "`🚀 PRÓXIMOS PASOS RECOMENDADOS:" -ForegroundColor $ColorAdvertencia
Write-Host "   1. Crear dependencias: .\scripts\02_crear_dependencias.ps1" -ForegroundColor White
Write-Host "   2. Sincronizar requerimientos: .\scripts\05_sincronizar_requerimientos.ps1" -ForegroundColor White
Write-Host "   3. Configurar PyTorch: .\scripts\03a_configurar_pytorch.ps1" -ForegroundColor White
Write-Host "   4. Verificar sistema: .\scripts\USO_SEMANAL\uso_verificar.ps1" -ForegroundColor White

Write-Host "💡 INFORMACIÓN ADICIONAL:" -ForegroundColor $ColorInfo
Write-Host "   • Python path configurado para importar módulos M1-M9 directamente" -ForegroundColor White
Write-Host "   • Estructura compatible con Docker y entornos virtuales" -ForegroundColor White
Write-Host "   • Backup automático en: backups/estructura_[timestamp]/" -ForegroundColor White

exit 0
