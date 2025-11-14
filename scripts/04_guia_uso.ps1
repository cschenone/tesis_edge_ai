# =============================================
# GUÍA DE USO - ESTRATEGIA PYTORCH vs TENSORFLOW
# =============================================
# 🎯 OBJETIVO: Guía práctica para el uso de frameworks en la tesis
# ⚠️  ADVERTENCIA: Sigue estrictamente esta estrategia para evitar conflictos
# 💡 USO: Consultar antes de instalar o cambiar entre frameworks
# 🔧 ACTUALIZACIÓN: Verificar rutas si cambia la estructura del proyecto

# 🎨 CONFIGURACIÓN DE COLORES
$ColorTitulo = "Cyan"
$ColorExito = "Green"
$ColorAdvertencia = "Yellow"
$ColorError = "Red"
$ColorInfo = "Gray"
$ColorDestacado = "Magenta"

Write-Host "📚 GUÍA DE ESTRATEGIA - PYTORCH vs TENSORFLOW" -ForegroundColor $ColorTitulo
Write-Host "==============================================" -ForegroundColor $ColorTitulo

# 🎯 ESTRATEGIA RECOMENDADA
Write-Host "🎯 ESTRATEGIA RECOMENDADA PARA LA TESIS:" -ForegroundColor $ColorDestacado
Write-Host "   1. 💻 DESARROLLO PRINCIPAL: PyTorch (entorno diario)" -ForegroundColor $ColorExito
Write-Host "   2. 🔬 EXPERIMENTACIÓN: PyTorch (entrenamientos principales)" -ForegroundColor $ColorExito
Write-Host "   3. 🤖 COMPARATIVAS: TensorFlow (solo para validación final)" -ForegroundColor $ColorAdvertencia
Write-Host "   4. 📱 DEPLOYMENT: Elegir el que mejor funcione en Raspberry Pi" -ForegroundColor $ColorExito
Write-Host "   5. 📊 ANÁLISIS: Comparar métricas entre ambos frameworks" -ForegroundColor $ColorInfo

# 📁 ESTRUCTURA JERÁRQUICA DE DEPENDENCIAS
Write-Host "🏗️  ESTRUCTURA JERÁRQUICA IMPLEMENTADA:" -ForegroundColor $ColorDestacado
Write-Host "   📦 BASE → 💻 DESARROLLO → 🔬 EXPERIMENTOS → 📱 EDGE" -ForegroundColor White

Write-Host "📁 ARCHIVOS DE REQUERIMIENTOS DISPONIBLES:" -ForegroundColor $ColorDestacado

Write-Host "🏆 PYTORCH - STACK PRINCIPAL (USA ESTOS):" -ForegroundColor $ColorExito
Write-Host "   • requerimientos/base/requerimientos_base_pytorch.txt" -ForegroundColor White
Write-Host "     └── Framework base + dependencias comunes" -ForegroundColor $ColorInfo
Write-Host "   • requerimientos/desarrollo/requerimientos_desarrollo_pytorch.txt" -ForegroundColor White
Write-Host "     └── Base + herramientas desarrollo (Jupyter, debugging)" -ForegroundColor $ColorInfo
Write-Host "   • requerimientos/experimentos/requerimientos_experimentos_pytorch.txt" -ForegroundColor White
Write-Host "     └── Desarrollo + herramientas experimentación (MLflow, Optuna)" -ForegroundColor $ColorInfo
Write-Host "   • requerimientos/edge/requerimientos_edge_pytorch.txt" -ForegroundColor White
Write-Host "     └── Versiones ARM para Raspberry Pi" -ForegroundColor $ColorInfo

Write-Host "🤖 TENSORFLOW - SOLO COMPARATIVAS:" -ForegroundColor $ColorAdvertencia
Write-Host "   • requerimientos/base/requerimientos_base_tensorflow.txt" -ForegroundColor White
Write-Host "     └── Framework alternativo para comparativas" -ForegroundColor $ColorInfo
Write-Host "   • requerimientos/desarrollo/requerimientos_desarrollo_tensorflow.txt" -ForegroundColor White
Write-Host "     └── Base + herramientas desarrollo TensorFlow" -ForegroundColor $ColorInfo
Write-Host "   • requerimientos/experimentos/requerimientos_experimentos_tensorflow.txt" -ForegroundColor White
Write-Host "     └── Desarrollo + experimentación TensorFlow" -ForegroundColor $ColorInfo
Write_Host "   • requerimientos/edge/requerimientos_edge_tensorflow.txt" -ForegroundColor White
Write-Host "     └── TensorFlow Lite para Raspberry Pi" -ForegroundColor $ColorInfo

