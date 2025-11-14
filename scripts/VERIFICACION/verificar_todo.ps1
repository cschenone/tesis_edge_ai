# =============================================================================
# ESTRATEGIA: Script de Verificación Completa del Sistema Tesis Edge AI
# PROPÓSITO: Diagnóstico integral de todos los componentes del proyecto
# COHERENCIA: Estructura → Scripts → Dependencias → Configuración → Reporte
# INNOVACIÓN: Verificación en capas con puntuación de salud del sistema
# =============================================================================

# -----------------------------------------------------------------------------
# FASE 1: CONFIGURACIÓN Y VARIABLES GLOBALES
# Estrategia: Centralizar configuración para mantenimiento fácil
# -----------------------------------------------------------------------------
$Global:ResultadosVerificacion = @()
$Global:TotalVerificaciones = 0
$Global:VerificacionesExitosas = 0

function Registrar-Verificacion {
    param([string]$Categoria, [string]$Componente, [bool]$Exito, [string]$Mensaje)
    
    $Global:TotalVerificaciones++
    if ($Exito) { $Global:VerificacionesExitosas++ }
    
    $Global:ResultadosVerificacion += [PSCustomObject]@{
        Categoria = $Categoria
        Componente = $Componente
        Exito = $Exito
        Mensaje = $Mensaje
        Timestamp = Get-Date
    }
}

# -----------------------------------------------------------------------------
# FASE 2: VERIFICACIÓN DE ESTRUCTURA DE CARPETAS
# Estrategia: Validar integridad del sistema de archivos del proyecto
# -----------------------------------------------------------------------------
function Test-EstructuraCarpetas {
    Write-Host "[1/6] 📁 VERIFICANDO ESTRUCTURA DE CARPETAS..." -ForegroundColor Cyan
    Write-Host "   Validando organización fundamental del proyecto..." -ForegroundColor Gray

    $estructuraProyecto = @(
        @{Carpeta = "codigo"; Proposito = "Código fuente y módulos principales"; Critica = $true},
        @{Carpeta = "datos"; Proposito = "Datasets y archivos de datos"; Critica = $false},
        @{Carpeta = "modelos"; Proposito = "Modelos entrenados y checkpoints"; Critica = $false},
        @{Carpeta = "documentacion"; Proposito = "Documentación del proyecto"; Critica = $false},
        @{Carpeta = "experimentos"; Proposito = "Resultados y logs de experimentos"; Critica = $false},
        @{Carpeta = "configs"; Proposito = "Archivos de configuración"; Critica = $true},
        @{Carpeta = "requerimientos"; Proposito = "Sistema de dependencias modular"; Critica = $true},
        @{Carpeta = "notebooks"; Proposito = "Jupyter notebooks de investigación"; Critica = $false},
        @{Carpeta = "scripts"; Proposito = "Sistema de automatización"; Critica = $true}
    )

    $carpetasEncontradas = 0
    $carpetasCriticasEncontradas = 0
    $carpetasCriticasTotales = ($estructuraProyecto | Where-Object { $_.Critica }).Count

    foreach ($item in $estructuraProyecto) {
        $existe = Test-Path $item.Carpeta
        $icono = if ($existe) { "✅" } else { if ($item.Critica) { "❌" } else { "⚠️" } }
        $color = if ($existe) { "Green" } else { if ($item.Critica) { "Red" } else { "Yellow" } }
        
        Write-Host "   $icono $($item.Carpeta)/" -ForegroundColor $color
        Write-Host "     • $($item.Proposito)" -ForegroundColor DarkGray
        
        Registrar-Verificacion -Categoria "Estructura" -Componente $item.Carpeta -Exito $exite -Mensaje $item.Proposito
        
        if ($existe) {
            $carpetasEncontradas++
            if ($item.Critica) { $carpetasCriticasEncontradas++ }
        }
    }

    Write-Host "   📊 Resumen: $carpetasEncontradas/$($estructuraProyecto.Count) carpetas encontradas" -ForegroundColor Cyan
    Write-Host "   🎯 Críticas: $carpetasCriticasEncontradas/$carpetasCriticasTotales carpetas críticas" -ForegroundColor $(
        if ($carpetasCriticasEncontradas -eq $carpetasCriticasTotales) { "Green" } else { "Red" }
    )
    
    return ($carpetasCriticasEncontradas -eq $carpetasCriticasTotales)
}

