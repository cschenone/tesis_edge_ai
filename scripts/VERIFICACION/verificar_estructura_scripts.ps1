# =============================================================================
# ESTRATEGIA: Script de Verificación de Estructura Híbrida de Scripts
# PROPÓSITO: Validar organización dual (carpetas por categoría + numeración raíz)
# COHERENCIA: Estructura física → Numeración lógica → Integridad del sistema
# INNOVACIÓN: Validación de sistema híbrido con scripts de setup numerados
# =============================================================================

# -----------------------------------------------------------------------------
# FASE 1: ENCABEZADO Y CONTEXTO DE LA ESTRUCTURA HÍBRIDA
# Estrategia: Explicar la organización dual del sistema
# -----------------------------------------------------------------------------
Write-Host "🔍 VERIFICADOR DE ESTRUCTURA HÍBRIDA DE SCRIPTS TESIS EDGE AI" -ForegroundColor Cyan
Write-Host "=" * 75 -ForegroundColor Cyan
Write-Host "🏗️  Arquitectura: Carpetas por categoría de uso + Scripts numerados en raíz" -ForegroundColor Gray
Write-Host "📁 Organización: USO_[CATEGORIA]/ para operación + [NUM]_[NOMBRE].ps1 para setup" -ForegroundColor Gray
Write-Host "🎯 Objetivo: Validar coherencia entre estructura física y flujos lógicos" -ForegroundColor Gray
Write-Host "=" * 75 -ForegroundColor Cyan
Write-Host ""

# -----------------------------------------------------------------------------
# FASE 2: DEFINICIÓN DE LA ESTRUCTURA ESPERADA
# Estrategia: Definir claramente ambas dimensiones de organización
# -----------------------------------------------------------------------------
Write-Host "[1/6] 📋 DEFINICIÓN DE LA ESTRUCTURA HÍBRIDA ESPERADA..." -ForegroundColor Gray

$estructuraCategorias = @(
    @{
        Carpeta = "USO_DIARIO"
        Nombre = "🟢 DIARIO"
        Descripcion = "Operaciones cotidianas - Rápidas y seguras"
        Color = "Green"
        ScriptsEsperados = @("uso_activar.ps1", "uso_detener.ps1", "uso_jupyter.ps1")
        Criticidad = "Alta"
    },
    @{
        Carpeta = "USO_SEMANAL" 
        Nombre = "🟡 SEMANAL"
        Descripcion = "Mantenimiento y verificación periódica"
        Color = "Yellow"
        ScriptsEsperados = @("uso_verificar.ps1", "uso_entrenar.ps1")
        Criticidad = "Media-Alta"
    },
    @{
        Carpeta = "USO_EMERGENCIA"
        Nombre = "🔴 EMERGENCIA"
        Descripcion = "SOLO para problemas críticos - Destructivos"
        Color = "Red"
        ScriptsEsperados = @("uso_reconstruir.ps1", "uso_construir.ps1")
        Criticidad = "Baja (uso excepcional)"
    },
    @{
        Carpeta = "USO_ESPECIAL"
        Nombre = "🔵 ESPECIAL"
        Descripcion = "Casos de uso específicos - Edge computing"
        Color = "Blue"
        ScriptsEsperados = @("uso_edge.ps1")
        Criticidad = "Media"
    },
    @{
        Carpeta = "VERIFICACION"
        Nombre = "📚 VERIFICACIÓN"
        Descripcion = "Diagnóstico, ayuda y documentación"
        Color = "Cyan"
        ScriptsEsperados = @("ayuda_scripts.ps1", "verificar_compatibilidad.ps1", "verificar_estructura_requerimientos.ps1", "verificar_estructura_scripts.ps1", "verificar_todo.ps1")
        Criticidad = "Media"
    }
)

$scriptsNumeradosEsperados = @(
    @{Numero = "00"; Nombre = "orquestador_principal.ps1"; Proposito = "Punto de entrada principal del sistema"},
    @{Numero = "01"; Nombre = "crear_estructura.ps1"; Proposito = "Configuración inicial del proyecto"},
    @{Numero = "02"; Nombre = "crear_dependencias.ps1"; Proposito = "Gestión de dependencias y entornos"},
    @{Numero = "03a"; Nombre = "configurar_pytorch.ps1"; Proposito = "Configuración específica de PyTorch"},
    @{Numero = "03b"; Nombre = "configurar_tensorflow.ps1"; Proposito = "Configuración específica de TensorFlow"},
    @{Numero = "04"; Nombre = "guia_uso.ps1"; Proposito = "Documentación y guías de uso"},
    @{Numero = "05"; Nombre = "sincronizar_requerimientos.ps1"; Proposito = "Sincronización de dependencias"}
)