Write-Host "🔄 ARCHIVOS COMUNES (COMPARTIDOS):" -ForegroundColor $ColorInfo
Write-Host "   • requerimientos/base/requerimientos_base_comun.txt" -ForegroundColor White
Write-Host "   • requerimientos/desarrollo/requerimientos_desarrollo_comun.txt" -ForegroundColor White
Write-Host "   • requerimientos/experimentos/requerimientos_experimentos_comun.txt" -ForegroundColor White
Write-Host "   • requerimientos/edge/requerimientos_edge_comun.txt" -ForegroundColor White

# 🚀 FLUJOS DE TRABAJO PRÁCTICOS
Write-Host "🚀 FLUJOS DE TRABAJO RECOMENDADOS:" -ForegroundColor $ColorDestacado

Write-Host "💻 FLUJO 1: DESARROLLO DIARIO (PyTorch)" -ForegroundColor $ColorExito
Write-Host "   • Orquestador: .\scripts\00_orquestador_principal.ps1 -Fase diario" -ForegroundColor White
Write-Host "   • Manual: .\scripts\USO_DIARIO\uso_activar.ps1" -ForegroundColor White
Write-Host "   • Jupyter: .\scripts\USO_DIARIO\uso_jupyter.ps1" -ForegroundColor White
Write-Host "   • Dependencias: requerimientos/desarrollo/requerimientos_desarrollo_pytorch.txt" -ForegroundColor White

Write-Host "🔬 FLUJO 2: EXPERIMENTACIÓN (PyTorch)" -ForegroundColor $ColorExito
Write-Host "   • Orquestador: .\scripts\00_orquestador_principal.ps1 -Fase experimentacion -Hipotesis HS1" -ForegroundColor White
Write-Host "   • Manual: .\scripts\USO_SEMANAL\uso_entrenar.ps1 -Hipotesis HS1" -ForegroundColor White
Write-Host "   • Dependencias: requerimientos/experimentos/requerimientos_experimentos_pytorch.txt" -ForegroundColor White

Write-Host "🤖 FLUJO 3: COMPARATIVAS (TensorFlow)" -ForegroundColor $ColorAdvertencia
Write-Host "   • Configuración: .\scripts\03b_configurar_tensorflow.ps1" -ForegroundColor White
Write-Host "   • Activación: .\venv_tensorflow\Scripts\Activate.ps1" -ForegroundColor White
Write-Host "   • Dependencias: requerimientos/experimentos/requerimientos_experimentos_tensorflow.txt" -ForegroundColor White

Write-Host "📱 FLUJO 4: DEPLOYMENT EDGE" -ForegroundColor $ColorInfo
Write-Host "   • Preparación: .\scripts\USO_ESPECIAL\uso_edge.ps1" -ForegroundColor White
Write-Host "   • Dependencias: requerimientos/edge/requerimientos_edge_pytorch.txt" -ForegroundColor White
Write-Host "   • Alternativa: requerimientos/edge/requerimientos_edge_tensorflow.txt" -ForegroundColor White

# ⚠️ ADVERTENCIAS CRÍTICAS
Write-Host "🚨 ADVERTENCIAS CRÍTICAS DE SEGURIDAD:" -ForegroundColor $ColorError
Write-Host "   • 🔴 NO instalar PyTorch y TensorFlow en el MISMO entorno virtual" -ForegroundColor White
Write-Host "   • 🔴 NO activar ambos entornos simultáneamente" -ForegroundColor White
Write-Host "   • 🔴 NO importar ambos frameworks en el mismo script sin manejo de excepciones" -ForegroundColor White

Write-Host "🟡 CONFLICTOS COMUNES ESPERADOS:" -ForegroundColor $ColorAdvertencia
Write-Host "   • ⚠️  Versiones diferentes de CUDA/cuDNN" -ForegroundColor White
Write-Host "   • ⚠️  Conflictos de bibliotecas (NumPy, protobuf, h5py)" -ForegroundColor White
Write-Host "   • ⚠️  Problemas de memoria GPU si ambos se cargan" -ForegroundColor White

# 💡 EJEMPLOS DE USO SEGURO
Write-Host "💡 EJEMPLOS PRÁCTICOS DE USO SEGURO:" -ForegroundColor $ColorDestacado

Write-Host "📝 EJEMPLO 1: Script de comparativas seguro" -ForegroundColor $ColorInfo
Write-Host "   # En codigo/experimentos/comparativas/comparar_modelos.py:" -ForegroundColor White
Write-Host "   def cargar_framework():" -ForegroundColor White
Write-Host "       try:" -ForegroundColor White
Write-Host "           import torch" -ForegroundColor White
Write-Host "           return 'pytorch', torch.__version__" -ForegroundColor White
Write-Host "       except ImportError:" -ForegroundColor White
Write_Host "           try:" -ForegroundColor White
Write-Host "               import tensorflow as tf" -ForegroundColor White
Write-Host "               return 'tensorflow', tf.__version__" -ForegroundColor White
Write-Host "           except ImportError:" -ForegroundColor White
Write-Host "               return 'none', '0.0.0'" -ForegroundColor White

