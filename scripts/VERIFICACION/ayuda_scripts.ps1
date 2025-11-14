# =============================================================================
# ESTRATEGIA: Script Central de Ayuda - Sistema de Tesis Edge AI
# PROPÓSITO: Documentación unificada e interactiva para toda la suite de scripts
# COHERENCIA: Categorización por frecuencia → Criticidad → Flujos de trabajo
# INNOVACIÓN: Sistema de prevención de errores con alternativas específicas
# =============================================================================

# -----------------------------------------------------------------------------
# FASE 1: ENCABEZADO Y CONTEXTO GLOBAL
# Estrategia: Establecer autoridad y propósito desde el inicio
# -----------------------------------------------------------------------------
Write-Host "🎯 AYUDA COMPLETA - SCRIPTS TESIS EDGE AI" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "📚 Sistema de automatización para investigación doctoral" -ForegroundColor Gray
Write-Host "🔧 Mantenimiento, desarrollo y experimentación automatizados" -ForegroundColor Gray
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host ""

# -----------------------------------------------------------------------------
# FASE 2: SCRIPTS DE USO DIARIO (Operaciones rutinarias de bajo riesgo)
# Estrategia: Presentar primero lo más usado y seguro
# -----------------------------------------------------------------------------
Write-Host "🟢 SCRIPTS DE USO DIARIO" -ForegroundColor Green
Write-Host "─" * 40 -ForegroundColor Green
Write-Host "💡 Para el flujo de trabajo cotidiano - Rápidos y seguros" -ForegroundColor Gray
Write-Host ""

# Script: Activación diaria del ambiente
# ESTRATEGIA: Comenzar con el punto de entrada principal del sistema
Write-Host "📄 USO_DIARIO_ACTIVAR.PS1" -ForegroundColor White
Write-Host "   📅 CUÁNDO USAR: Todos los días al comenzar a trabajar" -ForegroundColor Gray
Write-Host "   🎯 QUÉ HACE: Activa el ambiente virtual y posiciona en el proyecto" -ForegroundColor Gray
Write-Host "   ⏰ TIEMPO: 5-10 segundos" -ForegroundColor Gray
Write-Host "   ✅ RESULTADO: Ambiente activado, Python verificado, ubicación lista" -ForegroundColor Gray
Write-Host "   💡 EJECUTAR: .\uso_diario_activar.ps1" -ForegroundColor Yellow
Write-Host ""

# Script: Inicio de Jupyter para desarrollo
# ESTRATEGIA: Herramienta principal de desarrollo e investigación
Write-Host "📄 USO_DIARIO_JUPYTER.PS1" -ForegroundColor White
Write-Host "   📅 CUÁNDO USAR: Cuando vas a programar o experimentar en notebooks" -ForegroundColor Gray
Write-Host "   🎯 QUÉ HACE: Inicia Jupyter Lab en contenedor Docker" -ForegroundColor Gray
Write-Host "   ⏰ TIEMPO: 15-30 segundos" -ForegroundColor Gray
Write-Host "   🌐 RESULTADO: Jupyter disponible en http://localhost:8888" -ForegroundColor Gray
Write-Host "   🔑 CREDENCIALES: Token: tesis2024" -ForegroundColor Gray
Write-Host "   💡 EJECUTAR: .\uso_diario_jupyter.ps1" -ForegroundColor Yellow
Write-Host ""

# Script: Limpieza diaria al terminar
# ESTRATEGIA: Cierre seguro que libera recursos
Write-Host "📄 USO_DIARIO_DETENER.PS1" -ForegroundColor White
Write-Host "   📅 CUÁNDO USAR: Al terminar tu jornada de trabajo" -ForegroundColor Gray
Write-Host "   🎯 QUÉ HACE: Detiene todos los contenedores activos" -ForegroundColor Gray
Write-Host "   ⏰ TIEMPO: 5-10 segundos" -ForegroundColor Gray
Write-Host "   ✅ RESULTADO: Todos los contenedores detenidos, recursos liberados" -ForegroundColor Gray
Write-Host "   💡 EJECUTAR: .\uso_diario_detener.ps1" -ForegroundColor Yellow
Write-Host ""

# -----------------------------------------------------------------------------
# FASE 3: SCRIPTS DE USO SEMANAL (Mantenimiento y experimentos)
# Estrategia: Scripts de mantenimiento preventivo y procesos largos
# -----------------------------------------------------------------------------
Write-Host "🟡 SCRIPTS DE USO SEMANAL" -ForegroundColor Yellow
Write-Host "─" * 40 -ForegroundColor Yellow
Write-Host "🔧 Para mantenimiento y procesos especializados - Uso moderado" -ForegroundColor Gray
Write-Host ""

