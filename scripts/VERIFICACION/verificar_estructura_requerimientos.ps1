# =============================================================================
# ESTRATEGIA: Script de Verificación de Sistema de Requerimientos por Capas
# PROPÓSITO: Validar estructura modular 4×3 (capas × frameworks) de dependencias
# Capa (base/desarrollo/edge/experimentos) × Framework (comun/pytorch/tensorflow)
# COHERENCIA: Existencia → Consistencia → Integridad → Funcionalidad
# PATRÓN: 4 capas × 3 frameworks = 12 archivos de requerimientos esperados
# =============================================================================

# -----------------------------------------------------------------------------
# FASE 1: ENCABEZADO Y EXPLICACIÓN DEL SISTEMA MODULAR
# Estrategia: Educar sobre la arquitectura de dependencias por capas
# -----------------------------------------------------------------------------
Write-Host "🔍 VERIFICADOR DE SISTEMA DE REQUERIMIENTOS POR CAPAS" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host "🏗️  Arquitectura: 4 Capas × 3 Frameworks = 12 archivos modulares" -ForegroundColor Gray
Write-Host "📊 Patrón: Capa (base/desarrollo/edge/experimentos) × Tipo (comun/pytorch/tensorflow)" -ForegroundColor Gray
Write-Host "🎯 Objetivo: Validar integridad del sistema de dependencias modular" -ForegroundColor Gray
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host ""

# -----------------------------------------------------------------------------
# FASE 2: DEFINICIÓN DE LA ESTRUCTURA ESPERADA 4×3
# Estrategia: Definir claramente la matriz de archivos esperados
# -----------------------------------------------------------------------------
Write-Host "[1/5] 📋 DEFINICIÓN DE LA MATRIZ 4×3 ESPERADA..." -ForegroundColor Gray

# Definir la estructura modular completa basada en el patrón observado
$estructuraEsperada = @{
    Capas = @(
        @{
            Nombre = "base"
            Proposito = "Dependencias fundamentales y compartidas"
            Criticidad = "Alta"
            ArchivosEsperados = 3
        },
        @{
            Nombre = "desarrollo" 
            Proposito = "Entorno completo de desarrollo e IDE"
            Criticidad = "Alta"
            ArchivosEsperados = 3
        },
        @{
            Nombre = "edge"
            Proposito = "Optimización para dispositivos Edge computing"
            Criticidad = "Media"
            ArchivosEsperados = 3
        },
        @{
            Nombre = "experimentos"
            Proposito = "Experimentación ML y recursos intensivos"
            Criticidad = "Media"
            ArchivosEsperados = 3
        }
    )
    Frameworks = @(
        @{Nombre = "comun"; Proposito = "Dependencias comunes al framework"},
        @{Nombre = "pytorch"; Proposito = "Específicas de PyTorch (principal)"},
        @{Nombre = "tensorflow"; Proposito = "Específicas de TensorFlow (comparativo)"}
    )
}

Write-Host "   Estructura modular detectada:" -ForegroundColor White
foreach ($capa in $estructuraEsperada.Capas) {
    Write-Host "   • $($capa.Nombre)/ - $($capa.Proposito)" -ForegroundColor Gray
    foreach ($framework in $estructuraEsperada.Frameworks) {
        Write-Host "     📄 requerimientos_$($capa.Nombre)_$($framework.Nombre).txt" -ForegroundColor DarkGray
    }
}
Write-Host ""

# -----------------------------------------------------------------------------
# FASE 3: VERIFICACIÓN DE INTEGRIDAD DE LA MATRIZ 4×3
# Estrategia: Validar que existan los 12 archivos esperados
# -----------------------------------------------------------------------------
Write-Host "[2/5] 🔍 VERIFICANDO INTEGRIDAD DE LA MATRIZ 4×3..." -ForegroundColor Gray

$rutaBase = "requerimientos"
$archivosTotalesEsperados = 0
$archivosEncontrados = 0
$capasCompletas = 0
$capasTotales = $estructuraEsperada.Capas.Count

Write-Host "   Verificando existencia de archivos..." -ForegroundColor White