# -----------------------------------------------------------------------------
# FASE 3: VERIFICACIÓN DEL ECOSISTEMA DE SCRIPTS
# Estrategia: Validar integridad del sistema de automatización
# -----------------------------------------------------------------------------
function Test-EcosistemaScripts {
    Write-Host "[2/6] 🔧 VERIFICANDO ECOSISTEMA DE SCRIPTS..." -ForegroundColor Cyan
    Write-Host "   Validando sistema de automatización y scripts..." -ForegroundColor Gray

    $scriptsEsenciales = @(
        # Scripts numerados de setup
        @{Ruta = "00_orquestador_principal.ps1"; Proposito = "Punto de entrada principal"; Critico = $true},
        @{Ruta = "01_crear_estructura.ps1"; Proposito = "Configuración inicial"; Critico = $true},
        @{Ruta = "02_crear_dependencias.ps1"; Proposito = "Gestión de dependencias"; Critico = $true},
        
        # Scripts diarios críticos
        @{Ruta = "USO_DIARIO\uso_activar.ps1"; Proposito = "Activación ambiente diario"; Critico = $true},
        @{Ruta = "USO_DIARIO\uso_jupyter.ps1"; Proposito = "Entorno desarrollo Jupyter"; Critico = $true},
        @{Ruta = "USO_DIARIO\uso_detener.ps1"; Proposito = "Limpieza recursos"; Critico = $true},
        
        # Scripts de verificación
        @{Ruta = "VERIFICACION\ayuda_scripts.ps1"; Proposito = "Documentación del sistema"; Critico = $true},
        @{Ruta = "VERIFICACION\verificar_todo.ps1"; Proposito = "Verificación completa"; Critico = $false}
    )

    $scriptsEncontrados = 0
    $scriptsCriticosEncontrados = 0
    $scriptsCriticosTotales = ($scriptsEsenciales | Where-Object { $_.Critico }).Count

    foreach ($script in $scriptsEsenciales) {
        $existe = Test-Path $script.Ruta
        $icono = if ($existe) { "✅" } else { if ($script.Critico) { "❌" } else { "⚠️" } }
        $color = if ($existe) { "Green" } else { if ($script.Critico) { "Red" } else { "Yellow" } }
        
        Write-Host "   $icono $($script.Ruta)" -ForegroundColor $color
        Write-Host "     • $($script.Proposito)" -ForegroundColor DarkGray
        
        Registrar-Verificacion -Categoria "Scripts" -Componente $script.Ruta -Exito $existe -Mensaje $script.Proposito
        
        if ($existe) {
            $scriptsEncontrados++
            if ($script.Critico) { $scriptsCriticosEncontrados++ }
            
            # Verificar tamaño del script (no vacío)
            if ($existe) {
                $infoScript = Get-Item $script.Ruta -ErrorAction SilentlyContinue
                if ($infoScript -and $infoScript.Length -eq 0) {
                    Write-Host "     ⚠️  Script vacío" -ForegroundColor Yellow
                }
            }
        }
    }

    # Verificar estructura de carpetas de scripts
    Write-Host "   📁 Estructura de carpetas de scripts:" -ForegroundColor White
    $carpetasScripts = @("USO_DIARIO", "USO_SEMANAL", "USO_EMERGENCIA", "USO_ESPECIAL", "VERIFICACION")
    foreach ($carpeta in $carpetasScripts) {
        $existe = Test-Path $carpeta
        $icono = if ($existe) { "✅" } else { "❌" }
        $color = if ($existe) { "Green" } else { "Red" }
        Write-Host "   $icono $carpeta/" -ForegroundColor $color
    }

    Write-Host "   📊 Resumen scripts: $scriptsEncontrados/$($scriptsEsenciales.Count) encontrados" -ForegroundColor Cyan
    Write-Host "   🎯 Críticos: $scriptsCriticosEncontrados/$scriptsCriticosTotales scripts críticos" -ForegroundColor $(
        if ($scriptsCriticosEncontrados -eq $scriptsCriticosTotales) { "Green" } else { "Red" }
    )
    
    return ($scriptsCriticosEncontrados -eq $scriptsCriticosTotales)
}

