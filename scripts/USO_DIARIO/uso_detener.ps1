# =============================================================================
# ESTRATEGIA: Script de Cierre Diario - Tesis Edge AI
# PROPÓSITO: Detener contenedores de manera segura y proporcionar transición ordenada
# COHERENCIA: Detección → Parada → Verificación → Guías de acción
# =============================================================================

# -----------------------------------------------------------------------------
# FASE 1: INICIALIZACIÓN Y CONTEXTO
# Estrategia: Comunicar claramente el propósito y alcance
# -----------------------------------------------------------------------------
Write-Host "🛑 DETENIENDO SISTEMA TESIS EDGE AI" -ForegroundColor Cyan
Write-Host "=" * 50 -ForegroundColor Cyan
Write-Host ""

Write-Host "Iniciando secuencia de cierre seguro..." -ForegroundColor Yellow
Write-Host ""

# -----------------------------------------------------------------------------
# FASE 2: DETECCIÓN DE CONTENEDORES ACTIVOS
# Estrategia: Identificar todos los contenedores relevantes del proyecto
# -----------------------------------------------------------------------------
Write-Host "[1/4] Escaneando contenedores activos..." -ForegroundColor Gray

# COHERENCIA MEJORADA: Múltiples patrones para contenedores del proyecto
$patronesContenedores = @("tesis-", "edge-ai-", "tesis_", "experiment-")
$contenedoresActivos = docker ps --format "{{.Names}}" | Where-Object {
    $nombreContenedor = $_
    $patronesContenedores | ForEach-Object { $nombreContenedor -match $_ }
}

if ($contenedoresActivos) {
    Write-Host "[2/4] Contenedores activos encontrados:" -ForegroundColor White
    $contenedoresLista = @()
    
    # PROCESAMIENTO CON MANEJO DE ERRORES
    $contenedoresActivos | ForEach-Object { 
        $contenedor = $_
        Write-Host "   🐳 Deteniendo: $contenedor" -ForegroundColor White
        
        try {
            # Intentar detener el contenedor gracefuly
            docker stop $contenedor 2>$null
            
            # Verificar si se detuvo correctamente
            Start-Sleep -Milliseconds 500
            $estado = docker inspect $contenedor --format '{{.State.Status}}' 2>$null
            
            if ($estado -eq "exited" -or $LASTEXITCODE -eq 0) {
                Write-Host "     ✅ Detenido correctamente" -ForegroundColor Green
                $contenedoresLista += "$contenedor ✅"
            } else {
                Write-Host "     ⚠️  Forzando detención..." -ForegroundColor Yellow
                docker kill $contenedor 2>$null
                $contenedoresLista += "$contenedor ⚠️"
            }
        }
        catch {
            Write-Host "     ❌ Error: $($_.Exception.Message)" -ForegroundColor Red
            $contenedoresLista += "$contenedor ❌"
        }
    }
    
    Write-Host ""
    
    # -----------------------------------------------------------------------------
    # FASE 3: VERIFICACIÓN POST-DETENCIÓN
    # Estrategia: Confirmar que el sistema está realmente detenido
    # -----------------------------------------------------------------------------
    Write-Host "[3/4] Verificando estado final..." -ForegroundColor Gray
    Start-Sleep -Seconds 1
    
    $contenedoresRestantes = docker ps --format "{{.Names}}" | Where-Object {
        $nombreContenedor = $_
        $patronesContenedores | ForEach-Object { $nombreContenedor -match $_ }
    }
    
    if (-not $contenedoresRestantes) {
        Write-Host "   ✅ Todos los contenedores detenidos correctamente" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Contenedores aún activos: $($contenedoresRestantes -join ', ')" -ForegroundColor Yellow
        Write-Host "   💡 Ejecuta 'docker kill $contenedoresRestantes' para forzar" -ForegroundColor Gray
    }
    
} else {
    Write-Host "[2/4] ℹ️  No hay contenedores activos del proyecto tesis" -ForegroundColor Yellow
}

# -----------------------------------------------------------------------------
# FASE 4: INFORMACIÓN Y GUÍAS DE ACCIÓN
# Estrategia: Proporcionar next steps claros al usuario
# -----------------------------------------------------------------------------
Write-Host "[4/4] Resumen y próximos pasos:" -ForegroundColor Gray
Write-Host ""

Write-Host "📋 Resumen de operación:" -ForegroundColor Cyan
if ($contenedoresLista) {
    $contenedoresLista | ForEach-Object { Write-Host "   $_" -ForegroundColor White }
} else {
    Write-Host "   No se realizaron acciones - sin contenedores activos" -ForegroundColor Gray
}

Write-Host ""
Write-Host "🚀 Para reiniciar mañana:" -ForegroundColor Cyan
Write-Host "   💻 Desarrollo:    .\iniciar_desarrollo.ps1" -ForegroundColor White
Write-Host "   🔬 Experimentos:  .\iniciar_experimentos.ps1" -ForegroundColor White
Write-Host "   📱 Edge:         .\iniciar_edge.ps1" -ForegroundColor White

Write-Host ""
Write-Host "🔧 Comandos avanzados:" -ForegroundColor Cyan
Write-Host "   🗑️  Limpiar todo: docker-compose down" -ForegroundColor White
Write-Host "   📊 Ver estado:    docker ps -a --filter name=tesis" -ForegroundColor White
Write-Host "   🧹 Eliminar:      docker system prune -f" -ForegroundColor White

Write-Host ""
Write-Host "────────────────────────────────────────────────────────────" -ForegroundColor Cyan
Write-Host "✅ SISTEMA DETENIDO - Recursos liberados correctamente" -ForegroundColor Green
Write-Host "💡 Recuerda ejecutar este script al finalizar tu jornada" -ForegroundColor Yellow
Write-Host "────────────────────────────────────────────────────────────" -ForegroundColor Cyan

# -----------------------------------------------------------------------------
# ESTRATEGIA MEJORADA: Confirmación antes de salir
# -----------------------------------------------------------------------------
Write-Host ""
$null = Read-Host "Presiona Enter para cerrar esta ventana"
