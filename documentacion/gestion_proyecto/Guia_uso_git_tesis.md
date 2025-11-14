# 📚 Guía Completa de Git para Tesis Doctoral en Edge AI
## Instructivo Paso a Paso para Principiantes

**Doctorando: Carlos Schenone**  
**Proyecto: tesis_edge_ai**  
**Fecha de Implementación: $(Get-Date -Format 'yyyy-MM-dd')**

## 🎯 INTRODUCCIÓN: GIT PARA INVESTIGADORES

### ¿Qué es Git y por qué es esencial para tu tesis?
Git es tu sistema de control de versiones - piensa en él como un "historial de cambios" superpoderoso para tu proyecto de investigación. Es como tener una máquina del tiempo para tu código, datos y documentos.

### 🛡️ Beneficios para tu investigación:
- ✅ **Nunca pierdes trabajo** - Puedes recuperar versiones anteriores
- ✅ **Trabajas sin miedo** - Experimentas con nuevas ideas sin riesgo
- ✅ **Organización profesional** - Mantienes tu investigación ordenada
- ✅ **Preparas publicaciones** - Facilita la reproducibilidad de experimentos
- ✅ **Colaboración fácil** - Si trabajas con otros investigadores

### 📁 Conceptos Básicos en Términos Sencillos:

| Término Técnico   | Significado para tu Tesis                 |
|-----------------  |---------------------------                |
| **Repositorio**   | Tu carpeta de proyecto con superpoderes   |
| **Commit**        | Una "foto" de tu progreso en una fecha    |
| **Rama (Branch)** | Una línea experimental separada           |
| **Push**          | Guardar tu trabajo en la nube             |
| **Pull**          | Descargar trabajo desde la nube           |


## 🔧 CONFIGURACIÓN INICIAL (30 minutos)

### 📋 PRERREQUISITOS:
- Tener Git instalado (viene con los scripts del proyecto)
- Tener una cuenta en GitHub/GitLab (opcional pero recomendado)
- Tu proyecto `tesis_edge_ai` en tu computadora

### 🚀 PASO 1: CONFIGURAR TU IDENTIDAD
powershell
# Configurar tu nombre (usar tu nombre real)
git config --global user.name "Carlos Schenone"

# Configurar tu email institucional
git config --global user.email "cschenone@unaj.edu.ar"

# Verificar la configuración
git config --global --list

### 🚀 PASO 2: CONFIGURAR EDITOR PREFERIDO
powershell
# Si usas Visual Studio Code (recomendado):
git config --global core.editor "code --wait"

# Si prefieres algo más simple:
git config --global core.editor "notepad"

# Configurar colores para mejor visualización
git config --global color.ui auto

### 🚀 PASO 3: CONFIGURACIÓN ESPECÍFICA PARA TU TESIS
powershell
# Navegar a tu proyecto de tesis
cd C:\Users\Carlos\OneDrive\Documentos\doctorado\proyecto\tesis_edge_ai

# Inicializar Git en tu proyecto (si no está hecho)
git init

# Verificar que todo está listo
git status

## 🏗️ ORGANIZACIÓN DE TU TESIS EN GIT

### 📁 ESTRUCTURA RECOMENDADA:
tesis_edge_ai/           (← Tu repositorio principal)
├── 📁 codigo/
│   ├── 📁 Componentes/  (← Módulos M1-M9 aquí)
│   ├── 📁 experiments/  (← Hipótesis HS1-HS5 aquí)
│   └── 📁 utils/
├── 📁 datos/            (← No se versiona - muy grande)
├── 📁 modelos/          (← No se versiona - muy grande)
├── 📁 notebooks/        (← Tus experimentos y análisis)
├── 📁 documentacion/    (← Protocolos y procedimientos)
└── 📁 scripts/          (← Herramientas automáticas)

## 🎯 ESTRATEGIA DE RAMAS PARA INVESTIGACIÓN:

Vamos a crear una organización que refleje tu metodología de investigación:

### Rama principal - siempre estable y funcional
git branch main

### Rama de desarrollo - integración de todos los módulos
git branch develop

### Ramas para cada módulo de tu framework
git branch feature/M1-entrada
git branch feature/M2-procesamiento-visual
git branch feature/M3-temporal
git branch feature/M4-fusion
git branch feature/M5-clasificacion
git branch feature/M6-almacenamiento
git branch feature/M7-visualizacion
git branch feature/M8-control
git branch feature/M9-retroalimentacion

