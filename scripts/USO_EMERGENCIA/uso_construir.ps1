# =============================================================================
# ESTRATEGIA: Script de Reconstrucción de Emergencia - Tesis Edge AI
# PROPÓSITO: Reconstruir completamente el ecosistema Docker después de cambios
#            críticos en dependencias, Dockerfile o requirements
# COHERENCIA: Verificación → Limpieza → Construcción → Validación → Guía
# ADVERTENCIA: Proceso de LARGA DURACIÓN (20-40 minutos) - Usar solo cuando sea necesario
# =============================================================================

# -----------------------------------------------------------------------------
# FASE 1: ADVERTENCIAS Y CONFIRMACIÓN
# Estrategia: Asegurar que el usuario comprende el impacto y tiempo requerido
# -----------------------------------------------------------------------------
Write-Host "🚨 RECONSTRUCCIÓN COMPLETA DE CONTENEDORES TESIS EDGE AI" -ForegroundColor Red
Write-Host "=" * 65 -ForegroundColor Red
Write-Host "⚠️  ADVERTENCIA: Este proceso tomará 20-40 MINUTOS" -ForegroundColor Yellow
Write-Host "⚠️  Se reconstruirán TODAS las imágenes Docker desde cero" -ForegroundColor Yellow
Write-Host "=" * 65 -ForegroundColor Red
Write-Host ""

Write-Host "📋 RAZONES VÁLIDAS para ejecutar este script:" -ForegroundColor Cyan
Write-Host "   • Cambios en requirements.txt o Dockerfile" -ForegroundColor White
Write-Host "   • Imágenes Docker corruptas o inconsistentes" -ForegroundColor White
Write-Host "   • Actualización de versiones base de Python/paquetes" -ForegroundColor White
Write-Host "   • Cambio de versión de CUDA o herramientas de ML" -ForegroundColor White
Write-Host ""

Write-Host "❌ NO EJECUTAR para:" -ForegroundColor Red
Write-Host "   • Instalar un paquete nuevo (usar pip install)" -ForegroundColor White
Write-Host "   • Problemas de un contenedor (usar docker-compose restart)" -ForegroundColor White
Write-Host "   • Errores en tu código (revisar tu implementación)" -ForegroundColor White
Write-Host ""

# Confirmación explícita del usuario
$confirmacion = Read-Host "¿Estás seguro de que quieres continuar? (escribe 'SI' para confirmar)"
if ($confirmacion -ne "SI") {
    Write-Host "❌ Reconstrucción cancelada por el usuario" -ForegroundColor Yellow
    exit 0
}

Write-Host ""

# -----------------------------------------------------------------------------
# FASE 2: VERIFICACIÓN EXHAUSTIVA DEL SISTEMA
# Estrategia: Fallar rápido con diagnósticos claros antes de invertir tiempo
# -----------------------------------------------------------------------------
Write-Host "[1/6] Verificando pre-condiciones del sistema..." -ForegroundColor Gray

# Verificación 1: Docker disponible
try {
    $dockerVersion = docker --version 2>$null
    if (-not $dockerVersion) {
        throw "Docker no encontrado"
    }
    Write-Host "   ✅ Docker: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Docker no está disponible en el sistema" -ForegroundColor Red
    Write-Host "   💡 Instala Docker Desktop y asegúrate de que esté ejecutándose" -ForegroundColor Yellow
    exit 1
}

# Verificación 2: Docker daemon funcionando
try {
    $dockerInfo = docker info 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Docker daemon no responde"
    }
    Write-Host "   ✅ Docker daemon funcionando" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Docker daemon no está ejecutándose" -ForegroundColor Red
    Write-Host "   💡 Inicia Docker Desktop y espera a que esté listo" -ForegroundColor Yellow
    exit 1
}

# Verificación 3: Dockerfile existe
if (-not (Test-Path "Dockerfile")) {
    Write-Host "   ❌ No se encuentra Dockerfile en el directorio actual" -ForegroundColor Red
    Write-Host "   📍 Directorio actual: $(Get-Location)" -ForegroundColor Gray
    Write-Host "   💡 Ejecuta desde la raíz del proyecto tesis_edge_ai" -ForegroundColor Yellow
    exit 1
}
Write-Host "   ✅ Dockerfile encontrado" -ForegroundColor Green

# Verificación 4: Espacio en disco (crítico para construcción)
try {
    $diskInfo = Get-PSDrive C | Select-Object Used, Free
    $freeGB = [math]::Round($diskInfo.Free / 1GB, 2)
    if ($freeGB -lt 10) {
        Write-Host "   ⚠️  Espacio libre bajo: $freeGB GB (se recomiendan 10+ GB)" -ForegroundColor Yellow
    } else {
        Write-Host "   ✅ Espacio en disco: $freeGB GB libre" -ForegroundColor Green
    }
} catch {
    Write-Host "   ⚠️  No se pudo verificar espacio en disco" -ForegroundColor Yellow
}