Write-Host "   Estructura híbrida detectada:" -ForegroundColor White
Write-Host "   📁 CARPETAS POR CATEGORÍA DE USO:" -ForegroundColor Cyan
foreach ($categoria in $estructuraCategorias) {
    Write-Host "   • $($categoria.Carpeta)/ - $($categoria.Descripcion)" -ForegroundColor Gray
}
Write-Host ""
Write-Host "   🔢 SCRIPTS NUMERADOS EN RAÍZ (Setup):" -ForegroundColor Cyan
foreach ($script in $scriptsNumeradosEsperados) {
    Write-Host "   • $($script.Numero)_$($script.Nombre) - $($script.Proposito)" -ForegroundColor DarkGray
}
Write-Host ""

# -----------------------------------------------------------------------------
# FASE 3: VERIFICACIÓN DE ESTRUCTURA POR CARPETAS
# Estrategia: Validar integridad de la organización por categorías
# -----------------------------------------------------------------------------
Write-Host "[2/6] 📁 VERIFICANDo ESTRUCTURA POR CARPETAS..." -ForegroundColor Gray

$totalScriptsCategorias = 0
$carpetasEncontradas = 0
$carpetasCompletas = 0
$scriptsCriticosFaltantes = @()

foreach ($categoria in $estructuraCategorias) {
    Write-Host ""
    Write-Host "   $($categoria.Nombre) - $($categoria.Carpeta)/" -ForegroundColor $categoria.Color
    Write-Host "   $('─' * 50)" -ForegroundColor $categoria.Color
    
    if (Test-Path $categoria.Carpeta) {
        $carpetasEncontradas++
        Write-Host "     ✅ Carpeta encontrada" -ForegroundColor Green
        
        $scriptsEnCarpeta = Get-ChildItem $categoria.Carpeta -Filter "*.ps1" -ErrorAction SilentlyContinue | Sort-Object Name
        $scriptsEncontrados = @($scriptsEnCarpeta | ForEach-Object { $_.Name })
        
        if ($scriptsEnCarpeta) {
            # Mostrar scripts encontrados
            foreach ($script in $scriptsEnCarpeta) {
                $totalScriptsCategorias++
                $infoScript = Get-Item $script.FullName -ErrorAction SilentlyContinue
                $tamañoKB = if ($infoScript) { [math]::Round($infoScript.Length / 1KB, 2) } else { "N/A" }
                
                Write-Host "     ✅ $($script.Name) ($tamañoKB KB)" -ForegroundColor White
            }
            
            # Verificar scripts esperados vs encontrados
            $scriptsFaltantes = @()
            foreach ($scriptEsperado in $categoria.ScriptsEsperados) {
                if ($scriptsEncontrados -notcontains $scriptEsperado) {
                    $scriptsFaltantes += $scriptEsperado
                    $scriptsCriticosFaltantes += "$($categoria.Carpeta)/$scriptEsperado"
                }
            }
            
            if ($scriptsFaltantes.Count -eq 0) {
                Write-Host "     🎯 CARPETA COMPLETA: $($scriptsEnCarpeta.Count)/$($categoria.ScriptsEsperados.Count) scripts" -ForegroundColor Green
                $carpetasCompletas++
            } else {
                Write-Host "     ⚠️  CARPETA INCOMPLETA: $($scriptsEnCarpeta.Count)/$($categoria.ScriptsEsperados.Count) scripts" -ForegroundColor Yellow
                Write-Host "     ❌ Faltan: $($scriptsFaltantes -join ', ')" -ForegroundColor Red
            }
            
            Write-Host "     📊 Total en carpeta: $($scriptsEnCarpeta.Count) scripts" -ForegroundColor Cyan
            
        } else {
            Write-Host "     ⚠️  Carpeta vacía o sin scripts PowerShell" -ForegroundColor Yellow
        }
        
    } else {
        Write-Host "     ❌ Carpeta NO ENCONTRADA" -ForegroundColor Red
        Write-Host "     💡 Scripts esperados: $($categoria.ScriptsEsperados -join ', ')" -ForegroundColor DarkGray
    }
}

# -----------------------------------------------------------------------------
# FASE 4: VERIFICACIÓN DE SCRIPTS NUMERADOS EN RAÍZ
# Estrategia: Validar secuencia de setup y configuración
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[3/6] 🔢 VERIFICANDO SCRIPTS NUMERADOS DE SETUP..." -ForegroundColor Gray

