# Tesis Doctoral: Optimización de Modelos de IA para Dispositivos Edge

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/Python-3.8%2B-blue.svg)](https://www.python.org/)
[![GitHub](https://img.shields.io/badge/GitHub-Repository-brightgreen.svg)](https://github.com/cschenone/tesis_edge_ai)

Repositorio oficial de la tesis doctoral sobre optimización y despliegue de modelos de inteligencia artificial en dispositivos edge computing.

## 📋 Descripción del Proyecto

Esta investigación doctoral se centra en el desarrollo y optimización de modelos de deep learning para su implementación eficiente en dispositivos edge con recursos limitados. El proyecto abarca desde la selección de arquitecturas hasta técnicas de compresión y aceleración para entornos restringidos.

### Objetivos Principales

- 🔬 **Investigación**: Desarrollar métodos novedosos para optimizar modelos de IA
- ⚡ **Optimización**: Reducir requisitos computacionales manteniendo precisión
- 📱 **Despliegue**: Implementar modelos en dispositivos edge reales
- 📊 **Evaluación**: Medir rendimiento en métricas de eficiencia y precisión

## 🏗️ Estructura del Repositorio

- **tesis_edge_ai/** - Directorio raíz del proyecto
  - 📚 **documentacion/** - Documentos de la tesis
    - `capitulos/` - Capítulos individuales
    - `referencias/` - Bibliografía y recursos  
    - `presentaciones/` - Material para defensas
  - 🔬 **investigacion/** - Investigación y experimentos
    - `papers/` - Artículos científicos
    - `revision/` - Revisión bibliográfica
    - `propuestas/` - Propuestas de investigación
  - 💻 **codigo/** - Implementaciones y scripts
    - `modelos/` - Arquitecturas de modelos
    - `entrenamiento/` - Scripts de entrenamiento
    - `optimizacion/` - Técnicas de optimización
    - `despliegue/` - Implementación en edge
  - 📊 **experimentos/** - Experimentos y resultados
    - `datos/` - Conjuntos de datos (no versionados)
    - `resultados/` - Resultados de experimentos
    - `metricas/` - Análisis de métricas
  - 🛠️ **herramientas/** - Utilidades y herramientas
    - `visualizacion/` - Scripts de visualización
    - `analisis/` - Análisis de resultados
  - 📝 **administracion/** - Gestión del proyecto
    - `cronogramas/` - Planificación temporal
    - `informes/` - Informes de progreso

**Leyenda de directorios:**
- 📚 **documentacion/**: Documentos formales de la tesis
- 🔬 **investigacion/**: Investigación y estado del arte
- 💻 **codigo/**: Implementaciones técnicas
- 📊 **experimentos/**: Experimentos y resultados
- 🛠️ **herramientas/**: Utilidades de desarrollo
- 📝 **administracion/**: Gestión del proyecto


## 🚀 Comenzando

### Prerrequisitos

- Python 3.8+
- Git
- CUDA (opcional, para aceleración GPU)

### Instalación

1. **Clonar el repositorio**

```bash
    git clone git@github.com:cschenone/tesis_edge_ai.git
    cd tesis_edge_ai
```
    
2. **Configurar entorno virtual**
```bash
   python -m venv venv
   source venv/bin/activate  # Linux/Mac
   # o
   venv\Scripts\activate     # Windows
```

3. **Instalar dependencias**
```bash
   pip install -r requirements.txt
```

### Uso Básico

```bash
# Ejecutar experimento de ejemplo
python codigo/experimentos/ejemplo.py

# Generar gráficos de resultados
python herramientas/visualizacion/plot_results.py

# Compilar documentación
cd documentacion && make pdf
```

## 🔬 Áreas de Investigación

### 1. Compresión de Modelos
- **Pruning**: Eliminación de parámetros redundantes
- **Cuantización**: Reducción de precisión numérica
- **Distillation**: Transferencia de conocimiento entre modelos

### 2. Arquitecturas Eficientes
- MobileNet, EfficientNet, SqueezeNet
- Arquitecturas personalizadas para edge
- Búsqueda neural de arquitecturas (NAS)

### 3. Optimizaciones Hardware-Aware
- Compilación específica por dispositivo
- Uso eficiente de memoria
- Paralelización y vectorización

## 📈 Resultados y Métricas

| Métrica | Objetivo | Estado Actual |
|---------|----------|---------------|
| Precisión | >95% | 🔄 En progreso |
| Tamaño del modelo | <10MB | 🔄 En progreso |
| Latencia de inferencia | <50ms | 🔄 En progreso |
| Consumo de energía | <1W | 🔄 En progreso |

## 🗓️ Cronograma

| Etapa        | Tarea                  | Duración  | Inicio   | Fin      |
|--------------|------------------------|-----------|----------|----------|
| 🔬 Investigación | Revisión Bibliográfica | 6 meses   | 2024-01  | 2024-06  |
| 🔬 Investigación | Propuesta Metodológica | 3 meses   | 2024-07  | 2024-09  |
| 💻 Desarrollo   | Implementación Modelos | 8 meses   | 2024-10  | 2025-05  |
| 💻 Desarrollo   | Optimización           | 6 meses   | 2025-06  | 2025-11  |
| 📊 Evaluación   | Experimentos           | 6 meses   | 2025-12  | 2026-05  |
| 📊 Evaluación   | Análisis Resultados    | 4 meses   | 2026-06  | 2026-09  |
| 📝 Escritura    | Redacción Tesis        | 8 meses   | 2026-10  | 2027-05  |
| 📝 Escritura    | Defensa                | 2 meses   | 2027-06  | 2027-07  |

## 🤝 Contribuciones

Este es un proyecto de investigación individual, pero las sugerencias y discusiones son bienvenidas:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Publicaciones

- **[En Progreso]** Schenone, C. "Optimización de Modelos Transformer para Dispositivos Edge"
- **[Planeado]** Schenone, C. "Técnicas de Compresión para Redes Neuronales en Edge AI"

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 👨‍🔬 Autor

- **Carlos Schenone** - [cschenone@unaj.edu.ar](mailto:cschenone@unaj.edu.ar)
- **Universidad Nacional Arturo Jauretche (UNAJ)**
- **Doctorado en Ingeniería** - Mención en Inteligencia Artificial

## 🙏 Agradecimientos

- Universidad Nacional Arturo Jauretche (UNAJ)
- Directores de tesis y comité evaluador
- Colegas y colaboradores del laboratorio
- Fuentes de financiamiento y becas

---

## 📞 Contacto

[![Email](https://img.shields.io/badge/Email-cschenone%40unaj.edu.ar-red.svg)](mailto:cschenone@unaj.edu.ar)
[![GitHub](https://img.shields.io/badge/GitHub-cschenone-blue.svg)](https://github.com/cschenone)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Perfil%20Profesional-informational.svg)](https://linkedin.com/in/carlos-schenone)

**⚠️ Nota**: Este repositorio contiene trabajo en progreso. El contenido puede cambiar significativamente durante el desarrollo de la investigación.
