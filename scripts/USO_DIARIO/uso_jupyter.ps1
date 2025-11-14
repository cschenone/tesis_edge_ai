# =============================================================================
# ESTRATEGIA: Script de Inicio de Entorno de Desarrollo Jupyter
# PROPÓSITO: Iniciar entorno de notebooks de manera confiable y proporcionar
#            una experiencia de usuario guiada y libre de problemas
# COHERENCIA: Verificación → Ejecución → Validación → Guía de Uso
# =============================================================================

# -----------------------------------------------------------------------------
# FASE 1: INICIALIZACIÓN Y CONTEXTO
# Estrategia: Establecer expectativas claras y contexto operacional
# -----------------------------------------------------------------------------
Write-Host "🚀 INICIANDO ENTORNO DE DESARROLLO TESIS EDGE AI" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host ""
Write-Host "Iniciando Jupyter Lab para desarrollo e investigación..." -ForegroundColor Yellow
Write-Host ""

# -----------------------------------------------------------------------------
# FASE 2: VERIFICACIÓN EN CASCADA DE DEPENDENCIAS
# Estrategia: Fallar rápido con mensajes de error específicos y accionables
# -----------------------------------------------------------------------------
Write-Host "[1/5] Verificando pre-condiciones del sistema..." -ForegroundColor Gray

# Verificación 1: Docker disponible y funcionando
try {
    $dockerVersion = docker --version 2>$null
    if (-not $dockerVersion) {
        Write-Host "   ❌ Docker no está disponible en el PATH" -ForegroundColor Red
        Write-Host "   💡 Instala Docker Desktop o inicia el servicio Docker" -ForegroundColor Yellow
        $null = Read-Host "Presiona Enter para salir"
        exit 1
    }
    Write-Host "   ✅ Docker: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Error verificando Docker: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Verificación 2: Docker daemon ejecutándose
try {
    $dockerInfo = docker info 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   ❌ Docker daemon no está ejecutándose" -ForegroundColor Red
        Write-Host "   💡 Inicia Docker Desktop y espera a que esté listo" -ForegroundColor Yellow
        $null = Read-Host "Presiona Enter para salir"
        exit 1
    }
    Write-Host "   ✅ Docker daemon funcionando" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Error conectando con Docker daemon" -ForegroundColor Red
    exit 1
}

# Verificación 3: Archivo de composición existe
if (-not (Test-Path "docker-compose.yml")) {
    Write-Host "   ❌ No se encuentra docker-compose.yml" -ForegroundColor Red
    Write-Host "   💡 Ejecuta desde la raíz del proyecto tesis_edge_ai" -ForegroundColor Yellow
    Write-Host "   📍 Ruta actual: $(Get-Location)" -ForegroundColor Gray
    $null = Read-Host "Presiona Enter para salir"
    exit 1
}
Write-Host "   ✅ docker-compose.yml encontrado" -ForegroundColor Green

# Verificación 4: Puerto disponible
try {
    $portCheck = Test-NetConnection -ComputerName localhost -Port 8888 -WarningAction SilentlyContinue
    if ($portCheck.TcpTestSucceeded) {
        Write-Host "   ⚠️  Puerto 8888 ya en uso" -ForegroundColor Yellow
        Write-Host "   💡 Otro contenedor o servicio puede estar usando el puerto" -ForegroundColor Gray
        # No salir aquí - docker-compose manejará el conflicto
    } else {
        Write-Host "   ✅ Puerto 8888 disponible" -ForegroundColor Green
    }
} catch {
    Write-Host "   ℹ️  No se pudo verificar el puerto, continuando..." -ForegroundColor Gray
}

# -----------------------------------------------------------------------------
# FASE 3: EJECUCIÓN CON MANEJO DE ESTADOS
# Estrategia: Manejar diferentes estados del contenedor y recuperar de errores
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "[2/5] Verificando estado del contenedor de desarrollo..." -ForegroundColor Gray

# Verificar si el contenedor ya está ejecutándose
$contenedorEstado = docker-compose ps desarrollo --services --filter "status=running" 2>$null

if ($contenedorEstado -contains "desarrollo") {
    Write-Host "   ℹ️  Contenedor ya está ejecutándose" -ForegroundColor Yellow
} else {
    Write-Host "[3/5] Iniciando contenedor de desarrollo..." -ForegroundColor Gray
    
    # Intentar iniciar el contenedor
    docker-compose up -d desarrollo
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   ❌ Error al iniciar el contenedor" -ForegroundColor Red
        
        # ESTRATEGIA DE RECUPERACIÓN: Ofrecer soluciones específicas
        Write-Host ""
        Write-Host "🔧 Posibles soluciones:" -ForegroundColor Cyan
        Write-Host "   1. Imágenes no construidas: .\construir_contenedores.ps1" -ForegroundColor White
        Write-Host "   2. Puerto en conflicto: Cambia puerto en docker-compose.yml" -ForegroundColor White
        Write-Host "   3. Permisos: Ejecuta como administrador o ajusta permisos Docker" -ForegroundColor White
        Write-Host ""
        
        $null = Read-Host "Presiona Enter para continuar"
        exit 1
    }
    
    Write-Host "   ✅ Contenedor iniciado correctamente" -ForegroundColor Green
}

