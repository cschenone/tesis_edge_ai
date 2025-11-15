# 📚 ÍNDICE DE ACCESO RÁPIDO - TESIS EDGE AI

---

## 🤔 ¿CÓMO USAR ESTE ÍNDICE?

Este documento está diseñado para ayudarte a encontrar rápidamente los archivos que necesitas, incluso si no tienes experiencia técnica.

**Símbolos que verás:**
- 📄 = Documentos de texto o guías
- ⚙️ = Scripts o programas automáticos  
- 📋 = Listas de requisitos o dependencias
- 🔧 = Herramientas de configuración
- 🟢 = Uso frecuente (diario)
- 🟡 = Uso moderado (semanal)
- 🔴 = Uso especial (ocasional)
- 🚨 = Solo emergencias

---

## 📁 ESTRUCTURA PRINCIPAL DEL PROYECTO

### **📂 CARPETA PRINCIPAL** (Donde está todo)
`C:\Users\Carlos\OneDrive\Documentos\doctorado\proyecto\tesis_edge_ai`

### **📚 DOCUMENTACIÓN** (Guías y planificación)
`documentacion`
- Aquí encontrarás manuales y guías sobre cómo trabajar con el proyecto

### **⚙️ SCRIPTS** (Programas automáticos)
`scripts`
- Programas que te ayudan a realizar tareas automáticamente
- **No necesitas entender el código**, solo ejecutarlos

### **📋 REQUERIMIENTOS** (Listas de programas necesarios)
`requerimientos`
- Listas de lo que necesita instalado el proyecto para funcionar

---

## 📄 DOCUMENTOS IMPORTANTES

### **📖 GUÍAS PRINCIPALES**

| 📄 Documento | 📍 Ubicación | 🎯 Para qué sirve |
|-------------|-------------|------------------|
| **Guía de Uso de Git** | `documentacion\gestion_proyecto\Guia_uso_git_tesis.md` | Aprender a guardar y compartir cambios en el proyecto |
| **Estrategia de Trabajo** | `documentacion\Estrategia_de_Trabajo_Optimizada.md` | Plan semanal organizado del trabajo |
| **Plan de Implementación Git** | `documentacion\gestion_proyecto\Plan_implementacion_git.md` | Cómo organizar el control de versiones |
| **Progreso de Tesis** | `Progreso_tesis.md` | Seguimiento del avance del proyecto |
| **README Principal** | `README.md` | Introducción general al proyecto |

**💡 Consejo:** Comienza leyendo el **README Principal** y luego la **Estrategia de Trabajo**.

---

## ⚙️ SCRIPTS ORGANIZADOS POR USO

### **🟢 SCRIPTS DE USO DIARIO** (Los más frecuentes)

**📍 Carpeta:** `scripts\USO_DIARIO`

| ⚙️ Script | 🎯 Qué hace |
|----------|-------------|
| `uso_activar.ps1` | **Prepara el entorno** - Activa todo lo necesario para trabajar |
| `uso_jupyter.ps1` | **Abre el cuaderno** - Inicia Jupyter Lab para programar visualmente |
| `uso_detener.ps1` | **Limpia y cierra** - Cierra todo correctamente al terminar |

**👨‍💻 Uso típico:**
1. Ejecutar `uso_activar.ps1` al comenzar
2. Trabajar con `uso_jupyter.ps1` 
3. Ejecutar `uso_detener.ps1` al finalizar

### **🟡 SCRIPTS DE USO SEMANAL** (Validación y experimentos)

**📍 Carpeta:** `scripts\USO_SEMANAL`

| ⚙️ Script | 🎯 Qué hace |
|----------|-------------|
| `uso_verificar.ps1` | **Revisa que todo funcione** - Verifica el estado del sistema |
| `uso_entrenar.ps1` | **Entrena modelos** - Ejecuta procesos largos de aprendizaje |

### **🔴 SCRIPTS ESPECIALES** (Configuraciones importantes)

**📍 Carpeta:** `scripts\USO_ESPECIAL`

| ⚙️ Script | 🎯 Qué hace |
|----------|-------------|
| `uso_edge.ps1` | **Prepara para dispositivos** - Optimiza modelos para Raspberry Pi |
| `configurar_configuracion_inicial_git.ps1` | **Configura Git** - Prepara el sistema de control de versiones |

### **🚨 SCRIPTS DE EMERGENCIA** (Solo si hay problemas)

**📍 Carpeta:** `scripts\USO_EMERGENCIA`

| ⚙️ Script | 🎯 Qué hace |
|----------|-------------|
| `uso_construir.ps1` | **Reconstruye rápido** - Soluciona problemas menores |
| `uso_reconstruir.ps1` | **Reconstruye completo** - Soluciona problemas graves |

**⚠️ Importante:** Usar estos solo si algo no funciona correctamente.

---

## 🔧 SCRIPTS DE CONFIGURACIÓN

### **⚙️ SCRIPTS PRINCIPALES DE CONFIGURACIÓN**

**📍 Carpeta:** `scripts`