### Ramas para experimentos e hipótesis
git branch experiments/HS1-acople-cnn-rnn
git branch experiments/HS2-embeddings
git branch experiments/HS3-cuantizacion
git branch experiments/HS4-optimizacion
git branch experiments/HS5-robustez

# 📅 FLUJO DE TRABAJO DIARIO PASO A PASO

## 🌅 MAÑANA: INICIO DE JORNADA (5 minutos)

### PASO 1: ACTUALIZAR Y PREPARAR
#### Navegar a tu proyecto
cd C:\Users\Carlos\OneDrive\Documentos\doctorado\proyecto\tesis_edge_ai

#### Descargar últimos cambios (si trabajas en varias computadoras)
git checkout main
git pull origin main

#### Cambiar a rama de desarrollo
git checkout develop
git pull origin develop

#### Verificar estado actual
git status

#### 📊 Lo que verás en git status:

On branch develop
Your branch is up to date with 'origin/develop'.

nothing to commit, working tree clean

### PASO 2: PLANIFICAR EL DÍA

#### Crear rama específica para el trabajo de hoy
git checkout -b feature/dia-$(date +%Y-%m-%d)

#### Ejemplo: Si hoy trabajarás en M2
git checkout -b feature/M2-procesamiento-visual-$(date +%Y-%m-%d)

## 💻 DURANTE EL DÍA: TRABAJO Y GUARDADO

### PATRÓN RECOMENDADO: COMMITS FRECUENTES

#### ❌ NO HAGAS ESTO:

* Trabajar todo el día sin guardar
* Un commit gigante al final del día
* Mensajes como "cambios" o "update"

#### ✅ HAZ ESTO EN SU LUGAR:

### CADA 2-3 HORAS O CUANDO COMPLETES UNA TAREA:

#### 1. Ver qué has cambiado
git status

#### 2. Preparar los cambios (como seleccionar archivos para guardar)
git add .

#### 3. Guardar con un mensaje descriptivo
git commit -m "feat(M2): implementar normalización facial

- Agregar normalización por histograma
- Implementar equalización de contraste
- Añadir pruebas con dataset FER2013
- Documentar parámetros en configs/"

#### 4. Verificar que se guardó correctamente
git log --oneline -3

## EJEMPLOS DE MENSAJES PROFESIONALES:

### Para desarrollo de módulos:

git commit -m "feat(M3): implementar LSTM bidireccional

- Configurar capas LSTM con 128 unidades
- Implementar mecanismo de atención
- Agregar regularización Dropout 0.3
- Validar con secuencias de 30 frames"

### Para experimentos:

git commit -m "experiment(HS1): validar acople capa conv5

- Configurar transferencia características conv5
- Ejecutar 50 épocas de entrenamiento
- Resultado: 82% precisión, 65ms latencia
- Identificar overfitting después de época 35"

### Para documentación:

git commit -m "docs: actualizar protocolo experimentos HS2

- Documentar procedimiento de extracción embeddings
- Especificar parámetros de reducción dimensionalidad
- Agregar métricas de evaluación comparativa
- Incluir ejemplos de visualización"

## 🌙 TARDE: FINALIZACIÓN DE JORNADA (10 minutos)

### PASO 1: GUARDADO FINAL DEL DÍA

#### Guardar cualquier cambio restante
git add .
git commit -m "cierre: trabajo del $(date +%Y-%m-%d)

PROGRESO DEL DÍA:
✅ Completado: Implementación normalización M2
✅ Avanzado: Configuración LSTM M3
🔜 Próximo: Mecanismo atención M4

PRÓXIMOS PASOS:
- Terminar implementación M3
- Comenzar experimentos HS1
- Optimizar hiperparámetros"

#### Subir todo a la nube (backup automático)
git push origin feature/M2-procesamiento-visual-$(date +%Y-%m-%d)

### PASO 2: ACTUALIZAR RAMA DE DESARROLLO

#### Cambiar a rama develop
git checkout develop

#### Integrar el trabajo del día
git merge feature/M2-procesamiento-visual-$(date +%Y-%m-%d)

#### Subir develop actualizada
git push origin develop

#### Eliminar rama del día (opcional, pero mantiene orden)
git branch -d feature/M2-procesamiento-visual-$(date +%Y-%m-%d)

# 🎯 ESTRATEGIA ESPECÍFICA PARA MÓDULOS M1-M9

## 📋 PLAN POR MÓDULO:

### PARA M1 - ENTRADA:

##### Trabajar en rama específica
git checkout -b feature/M1-entrada-captura

##### Commits típicos para M1
git commit -m "feat(M1): implementar captura video tiempo real"
git commit -m "feat(M1): agregar preprocesamiento frames"
git commit -m "feat(M1): implementar detección facial con Haar Cascades"

