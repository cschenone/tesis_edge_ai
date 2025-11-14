# =============================================
# DOCKERFILE MULTI-ETAPA - TESIS EDGE AI
# =============================================
# 🎯 ESTRATEGIA: Arquitectura modular para investigación en Edge AI
# 📁 COHERENCIA: Alta - Alineado con estructura de carpetas del proyecto
# 🏗️  PATRÓN: Multi-stage build para optimización de imágenes

# ==================== ETAPA 1: BASE COMÚN ====================
# 🎯 PROPÓSITO: Configuración base del sistema y estructura de carpetas
# 📍 COHERENCIA: ✅ Perfecta con estructura del proyecto
FROM python:3.10-slim-bullseye AS base

# Configuración de entorno Python
ENV PYTHONUNBUFFERED=1
WORKDIR /app

# 🏗️ CREACIÓN DE ESTRUCTURA DE CARPETAS
# 📍 COHERENCIA: ✅ Replica exacta de la estructura del proyecto
RUN mkdir -p \
    # Módulos del sistema (Coherencia: ✅ con codigo/Componentes/)
    codigo/Componentes/M1_entrada \
    codigo/Componentes/M2_procesamiento_visual \
    codigo/Componentes/M3_temporal \
    codigo/Componentes/M4_fusion \
    codigo/Componentes/M5_clasificacion \
    codigo/Componentes/M6_almacenamiento \
    codigo/Componentes/M7_visualizacion \
    codigo/Componentes/M8_control \
    codigo/Componentes/M9_retroalimentacion \
    
    # Entrenamiento y evaluación (Coherencia: ✅ con codigo/entrenamiento/)
    codigo/entrenamiento/configs \
    codigo/entrenamiento/optimizacion \
    codigo/entrenamiento/scripts \
    codigo/evaluacion/metricas \
    codigo/evaluacion/pruebas \
    codigo/evaluacion/validacion_cruzada \
    
    # Experimentos e hipótesis (Coherencia: ✅ con codigo/experiments/)
    codigo/experiments/hipotesis_HS1 \
    codigo/experiments/hipotesis_HS2 \
    codigo/experiments/hipotesis_HS3 \
    codigo/experiments/hipotesis_HS4 \
    codigo/experiments/hipotesis_HS5 \
    
    # Utilidades (Coherencia: ✅ con codigo/utils/)
    codigo/utils/logging \
    codigo/utils/profiling \
    codigo/utils/visualizacion \
    
    # Configuraciones (Coherencia: ✅ Nueva estructura alineada)
    configs/environment_configs \
    configs/experiment_configs \
    configs/model_configs \
    
    # Datos (Coherencia: ✅ con datos/ estructura)
    datos/external \
    datos/processed/augmented \
    datos/processed/features \
    datos/processed/frames \
    datos/raw/imagenes \
    datos/raw/metadata \
    datos/raw/videos \
    datos/synthetic \
    
    # Documentación (Coherencia: ✅ Nueva estructura)
    documentacion/configuraciones \
    documentacion/procedimientos \
    documentacion/protocolos \
    
    # Experimentos por capítulo (Coherencia: ✅ Estructura de tesis)
    experimentos/cap4_implementacion \
    experimentos/cap5_resultados/escalabilidad \
    experimentos/cap5_resultados/evaluacion_edge \
    experimentos/cap5_resultados/impacto_optimizacion \
    experimentos/cap5_resultados/rendimiento_base \
    experimentos/cap5_resultados/tiempo_real \
    experimentos/cap5_resultados/validacion_cruzada \
    experimentos/comparativas \
    
    # Modelos (Coherencia: ✅ Gestión de modelos)
    modelos/base/fusion \
    modelos/base/temporal \
    modelos/base/vision \
    modelos/checkpoints \
    modelos/deployed \
    modelos/optimized/onnx \
    modelos/optimized/pruned \
    modelos/optimized/quantized \
    
    # Notebooks (Coherencia: ✅ Organización por propósito)
    notebooks/experimentos/comparativas \
    notebooks/experimentos/hipotesis_HS1 \
    notebooks/experimentos/hipotesis_HS2 \
    notebooks/experimentos/hipotesis_HS3 \
    notebooks/experimentos/hipotesis_HS4 \
    notebooks/experimentos/hipotesis_HS5 \
    notebooks/experimentos/modelos_base \
    notebooks/experimentos/optimizacion \
    notebooks/exploracion/caracteristicas \
    notebooks/exploracion/datos \
    notebooks/exploracion/estadisticas \
    notebooks/exploracion/preprocesamiento \
    notebooks/prototipos/componentes \
    notebooks/prototipos/demo \
    notebooks/prototipos/edge \
    notebooks/prototipos/pipeline \
    notebooks/visualizacion/datos \
    notebooks/visualizacion/interactivas \
    notebooks/visualizacion/metricas \
    notebooks/visualizacion/modelos \
    notebooks/visualizacion/resultados \
    
    # Resultados (Coherencia: ✅ Análisis y métricas)
    resultados/analisis \
    resultados/figuras \
    resultados/metricas_finales \
    resultados/tablas