foreach ($capa in $estructuraEsperada.Capas) {
    $archivosTotalesEsperados += $capa.ArchivosEsperados
    $archivosCapaEncontrados = 0
    $rutaCapa = "$rutaBase\$($capa.Nombre)"
    
    Write-Host ""
    Write-Host "   📁 CAPA: $($capa.Nombre.ToUpper()) - $($capa.Proposito)" -ForegroundColor Cyan
    
    foreach ($framework in $estructuraEsperada.Frameworks) {
        $nombreArchivo = "requerimientos_$($capa.Nombre)_$($framework.Nombre).txt"
        $rutaCompleta = "$rutaCapa\$nombreArchivo"
        
        if (Test-Path $rutaCompleta) {
            $archivosEncontrados++
            $archivosCapaEncontrados++
            
            # Obtener información adicional del archivo
            $infoArchivo = Get-Item $rutaCompleta -ErrorAction SilentlyContinue
            $tamañoKB = if ($infoArchivo) { [math]::Round($infoArchivo.Length / 1KB, 2) } else { 0 }
            
            Write-Host "     ✅ $nombreArchivo ($($framework.Proposito)) - $tamañoKB KB" -ForegroundColor Green
        } else {
            Write-Host "     ❌ $nombreArchivo - FALTANTE" -ForegroundColor Red
            Write-Host "       • Propósito: $($framework.Proposito)" -ForegroundColor DarkGray
        }
    }
    
    # Verificar si la capa está completa
    if ($archivosCapaEncontrados -eq $capa.ArchivosEsperados) {
        Write-Host "     🎯 Capa COMPLETA: $archivosCapaEncontrados/$($capa.ArchivosEsperados) archivos" -ForegroundColor Green
        $capasCompletas++
    } else {
        Write-Host "     ⚠️  Capa INCOMPLETA: $archivosCapaEncontrados/$($capa.ArchivosEsperados) archivos" -ForegroundColor Yellow
    }
}

# -----------------------------------------------------------------------------
# FASE 4: ANÁLISIS DE CONSISTENCIA Y PATRONES
# Estrategia: Verificar coherencia en nombres y estructura
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[3/5] 🔎 ANALIZANDO CONSISTENCIA DE NOMENCLATURA..." -ForegroundColor Gray

# Verificar que todos los archivos sigan el patrón de nomenclatura
$archivosConPatronCorrecto = 0
$archivosConProblemasNomenclatura = @()

Get-ChildItem $rutaBase -Recurse -File | ForEach-Object {
    $nombre = $_.Name
    $patronEsperado = "requerimientos_([a-z]+)_([a-z]+)\.txt"
    
    if ($nombre -match $patronEsperado) {
        $capaDetectada = $matches[1]
        $frameworkDetectado = $matches[2]
        
        # Verificar que la capa y framework detectados sean válidos
        $capaValida = $estructuraEsperada.Capas.Nombre -contains $capaDetectada
        $frameworkValido = $estructuraEsperada.Frameworks.Nombre -contains $frameworkDetectado
        
        if ($capaValida -and $frameworkValido) {
            $archivosConPatronCorrecto++
        } else {
            $archivosConProblemasNomenclatura += @{
                Archivo = $_.FullName
                Problema = if (-not $capaValida) { "Capa '$capaDetectada' no reconocida" } else { "Framework '$frameworkDetectado' no reconocido" }
            }
        }
    } else {
        $archivosConProblemasNomenclatura += @{
            Archivo = $_.FullName
            Problema = "No sigue el patrón 'requerimientos_[capa]_[framework].txt'"
        }
    }
}

Write-Host "   Archivos con nomenclatura correcta: $archivosConPatronCorrecto/$archivosEncontrados" -ForegroundColor $(
    if ($archivosConPatronCorrecto -eq $archivosEncontrados) { "Green" } else { "Yellow" }
)

if ($archivosConProblemasNomenclatura.Count -gt 0) {
    Write-Host "   ⚠️  Problemas de nomenclatura detectados:" -ForegroundColor Yellow
    foreach ($problema in $archivosConProblemasNomenclatura) {
        Write-Host "     • $($problema.Archivo)" -ForegroundColor White
        Write-Host "       - $($problema.Problema)" -ForegroundColor DarkGray
    }
}

# -----------------------------------------------------------------------------
# FASE 5: VERIFICACIÓN DE CONTENIDO Y ESTRUCTURA INTERNA
# Estrategia: Análisis básico del contenido de los archivos
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[4/5] 📊 ANALIZANDO CONTENIDO DE ARCHIVOS..." -ForegroundColor Gray

$archivosConContenido = 0
$archivosVacios = @()
$archivosConErrores = @()

foreach ($capa in $estructuraEsperada.Capas) {
    foreach ($framework in $estructuraEsperada.Frameworks) {
        $rutaArchivo = "$rutaBase\$($capa.Nombre)\requerimientos_$($capa.Nombre)_$($framework.Nombre).txt"
        
        if (Test-Path $rutaArchivo) {
            try {
                $contenido = Get-Content $rutaArchivo -ErrorAction Stop
                $lineasValidas = @($contenido | Where-Object { 
                    $_.Trim() -and -not $_.Trim().StartsWith("#") -and -not $_.Trim().StartsWith("-")
                })
                
                if ($lineasValidas.Count -gt 0) {
                    $archivosConContenido++
                    Write-Host "     ✅ $($capa.Nombre)_$($framework.Nombre): $($lineasValidas.Count) dependencias" -ForegroundColor Green
                } else {
                    $archivosVacios += "$($capa.Nombre)_$($framework.Nombre)"
                    Write-Host "     ⚠️  $($capa.Nombre)_$($framework.Nombre): VACÍO o solo comentarios" -ForegroundColor Yellow
                }
            } catch {
                $archivosConErrores += "$($capa.Nombre)_$($framework.Nombre)"
                Write-Host "     ❌ $($capa.Nombre)_$($framework.Nombre): Error de lectura" -ForegroundColor Red
            }
        }
    }
}