# Verificación 5: Conexión a internet (para descargar paquetes)
try {
    $connectionTest = Test-NetConnection -ComputerName "google.com" -Port 443 -InformationLevel Quiet -WarningAction SilentlyContinue
    if ($connectionTest) {
        Write-Host "   ✅ Conexión a internet disponible" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Sin conexión a internet - fallará la descarga de paquetes" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ⚠️  No se pudo verificar conexión a internet" -ForegroundColor Yellow
}

# -----------------------------------------------------------------------------
# FASE 3: LIMPIEZA PREVIA
# Estrategia: Eliminar recursos antiguos para evitar conflictos
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[2/6] Limpiando imágenes anteriores..." -ForegroundColor Gray

# Detener contenedores en ejecución que usen las imágenes
Write-Host "   Deteniendo contenedores relacionados..." -ForegroundColor Gray
docker-compose down 2>$null

# Eliminar imágenes antiguas
$imagenesTesis = docker images --filter "reference=tesis-*" --format "{{.Repository}}:{{.Tag}}" 2>$null
if ($imagenesTesis) {
    Write-Host "   Eliminando imágenes anteriores..." -ForegroundColor Gray
    $imagenesTesis | ForEach-Object {
        Write-Host "     🗑️  Eliminando: $_" -ForegroundColor DarkGray
        docker rmi $_ --force 2>$null
    }
}
Write-Host "   ✅ Limpieza completada" -ForegroundColor Green

# -----------------------------------------------------------------------------
# FASE 4: CONSTRUCCIÓN EN CASCADA CON MANEJO ROBUSTO DE ERRORES
# Estrategia: Construir en orden de dependencia con recuperación de errores
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[3/6] Iniciando construcción de imágenes..." -ForegroundColor Gray
Write-Host "   ⏰ Tiempo estimado: 20-40 minutos" -ForegroundColor Yellow
Write-Host "   ☕ Este es un buen momento para tomar un café..." -ForegroundColor Cyan
Write-Host ""

$startTime = Get-Date
$imagenesConstruidas = @()
$imagenesFallidas = @()

# Función para construir una imagen con manejo robusto
function Build-Image {
    param($nombre, $target, $tag)
    
    Write-Host "   🔨 Construyendo: $nombre..." -ForegroundColor Cyan
    Write-Host "      Target: $target" -ForegroundColor Gray
    Write-Host "      Tag: $tag" -ForegroundColor Gray
    
    $buildStart = Get-Date
    docker build --target $target -t $tag . --no-cache --progress=plain
    
    if ($LASTEXITCODE -eq 0) {
        $buildTime = [math]::Round(((Get-Date) - $buildStart).TotalMinutes, 2)
        Write-Host "      ✅ $nombre construido en $buildTime minutos" -ForegroundColor Green
        return $true
    } else {
        Write-Host "      ❌ Error construyendo $nombre" -ForegroundColor Red
        return $false
    }
}

# Construcción 1: Imagen de desarrollo (base para otras)
if (Build-Image -nombre "DESARROLLO" -target "desarrollo" -tag "tesis-desarrollo:3.10") {
    $imagenesConstruidas += "tesis-desarrollo:3.10"
} else {
    $imagenesFallidas += "tesis-desarrollo:3.10"
    Write-Host "   💡 Solución: Revisa Dockerfile y requirements/desarrollo.txt" -ForegroundColor Yellow
}

# Construcción 2: Imagen de experimentos (depende de desarrollo)
if ($imagenesConstruidas -contains "tesis-desarrollo:3.10") {
    if (Build-Image -nombre "EXPERIMENTOS" -target "experiments" -tag "tesis-experiments:3.10") {
        $imagenesConstruidas += "tesis-experiments:3.10"
    } else {
        $imagenesFallidas += "tesis-experiments:3.10"
        Write-Host "   💡 Solución: Revisa requirements/experiments.txt" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ⏭️  Saltando EXPERIMENTOS (falló dependencia DESARROLLO)" -ForegroundColor Yellow
}

# Construcción 3: Imagen edge (depende de desarrollo)
if ($imagenesConstruidas -contains "tesis-desarrollo:3.10") {
    if (Build-Image -nombre "EDGE" -target "edge" -tag "tesis-edge:3.10") {
        $imagenesConstruidas += "tesis-edge:3.10"
    } else {
        $imagenesFallidas += "tesis-edge:3.10"
        Write-Host "   💡 Solución: Revisa requirements/edge.txt" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ⏭️  Saltando EDGE (falló dependencia DESARROLLO)" -ForegroundColor Yellow
}

# -----------------------------------------------------------------------------
# FASE 5: VALIDACIÓN Y REPORTE FINAL
# Estrategia: Proporcionar resumen claro del resultado y próximos pasos
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[4/6] Validando imágenes construidas..." -ForegroundColor Gray

$totalTime = [math]::Round(((Get-Date) - $startTime).TotalMinutes, 2)
Write-Host "   ⏱️  Tiempo total transcurrido: $totalTime minutos" -ForegroundColor Cyan

# Verificar que las imágenes existen
$imagenesFinales = docker images --filter "reference=tesis-*" --format "{{.Repository}}:{{.Tag}}"
$imagenesVerificadas = @()

if ($imagenesFinales) {
    $imagenesFinales | ForEach-Object {
        $imagen = $_
        Write-Host "   ✅ $imagen" -ForegroundColor Green
        $imagenesVerificadas += $imagen
    }
} else {
    Write-Host "   ❌ No se encontraron imágenes tesis construidas" -ForegroundColor Red
}

# -----------------------------------------------------------------------------
# FASE 6: GUÍA DE RECUPERACIÓN Y PRÓXIMOS PASOS
# Estrategia: Proporcionar acciones claras basadas en el resultado
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[5/6] Resumen de la construcción:" -ForegroundColor Gray

if ($imagenesConstruidas.Count -eq 3) {
    Write-Host "   🎉 ¡RECONSTRUCCIÓN EXITOSA! Todas las imágenes creadas" -ForegroundColor Green
} elseif ($imagenesConstruidas.Count -gt 0) {
    Write-Host "   ⚠️  RECONSTRUCCIÓN PARCIAL: $($imagenesConstruidas.Count)/3 imágenes creadas" -ForegroundColor Yellow
    Write-Host "      Creadas: $($imagenesConstruidas -join ', ')" -ForegroundColor White
    if ($imagenesFallidas.Count -gt 0) {
        Write-Host "      Falladas: $($imagenesFallidas -join ', ')" -ForegroundColor Red
    }
} else {
    Write-Host "   ❌ RECONSTRUCCIÓN FALLIDA: Ninguna imagen se pudo construir" -ForegroundColor Red
}

Write-Host ""
Write-Host "[6/6] Próximos pasos recomendados:" -ForegroundColor Gray

if ($imagenesConstruidas.Count -gt 0) {
    Write-Host "🚀 INICIAR CONTENEDORES:" -ForegroundColor Cyan
    if ($imagenesConstruidas -contains "tesis-desarrollo:3.10") {
        Write-Host "   💻 Desarrollo:    .\iniciar_desarrollo.ps1" -ForegroundColor White
    }
    if ($imagenesConstruidas -contains "tesis-experiments:3.10") {
        Write-Host "   🔬 Experimentos:  .\iniciar_experimentos.ps1" -ForegroundColor White
    }
    if ($imagenesConstruidas -contains "tesis-edge:3.10") {
        Write-Host "   📱 Edge:         .\iniciar_edge.ps1" -ForegroundColor White
    }
    
    Write-Host ""
    Write-Host "📊 VERIFICAR IMÁGENES:" -ForegroundColor Cyan
    Write-Host "   docker images | findstr 'tesis'" -ForegroundColor White
} else {
    Write-Host "🔧 SOLUCIÓN DE PROBLEMAS:" -ForegroundColor Cyan
    Write-Host "   1. Revisa que Dockerfile no tenga errores de sintaxis" -ForegroundColor White
    Write-Host "   2. Verifica que los archivos requirements/*.txt existan" -ForegroundColor White
    Write-Host "   3. Ejecuta con más detalle: docker build --no-cache --progress=plain ." -ForegroundColor White
    Write-Host "   4. Consulta los logs de Docker Desktop para más detalles" -ForegroundColor White
}

Write-Host ""
Write-Host "💡 INFORMACIÓN ADICIONAL:" -ForegroundColor Cyan
Write-Host "   • Las imágenes están listas para usar en cualquier momento" -ForegroundColor White
Write-Host "   • Los datos en volúmenes Docker se preservan" -ForegroundColor White
Write-Host "   • Solo necesitas reconstruir después de cambios en dependencias" -ForegroundColor White

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Cyan
if ($imagenesConstruidas.Count -eq 3) {
    Write-Host "✅ RECONSTRUCCIÓN COMPLETADA EXITOSAMENTE" -ForegroundColor Green
} else {
    Write-Host "⚠️  RECONSTRUCCIÓN FINALIZADA CON INCIDENTES" -ForegroundColor Yellow
}
Write-Host "================================================================================" -ForegroundColor Cyan

$null = Read-Host "`nPresiona Enter para cerrar esta ventana"