# -----------------------------------------------------------------------------
# FASE 4: VALIDACIÓN POST-EJECUCIÓN  
# Estrategia: Confirmar que el servicio está realmente operativo
# -----------------------------------------------------------------------------
Write-Host "[4/5] Validando que Jupyter Lab esté listo..." -ForegroundColor Gray

# Esperar a que el servicio esté disponible
$intentos = 0
$maxIntentos = 30
$jupyterListo = $false

while ($intentos -lt $maxIntentos -and -not $jupyterListo) {
    Start-Sleep -Seconds 2
    $intentos++
    
    try {
        $contenedorStatus = docker-compose ps desarrollo --status running 2>$null
        $logs = docker-compose logs desarrollo --tail=10 2>$null
        
        if ($logs -match "Jupyter Server.*is running at" -or $logs -match "http://0.0.0.0:8888") {
            $jupyterListo = $true
            Write-Host "   ✅ Jupyter Lab inicializado ($intentos/$maxIntentos)" -ForegroundColor Green
        } else {
            Write-Host "   ⏳ Esperando inicialización... ($intentos/$maxIntentos)" -ForegroundColor Gray
        }
    } catch {
        Write-Host "   ⚠️  Error verificando estado: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

if (-not $jupyterListo) {
    Write-Host "   ⚠️  Jupyter no respondió en tiempo esperado" -ForegroundColor Yellow
    Write-Host "   💡 Revisa logs con: docker-compose logs desarrollo" -ForegroundColor Gray
}

# -----------------------------------------------------------------------------
# FASE 5: GUÍA DE USO COMPLETA
# Estrategia: Proporcionar toda la información necesaria para comenzar inmediatamente
# -----------------------------------------------------------------------------
Write-Host "[5/5] Preparando información de acceso..." -ForegroundColor Gray
Write-Host ""

Write-Host "🎉 ENTORNO DE DESARROLLO LISTO" -ForegroundColor Green
Write-Host "────────────────────────────────────────────────────────────" -ForegroundColor Cyan

Write-Host ""
Write-Host "📍 ACCESO A JUPYTER LAB:" -ForegroundColor Cyan
Write-Host "   🌐 URL: http://localhost:8888" -ForegroundColor White -BackgroundColor DarkBlue
Write-Host "   🔑 Token: tesis2024" -ForegroundColor Yellow -BackgroundColor DarkBlue
Write-Host ""

Write-Host "📚 FLUJO DE TRABAJO RECOMENDADO:" -ForegroundColor Cyan
Write-Host "   1. Abre http://localhost:8888 en tu navegador" -ForegroundColor White
Write-Host "   2. Ingresa el token 'tesis2024' cuando se solicite" -ForegroundColor White
Write-Host "   3. Crea notebooks en /notebooks/ para experimentos" -ForegroundColor White
Write-Host "   4. Desarrolla módulos M1-M9 en /src/" -ForegroundColor White
Write-Host ""

Write-Host "🔧 COMANDOS DE OPERACIÓN:" -ForegroundColor Cyan
Write-Host "   📊 Ver logs en tiempo real: docker-compose logs -f desarrollo" -ForegroundColor White
Write-Host "   ⏸️  Pausar contenedor: docker-compose pause desarrollo" -ForegroundColor White
Write-Host "   ⏹️  Detener contenedor: docker-compose stop desarrollo" -ForegroundColor White
Write-Host "   🖥️  Shell en contenedor: docker exec -it tesis-desarrollo bash" -ForegroundColor White
Write-Host ""

Write-Host "🐛 DIAGNÓSTICO Y SOLUCIÓN DE PROBLEMAS:" -ForegroundColor Cyan
Write-Host "   • Página no carga: Verifica que Docker esté ejecutándose" -ForegroundColor White
Write-Host "   • Token no funciona: Revisa logs para nuevo token generado" -ForegroundColor White
Write-Host "   • Error de conexión: Verifica firewall y permisos Docker" -ForegroundColor White
Write-Host ""

Write-Host "💾 RECUERDA:" -ForegroundColor Cyan
Write-Host "   • Tu trabajo se guarda en ./notebooks/ y ./src/" -ForegroundColor White
Write-Host "   • Usa .\uso_diario_detener.ps1 al terminar tu jornada" -ForegroundColor White
Write-Host "   • Los datos persisten entre reinicios del contenedor" -ForegroundColor White

Write-Host ""
Write-Host "────────────────────────────────────────────────────────────" -ForegroundColor Cyan
Write-Host "¡Happy coding! 🚀 Tu entorno de investigación está listo." -ForegroundColor Green
Write-Host "────────────────────────────────────────────────────────────" -ForegroundColor Cyan

# -----------------------------------------------------------------------------
# ESTRATEGIA MEJORADA: No bloquear innecesariamente, permitir trabajo inmediato
# -----------------------------------------------------------------------------
Write-Host ""
$null = Read-Host "Presiona Enter para cerrar esta ventana (Jupyter seguirá ejecutándose)"