### PARA M2 - PROCESAMIENTO VISUAL:

git checkout -b feature/M2-procesamiento-visual
git commit -m "feat(M2): integrar CNN ResNet-18 pre-entrenada"
git commit -m "feat(M2): implementar extracción características capas conv"
git commit -m "feat(M2): agregar normalización y aumento datos"

### PARA M3 - TEMPORAL:

git checkout -b feature/M3-temporal
git commit -m "feat(M3): implementar LSTM para secuencias"
git commit -m "feat(M3): agregar mecanismo atención temporal"
git commit -m "feat(M3): optimizar para largo de secuencias variable"

# 🔬 GESTIÓN DE EXPERIMENTOS HS1-HS5

## 🧪 TRABAJO CON HIPÓTESIS:

### PARA HS1 - ACOPLE CNN-RNN:

#### Crear rama experimental
git checkout -b experiments/HS1-acople-cnn-rnn

#### Commits de experimentación
git commit -m "experiment(HS1): prueba acople capa conv3 vs conv5"
git commit -m "experiment(HS1): resultados capa conv3 - 78% precisión"
git commit -m "experiment(HS1): análisis comparativo latencia vs precisión"

#### Cuando el experimento termine
git checkout develop
git merge experiments/HS1-acople-cnn-rnn
git commit -m "docs: conclusiones HS1 - capa conv3 óptima"

## PATRÓN PARA TODOS LOS EXPERIMENTOS:
* Rama específica para cada hipótesis
* Commits descriptivos de cada prueba
* Resultados documentados en los mensajes
* Fusión a develop con conclusiones

# 📊 HERRAMIENTAS DE SEGUIMIENTO

## 🔍 COMANDOS PARA VER TU PROGRESO:

### VER ESTADO ACTUAL:
git status # Muestra qué archivos has modificado

### VER HISTORIAL COMPACTO:
git log --oneline --graph --all # Muestra todo el historial visualmente

### VER PROGRESO POR MÓDULO:
git log --oneline --grep="M2" # Ver commits específicos de M2
git log --oneline --grep="experiment" # Ver commits de experimentos
git log --oneline --since="1 week ago" --author="Carlos" # Ver tu trabajo de la última semana

### VER CAMBIOS ESPECÍFICOS:
git diff codigo/Componentes/M2_procesamiento_visual/modelo_cnn.py # Ver diferencias en un archivo
git diff --staged # Ver qué cambiará en el próximo commit

## 🛡️ BACKUP Y SEGURIDAD

### ☁️ CONFIGURACIÓN CON GITHUB/GITLAB:

#### PASO 1: CREAR REPOSITORIO REMOTO

* Ve a GitHub.com → Click "+" → "New repository"
* Nombre: tesis-edge-ai-microexpresiones
* Descripción: "Tesis doctoral: Sistema CNN-RNN para detección de microexpresiones"
* NO inicializar con README (ya tienes uno)
* Click "Create repository"

#### PASO 2: CONECTAR TU PROYECTO LOCAL

##### En tu PowerShell, en la carpeta del proyecto:
git remote add origin https://github.com/tuusuario/tesis-edge-ai-microexpresiones.git

##### Verificar la conexión
git remote -v

##### Subir todo por primera vez
git push -u origin main
git push -u origin develop

#### PASO 3: BACKUP AUTOMÁTICO DIARIO
##### Al final de cada día, ejecuta:
git push origin --all

##### Esto sube TODAS tus ramas a la nube
##### Tu trabajo está seguro incluso si tu computadora falla

## 🚨 SOLUCIÓN DE PROBLEMAS COMUNES

### ❌ PROBLEMA: "No me deja ejecutar scripts en PowerShell"

#### SOLUCIÓN:

Ejecutar PowerShell como Administrador

Luego ejecutar:
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

Responder "Y" cuando pregunte

### ❌ PROBLEMA: "git no es reconocido como comando"

#### SOLUCIÓN:

Git viene incluido en los scripts de tu proyecto

Ejecuta: .\software\verificar_software.ps1

O reinstala desde software/git/

### ❌ PROBLEMA: "Your local changes would be overwritten by merge"

#### SOLUCIÓN:

##### Guardar temporalmente tus cambios
git stash

##### Actualizar desde remoto
git pull origin main

##### Recuperar tus cambios
git stash pop

##### Si hay conflictos, resolverlos manualmente
##### Luego commit y push
git add .
git commit -m "fix: resolver conflictos de fusión"
git push origin main

### ❌ PROBLEMA: "Commit en la rama equivocada"

