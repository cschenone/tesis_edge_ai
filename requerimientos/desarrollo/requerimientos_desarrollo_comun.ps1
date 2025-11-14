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