# -----------------------------------------------------------------------------
# FASE 4: VERIFICACIÓN DE SISTEMA DE DEPENDENCIAS
# Estrategia: Validar estructura modular de requerimientos
# -----------------------------------------------------------------------------
function Test-SistemaRequerimientos {
    Write-Host "[3/6] 📦 VERIFICANDO SISTEMA DE REQUERIMIENTOS..." -ForegroundColor Cyan
    Write-Host "   Validando estructura modular de dependencias..." -ForegroundColor Gray

    $estructuraRequerimientos = @(
        @{Ruta = "requerimientos\base\requerimientos_base_comun.txt"; Proposito = "Dependencias comunes base"; Critico = $true},
        @{Ruta = "requerimientos\base\requerimientos_base_pytorch.txt"; Proposito = "Dependencias PyTorch base"; Critico = $true},
        @{Ruta = "requerimientos\base\requerimientos_base_tensorflow.txt"; Proposito = "Dependencias TensorFlow base"; Critico = $false},
        @{Ruta = "requerimientos\desarrollo\requerimientos_desarrollo_comun.txt"; Proposito = "Dependencias desarrollo"; Critico = $true},
        @{Ruta = "requerimientos\experimentos\requerimientos_experimentos_comun.txt"; Proposito = "Dependencias experimentos"; Critico = $false}
    )

    $archivosEncontrados = 0
    $archivosCriticosEncontrados = 0
    $archivosCriticosTotales = ($estructuraRequerimientos | Where-Object { $_.Critico }).Count

    foreach ($archivo in $estructuraRequerimientos) {
        $existe = Test-Path $archivo.Ruta
        $icono = if ($existe) { "✅" } else { if ($archivo.Critico) { "❌" } else { "⚠️" } }
        $color = if ($existe) { "Green" } else { if ($archivo.Critico) { "Red" } else { "Yellow" } }
        
        Write-Host "   $icono $($archivo.Ruta)" -ForegroundColor $color
        Write-Host "     • $($archivo.Proposito)" -ForegroundColor DarkGray
        
        Registrar-Verificacion -Categoria "Requerimientos" -Componente $archivo.Ruta -Exito $existe -Mensaje $archivo.Proposito
        
        if ($existe) {
            $archivosEncontrados++
            if ($archivo.Critico) { $archivosCriticosEncontrados++ }
            
            # Verificar que el archivo no esté vacío
            if ($existe) {
                $contenido = Get-Content $archivo.Ruta -ErrorAction SilentlyContinue
                if ($contenido -eq $null -or $contenido.Count -eq 0) {
                    Write-Host "     ⚠️  Archivo vacío" -ForegroundColor Yellow
                }
            }
        }
    }

    # Verificar carpetas de requerimientos
    Write-Host "   📁 Estructura de carpetas de requerimientos:" -ForegroundColor White
    $carpetasRequerimientos = @("base", "desarrollo", "experimentos", "edge")
    foreach ($carpeta in $carpetasRequerimientos) {
        $rutaCompleta = "requerimientos\$carpeta"
        $existe = Test-Path $rutaCompleta
        $icono = if ($existe) { "✅" } else { "❌" }
        $color = if ($existe) { "Green" } else { "Red" }
        Write-Host "   $icono $rutaCompleta/" -ForegroundColor $color
    }

    Write-Host "   📊 Resumen requerimientos: $archivosEncontrados/$($estructuraRequerimientos.Count) archivos" -ForegroundColor Cyan
    Write-Host "   🎯 Críticos: $archivosCriticosEncontrados/$archivosCriticosTotales archivos críticos" -ForegroundColor $(
        if ($archivosCriticosEncontrados -eq $archivosCriticosTotales) { "Green" } else { "Red" }
    )
    
    return ($archivosCriticosEncontrados -eq $archivosCriticosTotales)
}