# -----------------------------------------------------------------------------
# FASE 6: REPORTE FINAL Y MÉTRICAS DE CALIDAD
# Estrategia: Resumen ejecutivo con puntuación de integridad
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[5/5] 📈 GENERANDO REPORTE FINAL..." -ForegroundColor Gray

Write-Host ""
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host "📊 INFORME FINAL - SISTEMA DE REQUERIMIENTOS POR CAPAS" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan

# Calcular métricas de calidad
$porcentajeCompletitud = [math]::Round(($archivosEncontrados / $archivosTotalesEsperados) * 100, 2)
$porcentajeCapasCompletas = [math]::Round(($capasCompletas / $capasTotales) * 100, 2)
$porcentajeContenidoValido = [math]::Round(($archivosConContenido / $archivosEncontrados) * 100, 2)

Write-Host ""
Write-Host "🎯 MÉTRICAS DE INTEGRIDAD:" -ForegroundColor White
Write-Host "   • Archivos encontrados: $archivosEncontrados/$archivosTotalesEsperados ($porcentajeCompletitud%)" -ForegroundColor $(
    if ($porcentajeCompletitud -ge 90) { "Green" } elseif ($porcentajeCompletitud -ge 70) { "Yellow" } else { "Red" }
)
Write-Host "   • Capas completas: $capasCompletas/$capasTotales ($porcentajeCapasCompletas%)" -ForegroundColor $(
    if ($porcentajeCapasCompletas -eq 100) { "Green" } elseif ($porcentajeCapasCompletas -ge 50) { "Yellow" } else { "Red" }
)
Write-Host "   • Archivos con contenido: $archivosConContenido/$archivosEncontrados ($porcentajeContenidoValido%)" -ForegroundColor $(
    if ($porcentajeContenidoValido -ge 90) { "Green" } elseif ($porcentajeContenidoValido -ge 70) { "Yellow" } else { "Red" }
)

# Calcular puntuación general
$puntuacion = 0
$maxPuntuacion = 3

if ($porcentajeCompletitud -ge 90) { $puntuacion++ }
if ($porcentajeCapasCompletas -ge 75) { $puntuacion++ }
if ($porcentajeContenidoValido -ge 80) { $puntuacion++ }

Write-Host ""
Write-Host "🏆 PUNTUACIÓN GENERAL: $puntuacion/$maxPuntuacion" -ForegroundColor $(
    if ($puntuacion -eq 3) { "Green" } elseif ($puntuacion -eq 2) { "Yellow" } else { "Red" }
)

Write-Host ""
Write-Host "💡 RECOMENDACIONES ESPECÍFICAS:" -ForegroundColor Cyan

if ($porcentajeCompletitud -lt 100) {
    Write-Host "   • Completar archivos faltantes en la matriz 4×3" -ForegroundColor White
}

if ($archivosVacios.Count -gt 0) {
    Write-Host "   • Revisar archivos vacíos o sin dependencias:" -ForegroundColor White
    foreach ($archivoVacio in $archivosVacios) {
        Write-Host "     - $archivoVacio" -ForegroundColor Gray
    }
}

if ($archivosConProblemasNomenclatura.Count -gt 0) {
    Write-Host "   • Corregir nomenclatura en archivos problemáticos" -ForegroundColor White
}

if ($puntuacion -eq 3) {
    Write-Host "   • ✅ El sistema de requerimientos está en estado ÓPTIMO" -ForegroundColor Green
}

Write-Host ""
Write-Host "🚀 PRÓXIMOS PASOS SUGERIDOS:" -ForegroundColor Cyan
Write-Host "   • Instalar dependencias de desarrollo: pip install -r requerimientos/desarrollo/requerimientos_desarrollo_comun.txt" -ForegroundColor White
Write-Host "   • Verificar compatibilidad: .\verificar_compatibilidad.ps1" -ForegroundColor White
Write-Host "   • Actualizar dependencias periódicamente" -ForegroundColor White

Write-Host ""
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host "✅ VERIFICACIÓN DE ESTRUCTURA POR CAPAS COMPLETADA" -ForegroundColor Green
Write-Host "=" * 70 -ForegroundColor Cyan