$scriptsNumeradosEncontrados = 0
$secuenciaNumericaOK = $true
$numerosEncontrados = @()

Write-Host "   Verificando secuencia de configuración en raíz..." -ForegroundColor White

foreach ($scriptEsperado in $scriptsNumeradosEsperados) {
    $nombreCompleto = "$($scriptEsperado.Numero)_$($scriptEsperado.Nombre)"
    
    if (Test-Path $nombreCompleto) {
        $scriptsNumeradosEncontrados++
        $numerosEncontrados += $scriptEsperado.Numero
        
        $infoScript = Get-Item $nombreCompleto -ErrorAction SilentlyContinue
        $tamañoKB = if ($infoScript) { [math]::Round($infoScript.Length / 1KB, 2) } else { "N/A" }
        
        Write-Host "     ✅ $nombreCompleto" -ForegroundColor Green
        Write-Host "       • $($scriptEsperado.Proposito) ($tamañoKB KB)" -ForegroundColor DarkGray
    } else {
        Write-Host "     ❌ $nombreCompleto - NO ENCONTRADO" -ForegroundColor Red
        Write-Host "       • $($scriptEsperado.Proposito)" -ForegroundColor DarkGray
    }
}

# Verificar secuencia numérica
Write-Host ""
Write-Host "   🔍 ANALIZANDO SECUENCIA NUMÉRICA..." -ForegroundColor White

if ($numerosEncontrados.Count -gt 0) {
    $numerosOrdenados = $numerosEncontrados | Sort-Object
    $secuenciaEsperada = @("00", "01", "02", "03a", "03b", "04", "05")
    
    $huecosSecuencia = @()
    foreach ($numero in $secuenciaEsperada) {
        if ($numerosOrdenados -notcontains $numero) {
            $huecosSecuencia += $numero
        }
    }
    
    if ($huecosSecuencia.Count -eq 0) {
        Write-Host "     ✅ Secuencia numérica COMPLETA y ORDENADA" -ForegroundColor Green
    } else {
        Write-Host "     ⚠️  Huecos en secuencia: $($huecosSecuencia -join ', ')" -ForegroundColor Yellow
        $secuenciaNumericaOK = $false
    }
}

# -----------------------------------------------------------------------------
# FASE 5: ANÁLISIS DE METADATOS Y ESTADÍSTICAS
# Estrategia: Proporcionar métricas de salud del sistema híbrido
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[4/6] 📈 ANALIZANDO ESTADÍSTICAS DEL SISTEMA HÍBRIDO..." -ForegroundColor Gray

$totalScriptsSistema = $totalScriptsCategorias + $scriptsNumeradosEncontrados
$porcentajeCarpetasEncontradas = [math]::Round(($carpetasEncontradas / $estructuraCategorias.Count) * 100, 1)
$porcentajeCarpetasCompletas = [math]::Round(($carpetasCompletas / $estructuraCategorias.Count) * 100, 1)
$porcentajeScriptsNumerados = [math]::Round(($scriptsNumeradosEncontrados / $scriptsNumeradosEsperados.Count) * 100, 1)

Write-Host "   📊 MÉTRICAS DEL SISTEMA HÍBRIDO:" -ForegroundColor White
Write-Host "     • Scripts totales: $totalScriptsSistema" -ForegroundColor $(
    if ($totalScriptsSistema -ge 15) { "Green" } elseif ($totalScriptsSistema -ge 10) { "Yellow" } else { "Red" }
)
Write-Host "     • Carpetas encontradas: $carpetasEncontradas/$($estructuraCategorias.Count) ($porcentajeCarpetasEncontradas%)" -ForegroundColor $(
    if ($porcentajeCarpetasEncontradas -eq 100) { "Green" } elseif ($porcentajeCarpetasEncontradas -ge 80) { "Yellow" } else { "Red" }
)
Write-Host "     • Carpetas completas: $carpetasCompletas/$($estructuraCategorias.Count) ($porcentajeCarpetasCompletas%)" -ForegroundColor $(
    if ($porcentajeCarpetasCompletas -eq 100) { "Green" } elseif ($porcentajeCarpetasCompletas -ge 80) { "Yellow" } else { "Red" }
)
Write-Host "     • Scripts numerados: $scriptsNumeradosEncontrados/$($scriptsNumeradosEsperados.Count) ($porcentajeScriptsNumerados%)" -ForegroundColor $(
    if ($porcentajeScriptsNumerados -eq 100) { "Green" } elseif ($porcentajeScriptsNumerados -ge 80) { "Yellow" } else { "Red" }
)