# -----------------------------------------------------------------------------
# FASE 5: VERIFICACIÓN DE CONFIGURACIÓN Y DOCKER
# Estrategia: Validar componentes de infraestructura
# -----------------------------------------------------------------------------
function Test-ConfiguracionInfraestructura {
    Write-Host "[4/6] ⚙️  VERIFICANDO CONFIGURACIÓN E INFRAESTRUCTURA..." -ForegroundColor Cyan
    Write-Host "   Validando archivos de configuración y Docker..." -ForegroundColor Gray

    $archivosConfiguracion = @(
        @{Ruta = "docker-compose.yml"; Proposito = "Orquestación de contenedores"; Critico = $true},
        @{Ruta = "Dockerfile"; Proposito = "Imagen base Docker"; Critico = $true},
        @{Ruta = "configs\entorno_desarrollo.json"; Proposito = "Configuración desarrollo"; Critico = $false},
        @{Ruta = "configs\entorno_produccion.json"; Proposito = "Configuración producción"; Critico = $false},
        @{Ruta = ".env.example"; Proposito = "Variables de entorno ejemplo"; Critico = $false}
    )

    $configsEncontradas = 0
    $configsCriticasEncontradas = 0
    $configsCriticasTotales = ($archivosConfiguracion | Where-Object { $_.Critico }).Count

    foreach ($config in $archivosConfiguracion) {
        $existe = Test-Path $config.Ruta
        $icono = if ($existe) { "✅" } else { if ($config.Critico) { "❌" } else { "⚠️" } }
        $color = if ($existe) { "Green" } else { if ($config.Critico) { "Red" } else { "Yellow" } }
        
        Write-Host "   $icono $($config.Ruta)" -ForegroundColor $color
        Write-Host "     • $($config.Proposito)" -ForegroundColor DarkGray
        
        Registrar-Verificacion -Categoria "Configuración" -Componente $config.Ruta -Exito $existe -Mensaje $config.Proposito
        
        if ($existe) {
            $configsEncontradas++
            if ($config.Critico) { $configsCriticasEncontradas++ }
        }
    }

    # Verificar Docker (opcional)
    try {
        $dockerVersion = docker --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ Docker disponible: $dockerVersion" -ForegroundColor Green
            Registrar-Verificacion -Categoria "Infraestructura" -Componente "Docker" -Exito $true -Mensaje $dockerVersion
        } else {
            Write-Host "   ⚠️  Docker no disponible" -ForegroundColor Yellow
            Registrar-Verificacion -Categoria "Infraestructura" -Componente "Docker" -Exito $false -Mensaje "No disponible"
        }
    } catch {
        Write-Host "   ⚠️  Docker no disponible" -ForegroundColor Yellow
        Registrar-Verificacion -Categoria "Infraestructura" -Componente "Docker" -Exito $false -Mensaje "No disponible"
    }

    Write-Host "   📊 Resumen configuración: $configsEncontradas/$($archivosConfiguracion.Count) archivos" -ForegroundColor Cyan
    Write-Host "   🎯 Críticos: $configsCriticasEncontradas/$configsCriticasTotales archivos críticos" -ForegroundColor $(
        if ($configsCriticasEncontradas -eq $configsCriticasTotales) { "Green" } else { "Red" }
    )
    
    return ($configsCriticasEncontradas -eq $configsCriticasTotales)
}