#### SOLUCIÓN:

##### Deshacer el último commit pero mantener cambios
git reset --soft HEAD~1

##### Cambiar a la rama correcta
git checkout feature/M2-procesamiento-visual

##### Hacer commit donde corresponde
git add .
git commit -m "feat(M2): implementar normalización facial"

### ❌ PROBLEMA: "Olvidé agregar un archivo al último commit"

#### SOLUCIÓN:

##### Agregar el archivo olvidado
git add archivo_olvidado.py

##### Actualizar el último commit
git commit --amend --no-edit

##### Si ya habías hecho push, forzar actualización
git push origin feature/M2-procesamiento-visual --force

## 📈 SEGUIMIENTO DE PROGRESO ACADÉMICO

### 📊 TABLA DE PROGRESO (ACTUALIZAR SEMANALMENTE)

Crea un archivo PROGRESO.md en tu proyecto:

# 📈 PROGRESO TESIS DOCTORAL

## 🏗️ MÓDULOS DEL SISTEMA

| Módulo                    | Estado            | Última Actualización  | Commits   | Próximo Objetivo      |
|--------                   |--------           |---------------------  |---------  |------------------     |
| **M1 - Entrada**          | ✅ Completado     | 2024-01-15            | 12        | Mantenimiento         |
| **M2 - Visual**           | 🟡 En Progreso    | 2024-01-18            | 8         | Optimizar CNN         |
| **M3 - Temporal**         | 🟡 En Desarrollo  | 2024-01-17            | 6         | Mejorar LSTM          |
| **M4 - Fusión**           | 🔴 Pendiente      | -                     | 0         | Diseñar arquitectura  |
| **M5 - Clasificación**    | 🔴 Pendiente      | -                     | 0         | Investigar métodos    |

## 🧪 EXPERIMENTOS E HIPÓTESIS

| Hipótesis                 | Estado            | Resultados    | Commits   | Siguiente Paso        |
|-----------                |--------           |------------   |---------  |----------------       |
| **HS1 - Acople**          | 🟡 En Curso       | 78% precisión | 5         | Probar capa conv5     |
| **HS2 - Embeddings**      | 🔴 No Iniciado    | -             | 0         | Diseñar experimento   |
| **HS3 - Cuantización**    | 🔴 No Iniciado    | -             | 0         | Revisar literatura    |

## 📅 ACTIVIDAD RECIENTE

# Actualizar esta sección semanalmente con:
git log --oneline --since="1 week ago" --author="Carlos"

## 🎯 ENTREGAS ACADÉMICAS CON GIT:

### PARA ENTREGA DE CAPÍTULO:

#### Crear tag de versión
git tag -a "capitulo-3-implementacion" -m "Entrega Capítulo 3: Implementación Sistema

- Módulos M1-M3 completos y probados
- Pipeline básico CNN-RNN funcionando
- Experimentos HS1 en progreso
- Listo para revisión del director"

#### Subir el tag
git push origin "capitulo-3-implementacion"

### PARA PUBLICACIONES:

#### Crear rama específica para paper
git checkout -b paper/ieee-microexpressions-2024

#### Desarrollar el paper
git commit -m "docs: sección introducción paper IEEE"
git commit -m "docs: metodología y experimentos paper"
git commit -m "docs: resultados y conclusiones paper"

#### Cuando se acepte el paper
git tag -a "paper-ieee-aceptado" -m "Paper aceptado en IEEE Transactions"

## 🔄 FLUJO VISUAL COMPLETO
graph TD
    A[Inicio Día] --> B[git pull & checkout develop]
    B --> C[Crear rama feature/dia-fecha]
    C --> D[Trabajar en módulos/experimentos]
    D --> E[Commits cada 2-3 horas]
    E --> F{¿Fin de día?}
    F -->|No| D
    F -->|Sí| G[Commit final con resumen]
    G --> H[Push a rama del día]
    H --> I[Merge a develop]
    I --> J[Push develop]
    J --> K[Fin Día]

## 🎯 CHECKLIST DE BUENAS PRÁCTICAS

### ✅ CADA DÍA:
* git pull al comenzar
* git status para ver cambios
* Commits frecuentes con mensajes descriptivos
* git push al finalizar
* Resumen del día en último commit

### ✅ CADA SEMANA:
* Actualizar tabla de progreso
* Revisar git log --oneline --since="1 week ago"
* Limpiar ramas mergeadas
* Verificar que todo está en la nube

### ✅ CADA MES:
* Revisar organización de ramas
* Actualizar documentación general
* Preparar entregables académicos
* Backup completo del repositorio