if ($scriptsCriticosFaltantes.Count -gt 0) {
    Write-Host ""
    Write-Host "   ⚠️  SCRIPTS CRÍTICOS FALTANTES:" -ForegroundColor Yellow
    foreach ($scriptFaltante in $scriptsCriticosFaltantes) {
        Write-Host "     • $scriptFaltante" -ForegroundColor White
    }
}

# -----------------------------------------------------------------------------
# FASE 6: GUÍAS DE USO BASADAS EN ESTRUCTURA REAL
# Estrategia: Proporcionar rutas correctas basadas en la estructura verificada
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[5/6] 🚀 GENERANDO GUÍAS DE USO CON RUTAS CORRECTAS..." -ForegroundColor Gray

Write-Host "   🎯 FLUJOS DE TRABAJO CON RUTAS VERIFICADAS:" -ForegroundColor Cyan

# Flujo diario
$activarDisponible = Test-Path "USO_DIARIO\uso_activar.ps1"
$jupyterDisponible = Test-Path "USO_DIARIO\uso_jupyter.ps1"
$detenerDisponible = Test-Path "USO_DIARIO\uso_detener.ps1"

if ($activarDisponible -or $jupyterDisponible -or $detenerDisponible) {
    Write-Host ""
    Write-Host "   🔹 FLUJO DIARIO:" -ForegroundColor White
    if ($activarDisponible) {
        Write-Host "     • .\USO_DIARIO\uso_activar.ps1" -ForegroundColor Gray
    }
    if ($jupyterDisponible) {
        Write-Host "     • .\USO_DIARIO\uso_jupyter.ps1" -ForegroundColor Gray
    }
    if ($detenerDisponible) {
        Write-Host "     • .\USO_DIARIO\uso_detener.ps1" -ForegroundColor Gray
    }
}

# Flujo semanal y especial
$verificarDisponible = Test-Path "USO_SEMANAL\uso_verificar.ps1"
$entrenarDisponible = Test-Path "USO_SEMANAL\uso_entrenar.ps1"
$edgeDisponible = Test-Path "USO_ESPECIAL\uso_edge.ps1"

if ($verificarDisponible -or $entrenarDisponible -or $edgeDisponible) {
    Write-Host ""
    Write-Host "   🔹 FLUJOS ESPECÍFICOS:" -ForegroundColor White
    if ($verificarDisponible) {
        Write-Host "     • Verificación: .\USO_SEMANAL\uso_verificar.ps1" -ForegroundColor Gray
    }
    if ($entrenarDisponible) {
        Write-Host "     • Experimentos: .\USO_SEMANAL\uso_entrenar.ps1" -ForegroundColor Gray
    }
    if ($edgeDisponible) {
        Write-Host "     • Edge Computing: .\USO_ESPECIAL\uso_edge.ps1" -ForegroundColor Gray
    }
}

# Scripts de emergencia
$reconstruirDisponible = Test-Path "USO_EMERGENCIA\uso_reconstruir.ps1"
$construirDisponible = Test-Path "USO_EMERGENCIA\uso_construir.ps1"

if ($reconstruirDisponible -or $construirDisponible) {
    Write-Host ""
    Write-Host "   🔹 USO DE EMERGENCIA:" -ForegroundColor White
    Write-Host "     • 🔴 SOLO EN PROBLEMAS GRAVES:" -ForegroundColor Red
    if ($reconstruirDisponible) {
        Write-Host "       - .\USO_EMERGENCIA\uso_reconstruir.ps1" -ForegroundColor DarkRed
    }
    if ($construirDisponible) {
        Write-Host "       - .\USO_EMERGENCIA\uso_construir.ps1" -ForegroundColor DarkRed
    }
}

# Scripts de ayuda y verificación
$ayudaDisponible = Test-Path "VERIFICACION\ayuda_scripts.ps1"
$verificarTodoDisponible = Test-Path "VERIFICACION\verificar_todo.ps1"

if ($ayudaDisponible -or $verificarTodoDisponible) {
    Write-Host ""
    Write-Host "   🔹 AYUDA Y DIAGNÓSTICO:" -ForegroundColor White
    if ($ayudaDisponible) {
        Write-Host "     • Documentación: .\VERIFICACION\ayuda_scripts.ps1" -ForegroundColor Gray
    }
    if ($verificarTodoDisponible) {
        Write-Host "     • Verificación completa: .\VERIFICACION\verificar_todo.ps1" -ForegroundColor Gray
    }
}