Write-Host "📝 EJEMPLO 2: Entrenamiento específico por framework" -ForegroundColor $ColorInfo
Write-Host "   # En codigo/entrenamiento/scripts/entrenar_modelo.py:" -ForegroundColor White
Write-Host "   framework, version = cargar_framework()" -ForegroundColor White
Write-Host "   if framework == 'pytorch':" -ForegroundColor White
Write-Host "       from .pytorch_trainer import EntrenadorPyTorch" -ForegroundColor White
Write-Host "       entrenador = EntrenadorPyTorch()" -ForegroundColor White
Write-Host "   elif framework == 'tensorflow':" -ForegroundColor White
Write-Host "       from .tensorflow_trainer import EntrenadorTensorFlow" -ForegroundColor White
Write-Host "       entrenador = EntrenadorTensorFlow()" -ForegroundColor White
Write-Host "   else:" -ForegroundColor White
Write-Host "       raise ImportError('No se encontró ningún framework')" -ForegroundColor White

# 🔧 CONFIGURACIÓN RECOMENDADA
Write-Host "🔧 CONFIGURACIÓN INICIAL RECOMENDADA:" -ForegroundColor $ColorDestacado
Write-Host "   1. 🏗️  Crear estructura: .\scripts\01_crear_estructura.ps1" -ForegroundColor White
Write-Host "   2. 📦 Generar dependencias: .\scripts\02_crear_dependencias.ps1" -ForegroundColor White
Write-Host "   3. 🧠 Configurar PyTorch: .\scripts\03a_configurar_pytorch.ps1" -ForegroundColor White
Write-Host "   4. ✅ Verificar sistema: .\scripts\USO_SEMANAL\uso_verificar.ps1" -ForegroundColor White
Write-Host "   5. 💻 Comenzar desarrollo: .\scripts\USO_DIARIO\uso_activar.ps1" -ForegroundColor White

Write-Host "🔧 CONFIGURACIÓN COMPARATIVAS (OPCIONAL):" -ForegroundColor $ColorAdvertencia
Write-Host "   1. 🤖 Configurar TensorFlow: .\scripts\03b_configurar_tensorflow.ps1" -ForegroundColor White
Write-Host "   2. 🔄 Activar entorno: .\venv_tensorflow\Scripts\Activate.ps1" -ForegroundColor White
Write-Host "   3. 📊 Ejecutar comparativas: .\scripts\USO_SEMANAL\uso_entrenar.ps1 -Framework tensorflow" -ForegroundColor White

# 📊 ESTRATEGIA DE MIGRACIÓN
Write-Host "📊 ESTRATEGIA DE MIGRACIÓN ENTRE FRAMEWORKS:" -ForegroundColor $ColorDestacado
Write-Host "   • 🔄 PyTorch → TensorFlow: Deactivate + activar venv_tensorflow" -ForegroundColor White
Write-Host "   • 🔄 TensorFlow → PyTorch: Deactivate + activar venv_tesis" -ForegroundColor White
Write-Host "   • 💾 Guardar modelos en formatos interoperables (ONNX, SavedModel)" -ForegroundColor White
Write-Host "   • 📝 Documentar claramente qué experimentos usan cada framework" -ForegroundColor White

# 🎯 RESUMEN FINAL
Write-Host "🎯 RESUMEN ESTRATÉGICO:" -ForegroundColor $ColorDestacado
Write-Host "   • ✅ PyTorch: Entorno principal de desarrollo e investigación" -ForegroundColor $ColorExito
Write-Host "   • ✅ TensorFlow: Herramienta de validación para comparativas" -ForegroundColor $ColorAdvertencia
Write-Host "   • ✅ Entornos separados: Evita conflictos y mantiene estabilidad" -ForegroundColor $ColorExito
Write-Host "   • ✅ Estructura jerárquica: Optimiza mantenimiento y actualizaciones" -ForegroundColor $ColorExito

Write-Host "💡 CONSEJO FINAL:" -ForegroundColor $ColorInfo
Write-Host "   Desarrolla el 90% de tu tesis con PyTorch como framework principal." -ForegroundColor White
Write-Host "   Usa TensorFlow solo para el 10% final de validación comparativa." -ForegroundColor White
Write-Host "   Esta estrategia maximiza productividad y minimiza problemas de compatibilidad." -ForegroundColor White

Write-Host "🔗 MÁS INFORMACIÓN:" -ForegroundColor $ColorInfo
Write-Host "   • Documentación: documentacion/protocolos/comparativas_frameworks.md" -ForegroundColor White
Write-Host "   • Scripts de ayuda: .\scripts\VERIFICACION\ayuda_scripts.ps1" -ForegroundColor White
Write-Host "   • Verificación: .\scripts\USO_SEMANAL\uso_verificar.ps1" -ForegroundColor White

exit 0