# 🔧 INSTALACIÓN DE DEPENDENCIAS DEL SISTEMA
# 📍 COHERENCIA: ✅ Soporte para bibliotecas científicas y visión por computadora
RUN apt-get update && apt-get install -y \
    # Herramientas básicas
    wget curl git \
    
    # OpenCV - Visión por computadora
    libgl1-mesa-glx libglib2.0-0 libsm6 libxext6 \
    libxrender-dev libglu1-mesa libxi6 libxrandr2 \
    
    # Audio - Para análisis multimodal
    libsndfile1 \
    
    # Optimización NumPy/Scipy
    libatlas-base-dev gfortran \
    
    # Compilación - Build tools
    gcc g++ build-essential \
    
    # Fuentes matplotlib - Visualización
    fonts-dejavu \
    
    # Video processing - OpenCV
    ffmpeg libsm6 libxext6 \
    
    # Limpieza
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Actualización de pip
RUN pip install --upgrade pip

# ==================== ETAPA 2: FRAMEWORKS BASE ====================
# 🎯 PROPÓSITO: Instalación específica de frameworks de ML
# 📍 COHERENCIA: ✅ Alta con estructura de requerimientos base

# 🧠 ETAPA BASE PYTORCH - Framework principal
# 📍 COHERENCIA: ✅ Con requerimientos/base_pytorch.txt
FROM base AS base-pytorch
COPY requirements_pytorch.txt .
RUN pip install --no-cache-dir -r requirements_pytorch.txt

# 🤖 ETAPA BASE TENSORFLOW - Para comparativas  
# 📍 COHERENCIA: ✅ Con requerimientos/base_tensorflow.txt
FROM base AS base-tensorflow  
COPY requirements_tensorflow.txt .
RUN pip install --no-cache-dir -r requirements_tensorflow.txt

# ==================== ETAPA 3: CONTEXTOS DE USO ====================
# 🎯 PROPÓSITO: Entornos específicos para diferentes fases del proyecto
# 📍 COHERENCIA: ✅ Excelente con estructura de requerimientos

# 💻 ETAPA DESARROLLO PYTORCH - Entorno principal
# 📍 COHERENCIA: ✅ Con requerimientos/desarrollo_pytorch.txt
FROM base-pytorch AS desarrollo-pytorch
COPY requirements_desarrollo_pytorch.txt .
RUN pip install --no-cache-dir -r requirements_desarrollo_pytorch.txt

# Configuración para desarrollo
EXPOSE 8888 5678  # Jupyter Lab + debugging
VOLUME /app/codigo
VOLUME /app/notebooks  
VOLUME /app/configs
VOLUME /app/documentacion
VOLUME /app/datos
VOLUME /app/experimentos

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--notebook-dir=/app/notebooks"]

# 💻 ETAPA DESARROLLO TENSORFLOW - Para comparativas
# 📍 COHERENCIA: ✅ Con requerimientos/desarrollo_tensorflow.txt
FROM base-tensorflow AS desarrollo-tensorflow
COPY requirements_desarrollo_tensorflow.txt .
RUN pip install --no-cache-dir -r requirements_desarrollo_tensorflow.txt