# -----------------------------------------------------------------------------
# FASE 6: VERIFICACIÓN DE PYTHON Y ENTORNO
# Estrategia: Validar entorno de ejecución principal
# -----------------------------------------------------------------------------
function Test-EntornoPython {
    Write-Host "`n[5/6] 🐍 VERIFICANDO ENTORNO PYTHON..." -ForegroundColor Cyan
    Write-Host "   Validando Python y herramientas básicas..." -ForegroundColor Gray

    $pythonDisponible = $false
    $pythonVersion = "No disponible"
    
    # Verificar Python
    try {
        $versionOutput = python --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            $pythonDisponible = $true
            $pythonVersion = $versionOutput
            Write-Host "   ✅ $pythonVersion" -ForegroundColor Green
        }
    } catch {
        # Python no disponible con 'python'
    }
    
    if (-not $pythonDisponible) {
        try {
            $versionOutput = py --version 2>&1
            if ($LASTEXITCODE -eq 0) {
                $pythonDisponible = $true
                $pythonVersion = $versionOutput
                Write-Host "   ✅ Python (via py): $pythonVersion" -ForegroundColor Green
            }
        } catch {
            # Python no disponible con 'py' tampoco
        }
    }
    
    if (-not $pythonDisponible) {
        Write-Host "   ❌ Python no disponible en el sistema" -ForegroundColor Red
    }
    
    Registrar-Verificacion -Categoria "Python" -Componente "Python" -Exito $pythonDisponible -Mensaje $pythonVersion

    # Verificar pip
    if ($pythonDisponible) {
        try {
            $pipVersion = pip --version 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "   ✅ pip disponible" -ForegroundColor Green
                Registrar-Verificacion -Categoria "Python" -Componente "pip" -Exito $true -Mensaje "Disponible"
            } else {
                Write-Host "   ⚠️  pip no disponible" -ForegroundColor Yellow
                Registrar-Verificacion -Categoria "Python" -Componente "pip" -Exito $false -Mensaje "No disponible"
            }
        } catch {
            Write-Host "   ⚠️  pip no disponible" -ForegroundColor Yellow
            Registrar-Verificacion -Categoria "Python" -Componente "pip" -Exito $false -Mensaje "No disponible"
        }
    }

    return $pythonDisponible
}