# Script: Verificación integral del sistema
# ESTRATEGIA: Herramienta de diagnóstico preventivo
Write-Host "📄 USO_SEMANAL_VERIFICAR.PS1" -ForegroundColor White
Write-Host "   📅 CUÁNDO USAR: Una vez por semana o cuando algo no funciona" -ForegroundColor Gray
Write-Host "   🎯 QUÉ HACE: Verifica TODO el sistema (Python, Docker, contenedores, archivos)" -ForegroundColor Gray
Write-Host "   ⏰ TIEMPO: 1-2 minutos" -ForegroundColor Gray
Write-Host "   📊 RESULTADO: Reporte completo con ✅ y ❌, recomendaciones" -ForegroundColor Gray
Write-Host "   🛠️  DIAGNÓSTICO: Identifica problemas antes de que sean críticos" -ForegroundColor Gray
Write-Host "   💡 EJECUTAR: .\uso_semanal_verificar.ps1" -ForegroundColor Yellow
Write-Host ""

# Script: Entrenamiento de modelos
# ESTRATEGIA: Proceso especializado para experimentación
Write-Host "📄 USO_SEMANAL_ENTRENAR.PS1" -ForegroundColor White
Write-Host "   📅 CUÁNDO USAR: Para entrenar modelos o ejecutar experimentos largos" -ForegroundColor Gray
Write-Host "   🎯 QUÉ HACE: Inicia contenedor de experimentos (optimizado para GPU)" -ForegroundColor Gray
Write-Host "   ⏰ TIEMPO: 15-30 segundos" -ForegroundColor Gray
Write-Host "   🔬 RESULTADO: Entorno listo para MLflow, entrenamientos largos, tracking" -ForegroundColor Gray
Write-Host "   💻 RECURSOS: Usa GPU si disponible, más memoria para modelos grandes" -ForegroundColor Gray
Write-Host "   💡 EJECUTAR: .\uso_semanal_entrenar.ps1" -ForegroundColor Yellow
Write-Host ""

# -----------------------------------------------------------------------------
# FASE 4: SCRIPTS DE EMERGENCIA (Uso excepcional con advertencias)
# Estrategia: Scripts destructivos con advertencias explícitas y alternativas
# -----------------------------------------------------------------------------
Write-Host "🔴 SCRIPTS DE USO ESPORÁDICO/EMERGENCIA" -ForegroundColor Red
Write-Host "─" * 50 -ForegroundColor Red
Write-Host "🚨 SOLO para problemas críticos - DESTRUCTIVOS y de LARGA DURACIÓN" -ForegroundColor Gray
Write-Host ""

# Script: Reconstrucción completa del ambiente virtual
# ESTRATEGIA: Advertencias múltiples y criterios estrictos de uso
Write-Host "📄 USO_EMERGENCIA_RECONSTRUIR.PS1" -ForegroundColor White
Write-Host "   ⚠️  ADVERTENCIA: ELIMINA COMPLETAMENTE el ambiente anterior" -ForegroundColor Red
Write-Host "   📅 CUÁNDO USAR: SOLO cuando:" -ForegroundColor Gray
Write-Host "     • Ambiente virtual corrupto" -ForegroundColor Gray
Write-Host "     • Conflictos graves de dependencias" -ForegroundColor Gray
Write-Host "     • Cambio de versión de Python" -ForegroundColor Gray
Write-Host "     • Quieres empezar desde CERO" -ForegroundColor Gray
Write-Host "   🎯 QUÉ HACE: Elimina venv_tesis y crea uno nuevo desde cero" -ForegroundColor Gray
Write-Host "   ⏰ TIEMPO: 20-35 minutos" -ForegroundColor Gray
Write-Host "   ✅ RESULTADO: Ambiente NUEVO, dependencias reinstaladas, verificado" -ForegroundColor Gray
Write-Host "   ❌ CUÁNDO NO USAR: Ambiente funciona, solo necesitas un paquete" -ForegroundColor Gray
Write-Host "   💡 EJECUTAR: .\uso_emergencia_reconstruir.ps1" -ForegroundColor Yellow
Write-Host ""