EXPOSE 8889 5679  # Puerto diferente para evitar conflictos
VOLUME /app/codigo
VOLUME /app/notebooks
VOLUME /app/configs
VOLUME /app/documentacion
VOLUME /app/datos
VOLUME /app/experimentos

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8889", "--no-browser", "--allow-root", "--notebook-dir=/app/notebooks"]

# 🔬 ETAPA EXPERIMENTS PYTORCH - Entrenamiento principal
# 📍 COHERENCIA: ✅ Con requerimientos/experimentos_pytorch.txt
FROM base-pytorch AS experiments-pytorch
COPY requirements_experiments_pytorch.txt .
RUN pip install --no-cache-dir -r requirements_experiments_pytorch.txt

# Configuración experiment tracking
ENV MLFLOW_TRACKING_URI=/app/experimentos/mlruns
ENV WANDB_DIR=/app/experimentos/wandb

VOLUME /app/codigo
VOLUME /app/experimentos
VOLUME /app/datos
VOLUME /app/modelos
VOLUME /app/configs

CMD ["bash", "-c", "mlflow server --host 0.0.0.0 --port 5000 --backend-store-uri /app/experimentos/mlruns & tail -f /dev/null"]

# 🔬 ETAPA EXPERIMENTS TENSORFLOW - Comparativas
# 📍 COHERENCIA: ✅ Con requerimientos/experimentos_tensorflow.txt
FROM base-tensorflow AS experiments-tensorflow
COPY requirements_experiments_tensorflow.txt .
RUN pip install --no-cache-dir -r requirements_experiments_tensorflow.txt

ENV MLFLOW_TRACKING_URI=/app/experimentos/comparativas/mlruns
ENV WANDB_DIR=/app/experimentos/comparativas/wandb

VOLUME /app/codigo
VOLUME /app/experimentos
VOLUME /app/datos
VOLUME /app/modelos
VOLUME /app/configs

CMD ["bash", "-c", "mlflow server --host 0.0.0.0 --port 5001 --backend-store-uri /app/experimentos/comparativas/mlruns & tail -f /dev/null"]

# 📱 ETAPA EDGE PYTORCH - Deployment principal
# 📍 COHERENCIA: ✅ Con requerimientos/edge_pytorch.txt
FROM base-pytorch AS edge-pytorch
COPY requirements_edge_pytorch.txt .
RUN pip install --no-cache-dir -r requirements_edge_pytorch.txt

# 🔧 OPTIMIZACIÓN PARA ENTORNOS EDGE
# 📍 COHERENCIA: ✅ Eliminación de herramientas de desarrollo para reducir tamaño
RUN apt-get remove -y gcc g++ build-essential && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    pip cache purge

VOLUME /app/codigo
VOLUME /app/modelos
VOLUME /app/configs

CMD ["python", "-c", "import torch; print(f'✅ Edge PyTorch {torch.__version__} - Estructura lista')"]

# 📱 ETAPA EDGE TENSORFLOW - Deployment comparativo  
# 📍 COHERENCIA: ✅ Con requerimientos/edge_tensorflow.txt
FROM base-tensorflow AS edge-tensorflow
COPY requirements_edge_tensorflow.txt .
RUN pip install --no-cache-dir -r requirements_edge_tensorflow.txt

# Optimizar para edge
RUN apt-get remove -y gcc g++ build-essential && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    pip cache purge

VOLUME /app/codigo
VOLUME /app/modelos
VOLUME /app/configs

CMD ["python", "-c", "import tensorflow as tf; print(f'✅ Edge TensorFlow {tf.__version__} - Estructura lista')"]

# ==================== ETAPA FINAL ====================
# 🎯 PROPÓSITO: Imagen por defecto para uso general
# 📍 COHERENCIA: ✅ Usa experiments-pytorch como etapa principal
FROM experiments-pytorch AS final
CMD ["python", "-c", "print('✅ Contenedor TESIS EDGE AI - Estructura completa lista')"]