# -----------------------------------------------------------------------------
# FASE 7: REPORTE FINAL Y MÉTRICAS
# Estrategia: Proporcionar resumen ejecutivo con acciones claras
# -----------------------------------------------------------------------------
function Show-ReporteFinal {
    Write-Host "`n[6/6] 📊 GENERANDO REPORTE FINAL..." -ForegroundColor Cyan
    Write-Host ""

    # Calcular métricas
    $porcentajeExito = [math]::Round(($Global:VerificacionesExitosas / $Global:TotalVerificaciones) * 100, 1)
    
    # Agrupar resultados por categoría
    $resumenCategorias = $Global:ResultadosVerificacion | Group-Object Categoria | ForEach-Object {
        $exitosos = ($_.Group | Where-Object Exito).Count
        $total = $_.Count
        $porcentaje = [math]::Round(($exitosos / $total) * 100, 1)
        
        [PSCustomObject]@{
            Categoria = $_.Name
            Exitosos = $exitosos
            Total = $total
            Porcentaje = $porcentaje
        }
    }

    Write-Host "=" * 70 -ForegroundColor Cyan
    Write-Host "📈 INFORME FINAL - VERIFICACIÓN COMPLETA DEL SISTEMA" -ForegroundColor Cyan
    Write-Host "=" * 70 -ForegroundColor Cyan

    Write-Host "🎯 MÉTRICAS GENERALES:" -ForegroundColor White
    Write-Host "   • Verificaciones realizadas: $Global:TotalVerificaciones" -ForegroundColor Gray
    Write-Host "   • Verificaciones exitosas: $Global:VerificacionesExitosas ($porcentajeExito%)" -ForegroundColor $(
        if ($porcentajeExito -ge 90) { "Green" } elseif ($porcentajeExito -ge 70) { "Yellow" } else { "Red" }
    )

    Write-Host "📊 RESUMEN POR CATEGORÍA:" -ForegroundColor White
    foreach ($categoria in $resumenCategorias) {
        Write-Host "   • $($categoria.Categoria): $($categoria.Exitosos)/$($categoria.Total) ($($categoria.Porcentaje)%)" -ForegroundColor $(
            if ($categoria.Porcentaje -ge 90) { "Green" } elseif ($categoria.Porcentaje -ge 70) { "Yellow" } else { "Red" }
        )
    }

    # Determinar estado general
    Write-Host "🏥 ESTADO GENERAL DEL SISTEMA:" -ForegroundColor White
    if ($porcentajeExito -ge 90) {
        Write-Host "   ✅ SISTEMA ÓPTIMO - Listo para desarrollo y producción" -ForegroundColor Green
    } elseif ($porcentajeExito -ge 70) {
        Write-Host "   ⚠️  SISTEMA FUNCIONAL - Algunas áreas necesitan atención" -ForegroundColor Yellow
    } else {
        Write-Host "   ❌ SISTEMA INCOMPLETO - Se requiere configuración significativa" -ForegroundColor Red
    }

    # Mostrar problemas críticos
    $problemasCriticos = $Global:ResultadosVerificacion | Where-Object { -not $_.Exito -and $_.Categoria -in @("Estructura", "Scripts", "Requerimientos", "Configuración") }
    
    if ($problemasCriticos.Count -gt 0) {
        Write-Host "🔴 PROBLEMAS CRÍTICOS DETECTADOS:" -ForegroundColor Red
        foreach ($problema in $problemasCriticos) {
            Write-Host "   • $($problema.Categoria): $($problema.Componente)" -ForegroundColor White
        }
    }

    Write-Host "🚀 PRÓXIMOS PASOS RECOMENDADOS:" -ForegroundColor Cyan
    
    if ($porcentajeExito -lt 90) {
        Write-Host "   1. Ejecutar configuración inicial: .\01_crear_estructura.ps1" -ForegroundColor White
        Write-Host "   2. Configurar dependencias: .\02_crear_dependencias.ps1" -ForegroundColor White
        Write-Host "   3. Consultar ayuda: .\VERIFICACION\ayuda_scripts.ps1" -ForegroundColor White
    } else {
        Write-Host "   1. Comenzar desarrollo: .\USO_DIARIO\uso_activar.ps1" -ForegroundColor White
        Write-Host "   2. Verificar semanalmente: .\USO_SEMANAL\uso_verificar.ps1" -ForegroundColor White
    }

    Write-Host "`n=" * 70 -ForegroundColor Cyan
    Write-Host "✅ VERIFICACIÓN COMPLETADA - $(Get-Date)" -ForegroundColor Green
    Write-Host "=" * 70 -ForegroundColor Cyan
}

# -----------------------------------------------------------------------------
# EJECUCIÓN PRINCIPAL
# Estrategia: Orquestación secuencial con manejo de errores
# -----------------------------------------------------------------------------
Write-Host "🔍 INICIANDO VERIFICACIÓN COMPLETA DEL SISTEMA TESIS EDGE AI" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host "🎯 Objetivo: Diagnóstico integral de todos los componentes del proyecto" -ForegroundColor Gray
Write-Host "📊 Alcance: Estructura, scripts, dependencias, configuración y entorno" -ForegroundColor Gray
Write-Host "=" * 70 -ForegroundColor Cyan

try {
    # Ejecutar verificaciones en secuencia
    $estructuraOK = Test-EstructuraCarpetas
    $scriptsOK = Test-EcosistemaScripts
    $requerimientosOK = Test-SistemaRequerimientos
    $configuracionOK = Test-ConfiguracionInfraestructura
    $pythonOK = Test-EntornoPython
    
    # Generar reporte final
    Show-ReporteFinal
    
} catch {
    Write-Host "❌ ERROR durante la verificación: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "💡 Ejecuta scripts de verificación individuales para más detalles" -ForegroundColor Yellow
}

# Pausa final para permitir lectura del reporte
Write-Host ""
$null = Read-Host "Presiona Enter para cerrar esta ventana"