## 🏆 RESUMEN FINAL: TU NUEVO FLUJO DE TRABAJO
🎉 ¡FELICITACIONES! Ahora tienes un sistema profesional para tu investigación.

### 📋 TU NUEVA RUTINA DIARIA:

#### 🌅 MAÑANA (5 min):
git pull origin main && git checkout develop
git pull origin develop
git checkout -b feature/dia-$(date +%Y-%m-%d)

#### 💻 DURANTE EL DÍA:
Trabajar en tus módulos
Cada 2-3 horas: git add . && git commit -m "mensaje descriptivo"

#### 🌙 TARDE (10 min):
git add . && git commit -m "cierre: resumen del día"
git push origin feature/dia-$(date +%Y-%m-%d)
git checkout develop && git merge feature/dia-$(date +%Y-%m-%d)
git push origin develop

## 🚀 PRÓXIMOS PASOS INMEDIATOS:
* HOY MISMO: Configura Git con tu nombre y email
* ESTA SEMANA: Implementa el flujo diario con un módulo
* PRÓXIMA SEMANA: Configura GitHub para backup en la nube
* PRÓXIMO MES: Domina el trabajo con ramas experimentales

## 📞 ¿NECESITAS AYUDA?
📖 Revisa esta guía - Está diseñada para consulta continua
⚙️ Ejecuta scripts de ayuda - .\scripts\VERIFICACION\ayuda_scripts.ps1
📧 Contacta al autor - cschenone@unaj.edu.ar

## 📥 INSTRUCCIONES DE DESCARGA E IMPLEMENTACIÓN

### PASO 1: GUARDAR EL ARCHIVO
1. Copia TODO el contenido del bloque de código anterior (Ctrl+A, Ctrl+C)
2. Pega en un editor de texto (VS Code, Notepad++, etc.)
3. Guarda como: `GUIA_GIT_TESIS.md`
4. Ubicación: `C:\Users\Carlos\OneDrive\Documentos\doctorado\proyecto\tesis_edge_ai\documentacion\`

### PASO 2: ARCHIVOS ADICIONALES RECOMENDADOS

📄 PROGRESO.md (Crear en la raíz del proyecto):

#### 📈 PROGRESO TESIS DOCTORAL
##### Actualizado: $(Get-Date -Format 'yyyy-MM-dd')

[Contenido de la tabla de progreso como se muestra en la guía principal]

📄 .gitignore (Para tu proyecto específico): # Datos grandes - no versionar

datos/
modelos/
*.h5
*.pkl
*.joblib

logs/ # Logs y caché
__pycache__/
*.pyc

configs/local/ # Configuraciones locales
.env

### PASO 3: SCRIPT DE CONFIGURACIÓN INICIAL

⚙️ configurar_git.ps1 (Guardar en scripts/):

/# Script de configuración inicial de Git para la tesis
Write-Host "🎯 CONFIGURANDO GIT PARA TESIS DOCTORAL" -ForegroundColor Green

/# Configurar identidad
git config --global user.name "Carlos Schenone"
git config --global user.email "cschenone@unaj.edu.ar"

/# Configurar editor
git config --global core.editor "code --wait"
git config --global color.ui auto

/# Verificar configuración
Write-Host "✅ Configuración completada:" -ForegroundColor Green
git config --global --list

## 🎯 PLAN DE IMPLEMENTACIÓN POR ETAPAS

### ETAPA 1 (Día 1): Configuración Básica
* Ejecutar script de configuración
* Leer y entender la guía completa
* Crear estructura de carpetas recomendada

### ETAPA 2 (Semana 1): Flujo Diario
* Implementar rutina mañana/tarde
* Practicar con commits descriptivos
* Configurar GitHub para backup

### ETAPA 3 (Mes 1): Dominio Avanzado
* Trabajar con múltiples ramas (M1-M9)
* Implementar estrategia de experimentos (HS1-HS5)
* Usar herramientas de seguimiento

### ETAPA 4 (Investigación Continua):
* Entregas académicas con tags
* Colaboración (si aplica)
* Optimización del flujo de trabajo

## 📊 MÉTRICAS DE ÉXITO

Métrica	                Objetivo	                    Frecuencia
-------------------------------------------------------------------------
Commits por día	        3-5 commits descriptivos	    Diario
Ramas activas	        2-3 (desarrollo + features)	    Semanal
Backup en nube	        100% de commits pusheados	    Diario
Progreso documentado    Tabla PROGRESO.md actualizada	Semanal
Problemas resueltos     Uso de guía para solucionar	    Según necesidad