# Script: Reconstrucción de imágenes Docker
# ESTRATEGIA: Enfatizar el tiempo de ejecución y alcance
Write-Host "📄 USO_EMERGENCIA_CONSTRUIR.PS1" -ForegroundColor White
Write-Host "   ⚠️  ADVERTENCIA: Tiempo largo de ejecución" -ForegroundColor Red
Write-Host "   📅 CUÁNDO USAR: SOLO cuando:" -ForegroundColor Gray
Write-Host "     • Cambiaste requirements.txt o Dockerfile" -ForegroundColor Gray
Write-Host "     • Las imágenes Docker están corruptas" -ForegroundColor Gray
Write-Host "     • Actualizaste versiones de paquetes base" -ForegroundColor Gray
Write-Host "   🎯 QUÉ HACE: Reconstruye TODAS las imágenes Docker desde cero" -ForegroundColor Gray
Write-Host "   ⏰ TIEMPO: 20-40 minutos" -ForegroundColor Gray
Write-Host "   ✅ RESULTADO: Imágenes Docker nuevas (desarrollo, experiments, edge)" -ForegroundColor Gray
Write-Host "   🐳 SALIDA: 3 imágenes: tesis-desarrollo, tesis-experiments, tesis-edge" -ForegroundColor Gray
Write-Host "   💡 EJECUTAR: .\uso_emergencia_construir.ps1" -ForegroundColor Yellow
Write-Host ""

# Script: Pruebas especializadas para edge computing
# ESTRATEGIA: Enfoque específico para caso de uso especializado
Write-Host "📄 USO_ESPECIAL_EDGE.PS1" -ForegroundColor White
Write-Host "   📅 CUÁNDO USAR: SOLO para pruebas de optimización en edge devices" -ForegroundColor Gray
Write-Host "   🎯 QUÉ HACE: Inicia contenedor optimizado para dispositivos limitados" -ForegroundColor Gray
Write-Host "   ⏰ TIEMPO: 15-30 segundos" -ForegroundColor Gray
Write-Host "   🎯 RESULTADO: Entorno con ONNX, OpenVINO, TensorRT para inferencia" -ForegroundColor Gray
Write-Host "   📱 PROPÓSITO: Probar modelos optimizados para Raspberry Pi/Jetson" -ForegroundColor Gray
Write-Host "   💡 EJECUTAR: .\uso_especial_edge.ps1" -ForegroundColor Yellow
Write-Host ""

# -----------------------------------------------------------------------------
# FASE 5: FLUJOS DE TRABAJO RECOMENDADOS (Guías prácticas)
# Estrategia: Proporcionar secuencias en lugar de comandos aislados
# -----------------------------------------------------------------------------
Write-Host "🚀 FLUJOS DE TRABAJO RECOMENDADOS" -ForegroundColor Cyan
Write-Host "─" * 45 -ForegroundColor Cyan
Write-Host "🎯 Secuencias probadas para diferentes escenarios" -ForegroundColor Gray
Write-Host ""

# Flujo de trabajo diario estándar
# ESTRATEGIA: Mostrar el camino más común y eficiente
Write-Host "🔹 FLUJO DIARIO NORMAL:" -ForegroundColor White
Write-Host "   1. .\uso_diario_activar.ps1     (✅ 10s)  - Empezar" -ForegroundColor Gray
Write-Host "   2. .\uso_diario_jupyter.ps1     (✅ 30s)  - Programar" -ForegroundColor Gray
Write-Host "   3. .\uso_diario_detener.ps1     (✅ 10s)  - Terminar" -ForegroundColor Gray
Write-Host ""

# Flujo de mantenimiento semanal
# ESTRATEGIA: Rutina de mantenimiento preventivo
Write-Host "🔹 FLUJO SEMANAL MANTENIMIENTO:" -ForegroundColor White
Write-Host "   1. .\uso_semanal_verificar.ps1  (✅ 2m)   - Verificar salud" -ForegroundColor Gray
Write-Host "   2. .\uso_semanal_entrenar.ps1   (✅ 30s)  - Si hay experimentos" -ForegroundColor Gray
Write-Host ""

# Flujo para situaciones críticas
# ESTRATEGIA: Enfatizar la naturaleza excepcional y el tiempo requerido
Write-Host "🔹 FLUJO EMERGENCIA (SOLO SI ES NECESARIO):" -ForegroundColor White
Write-Host "   1. .\uso_emergencia_reconstruir.ps1 (⚠️  30m) - Reset local" -ForegroundColor Gray
Write-Host "   2. .\uso_emergencia_construir.ps1   (⚠️  40m) - Reset Docker" -ForegroundColor Gray
Write-Host ""