| 🔧 Script | 🎯 Qué hace |
|----------|-------------|
| `00_orquestador_principal.ps1` | **Coordinador principal** - Ejecuta otros scripts en orden |
| `01_crear_estructura.ps1` | **Crea carpetas** - Organiza la estructura del proyecto |
| `02_crear_dependencias.ps1` | **Instala dependencias** - Configura lo que necesita el proyecto |
| `03a_configurar_pytorch.ps1` | **Configura PyTorch** - Prepara el entorno de inteligencia artificial |
| `03b_configurar_tensorflow.ps1` | **Configura TensorFlow** - Prepara otro entorno de IA |
| `04_guia_uso.ps1` | **Muestra ayuda** - Explica cómo usar los scripts |
| `05_sincronizar_requerimientos.ps1` | **Sincroniza requisitos** - Mantiene actualizadas las dependencias |

---

## 📋 REQUERIMIENTOS Y DEPENDENCIAS

### **📦 REQUERIMIENTOS POR CONTEXTO**

**📍 Carpeta:** `requerimientos`

#### **🟡 Base** (Requisitos fundamentales)
- `requerimientos\base\requerimientos_base_comun.txt` - Programas básicos necesarios
- `requerimientos\base\requerimientos_base_pytorch.txt` - Específicos para PyTorch
- `requerimientos\base\requerimientos_base_tensorflow.txt` - Específicos para TensorFlow

#### **🔵 Desarrollo** (Para programar)
- `requerimientos\desarrollo\requerimientos_desarrollo_comun.ps1` - Script de instalación
- `requerimientos\desarrollo\requerimientos_desarrollo_pytorch.txt` - Para desarrollo PyTorch
- `requerimientos\desarrollo\requerimientos_desarrollo_tensorflow.txt` - Para desarrollo TensorFlow

#### **🧪 Experimentos** (Para pruebas y entrenamiento)
- `requerimientos\experimentos\requerimientos_experimentos_comun.txt` - Comunes para experimentos
- `requerimientos\experimentos\requerimientos_experimentos_pytorch.txt` - Experimentos PyTorch
- `requerimientos\experimentos\requerimientos_experimentos_tensorflow.txt` - Experimentos TensorFlow

#### **📱 Edge** (Para dispositivos como Raspberry Pi)
- `requerimientos\edge\requerimientos_edge_comun.txt` - Comunes para edge
- `requerimientos\edge\requerimientos_edge_pytorch.txt` - Edge con PyTorch
- `requerimientos\edge\requerimientos_edge_tensorflow.txt` - Edge con TensorFlow

---

## 🛠️ HERRAMIENTAS DE VERIFICACIÓN

### **🔍 SCRIPTS DE VERIFICACIÓN**

**📍 Carpeta:** `scripts\VERIFICACION`

| 🔧 Script | 🎯 Qué hace |
|----------|-------------|
| `ayuda_scripts.ps1` | **Muestra ayuda** - Explica para qué sirve cada script |
| `verificar_compatibilidad.ps1` | **Revisa compatibilidad** - Verifica que todo funcione junto |
| `verificar_estructura_requerimientos.ps1` | **Revisa requisitos** - Verifica las dependencias |
| `verificar_estructura_scripts.ps1` | **Revisa scripts** - Verifica que los scripts estén bien |
| `verificar_todo.ps1` | **Revisa todo** - Verificación completa del sistema |

---

## 💾 RESPALDOS Y SEGURIDAD

### **📂 CARPETA DE RESPALDOS**

**📍 Carpeta:** `backups`

Aquí se guardan copias de seguridad automáticas de:
- Configuraciones base
- Entornos de desarrollo  
- Configuraciones para experimentos
- Configuraciones para dispositivos edge

**🛡️ Seguridad:** Estos archivos te permiten recuperar el proyecto si algo sale mal.

---

## 🎯 GUÍA RÁPIDA DE INICIO

### **📝 PARA COMENZAR A TRABAJAR:**

1. **📂 Ve a la carpeta del proyecto:**
   `C:\Users\Carlos\OneDrive\Documentos\doctorado\proyecto\tesis_edge_ai`

2. **⚙️ Ejecuta el script de activación:**
   Doble clic en: `scripts\USO_DIARIO\uso_activar.ps1`

3. **📊 Abre el entorno de trabajo:**
   Doble clic en: `scripts\USO_DIARIO\uso_jupyter.ps1`

4. **🧹 Limpia al terminar:**
   Doble clic en: `scripts\USO_DIARIO\uso_detener.ps1`

### **🔧 SI ALGO NO FUNCIONA:**

1. **Primero verifica:** Ejecuta `scripts\USO_SEMANAL\uso_verificar.ps1`
2. **Si persiste:** Ejecuta `scripts\USO_EMERGENCIA\uso_construir.ps1`
3. **Como último recurso:** Ejecuta `scripts\USO_EMERGENCIA\uso_reconstruir.ps1`

---

## 📞 AYUDA ADICIONAL

### **📚 DOCUMENTOS DE REFERENCIA**

- **Guía de Git:** Para aprender a guardar cambios
- **Estrategia de Trabajo:** Para planificar tu semana
- **Progreso de Tesis:** Para registrar avances

### **🔍 VERIFICACIONES RECOMENDADAS**

- **Diariamente:** `uso_verificar.ps1` (versión simple)
- **Semanalmente:** `verificar_todo.ps1` (versión completa)

### **💡 CONSEJOS PRÁCTICOS**

1. **Siempre** ejecuta `uso_activar.ps1` antes de trabajar
2. **Siempre** ejecuta `uso_detener.ps1` al terminar
3. **Guarda frecuentemente** tus cambios
4. **Verifica semanalmente** el estado del sistema