# Scripts de setup
$orquestadorDisponible = Test-Path "00_orquestador_principal.ps1"
if ($orquestadorDisponible) {
    Write-Host ""
    Write-Host "   🔹 CONFIGURACIÓN Y SETUP:" -ForegroundColor White
    Write-Host "     • Sistema completo: .\00_orquestador_principal.ps1" -ForegroundColor Gray
}

# -----------------------------------------------------------------------------
# FASE 7: REPORTE FINAL Y RECOMENDACIONES
# Estrategia: Resumen ejecutivo con evaluación del sistema híbrido
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[6/6] 📄 GENERANDO REPORTE FINAL..." -ForegroundColor Gray

Write-Host ""
Write-Host "=" * 75 -ForegroundColor Cyan
Write-Host "📊 INFORME FINAL - SISTEMA HÍBRIDO DE SCRIPTS TESIS EDGE AI" -ForegroundColor Cyan
Write-Host "=" * 75 -ForegroundColor Cyan

# Calcular puntuación de salud del sistema híbrido
$puntuacionSalud = 0
$maxPuntuacion = 5

if ($porcentajeCarpetasEncontradas -eq 100) { $puntuacionSalud++ }  # Todas las carpetas presentes
if ($porcentajeCarpetasCompletas -ge 80) { $puntuacionSalud++ }     # Mayoría de carpetas completas
if ($porcentajeScriptsNumerados -ge 80) { $puntuacionSalud++ }      # Scripts de setup presentes
if ($secuenciaNumericaOK) { $puntuacionSalud++ }                    # Secuencia lógica
if ($scriptsCriticosFaltantes.Count -eq 0) { $puntuacionSalud++ }   # Sin faltantes críticos

Write-Host ""
Write-Host "🏥 SALUD DEL SISTEMA HÍBRIDO: $puntuacionSalud/$maxPuntuacion" -ForegroundColor $(
    if ($puntuacionSalud -ge 4) { "Green" } elseif ($puntuacionSalud -ge 3) { "Yellow" } else { "Red" }
)

Write-Host ""
Write-Host "🎯 EVALUACIÓN DE LA ESTRUCTURA:" -ForegroundColor Cyan
if ($puntuacionSalud -eq 5) {
    Write-Host "   ✅ ESTRUCTURA ÓPTIMA - Sistema híbrido completo y bien organizado" -ForegroundColor Green
} elseif ($puntuacionSalud -ge 3) {
    Write-Host "   ⚠️  ESTRUCTURA FUNCIONAL - Organización adecuada con áreas de mejora" -ForegroundColor Yellow
} else {
    Write-Host "   ❌ ESTRUCTURA INCOMPLETA - Se requiere reorganización" -ForegroundColor Red
}

Write-Host ""
Write-Host "💡 RECOMENDACIONES ESPECÍFICAS:" -ForegroundColor Cyan

if ($scriptsCriticosFaltantes.Count -gt 0) {
    Write-Host "   • Completar scripts faltantes en carpetas de categoría" -ForegroundColor White
}

if (-not $secuenciaNumericaOK) {
    Write-Host "   • Revisar secuencia numérica de scripts de setup" -ForegroundColor White
}

if ($porcentajeCarpetasCompletas -lt 100) {
    Write-Host "   • Completar conjuntos de scripts en carpetas incompletas" -ForegroundColor White
}

if ($puntuacionSalud -ge 4) {
    Write-Host "   • Mantener la documentación actualizada con la estructura real" -ForegroundColor White
    Write-Host "   • Considerar scripts adicionales para nuevos casos de uso" -ForegroundColor White
}

Write-Host ""
Write-Host "🚀 PRÓXIMOS PASOS INMEDIATOS:" -ForegroundColor Cyan
Write-Host "   • Consultar documentación: .\VERIFICACION\ayuda_scripts.ps1" -ForegroundColor White
Write-Host "   • Ejecutar verificación completa: .\VERIFICACION\verificar_todo.ps1" -ForegroundColor White
Write-Host "   • Comenzar trabajo: .\USO_DIARIO\uso_activar.ps1" -ForegroundColor White

Write-Host ""
Write-Host "=" * 75 -ForegroundColor Cyan
Write-Host "✅ VERIFICACIÓN DE ESTRUCTURA HÍBRIDA COMPLETADA" -ForegroundColor Green
Write-Host "   $totalScriptsSistema scripts organizados en $carpetasEncontradas carpetas + raíz" -ForegroundColor Gray
Write-Host "=" * 75 -ForegroundColor Cyan

$null = Read-Host "`nPresiona Enter para finalizar este reporte"