# -----------------------------------------------------------------------------
# FASE 6: SOLUCIÓN DE PROBLEMAS COMUNES (Alternativas rápidas)
# Estrategia: Prevenir uso incorrecto de scripts destructivos
# -----------------------------------------------------------------------------
Write-Host "🎯 ALTERNATIVAS PARA PROBLEMAS COMUNES" -ForegroundColor Cyan
Write-Host "─" * 50 -ForegroundColor Cyan
Write-Host "🔧 Soluciones específicas antes de usar scripts destructivos" -ForegroundColor Gray
Write-Host ""

# Soluciones específicas para evitar reconstrucciones innecesarias
# ESTRATEGIA: Proporcionar alternativas directas a problemas comunes
Write-Host "❌ PROBLEMA: Un paquete no se instala" -ForegroundColor White
Write-Host "   💡 SOLUCIÓN: pip install nombre_paquete==versión" -ForegroundColor Yellow
Write-Host "   ❌ EVITA: .\uso_emergencia_reconstruir.ps1" -ForegroundColor Red
Write-Host ""

Write-Host "❌ PROBLEMA: Error en un paquete específico" -ForegroundColor White
Write-Host "   💡 SOLUCIÓN: pip uninstall nombre_problema && pip install nombre_problema" -ForegroundColor Yellow
Write-Host "   ❌ EVITA: .\uso_emergencia_reconstruir.ps1" -ForegroundColor Red
Write-Host ""

Write-Host "❌ PROBLEMA: Dependencias desactualizadas" -ForegroundColor White
Write-Host "   💡 SOLUCIÓN: pip install --upgrade -r requirements/desarrollo.txt" -ForegroundColor Yellow
Write-Host "   ❌ EVITA: .\uso_emergencia_reconstruir.ps1" -ForegroundColor Red
Write-Host ""

Write-Host "❌ PROBLEMA: Un contenedor no inicia" -ForegroundColor White
Write-Host "   💡 SOLUCIÓN: docker-compose restart nombre_contenedor" -ForegroundColor Yellow
Write-Host "   ❌ EVITA: .\uso_emergencia_construir.ps1" -ForegroundColor Red
Write-Host ""

# -----------------------------------------------------------------------------
# FASE 7: RESUMEN EJECUTIVO Y PRIORIZACIÓN
# Estrategia: Refuerzo final de los conceptos clave
# -----------------------------------------------------------------------------
Write-Host "📞 RESUMEN DE PRIORIDADES" -ForegroundColor Cyan
Write-Host "─" * 35 -ForegroundColor Cyan
Write-Host "🎯 Reglas simples para uso correcto del sistema" -ForegroundColor Gray
Write-Host ""

# Priorización clara de uso de scripts
# ESTRATEGIA: Reglas mnemotécnicas simples
Write-Host "🟢 PRIMERO: Scripts DIARIOS (rápidos, seguros)" -ForegroundColor Green
Write-Host "🟡 LUEGO: Scripts SEMANALES (mantenimiento)" -ForegroundColor Yellow
Write-Host "🔴 SOLO SI ES NECESARIO: Scripts EMERGENCIA (lentos, destructivos)" -ForegroundColor Red
Write-Host ""

# Recordatorios importantes
# ESTRATEGIA: Enfatizar diferencias críticas entre categorías
Write-Host "💾 RECUERDA:" -ForegroundColor Cyan
Write-Host "- Los scripts EMERGENCIA toman 30-40 minutos ⏰" -ForegroundColor White
Write-Host "- Los scripts DIARIOS toman segundos ⚡" -ForegroundColor White
Write-Host "- Verifica SEMANALMENTE para prevenir problemas 🔍" -ForegroundColor White
Write-Host "- Usa las alternativas antes de reconstruir todo 🛠️" -ForegroundColor White
Write-Host ""

# -----------------------------------------------------------------------------
# FASE 8: INTERACCIÓN FINAL Y CIERRE
# Estrategia: Finalizar con llamado a la acción claro
# -----------------------------------------------------------------------------
Write-Host "🎓 ¡Tu sistema está diseñado para ser eficiente y seguro!" -ForegroundColor Green
Write-Host ""

# ESTRATEGIA: Pausa final para asegurar que el usuario leyó la información
$null = Read-Host "Presiona Enter para cerrar esta ayuda"
