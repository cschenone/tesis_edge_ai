# =============================================
# SINCRONIZADOR DE REQUERIMIENTOS JERÁRQUICOS
# =============================================
# 🎯 OBJETIVO: Garantizar coherencia en la estructura jerárquica de dependencias
# 🔧 FUNCIÓN: Verifica y repara herencia entre niveles (Base → Desarrollo → Experimentos → Edge)
# 💡 ESTRATEGIA: Cada nivel hereda del anterior + archivos comunes específicos
# 🚫 ADVERTENCIA: No modificar manualmente - usar este script para cambios
# 🔄 MANTENIMIENTO: Ejecutar después de modificar cualquier archivo de requerimientos

# 🎨 CONFIGURACIÓN DE COLORES
$ColorTitulo = "Cyan"
$ColorExito = "Green"
$ColorAdvertencia = "Yellow"
$ColorError = "Red"
$ColorInfo = "Gray"
$ColorDestacado = "Magenta"

function Test-EstructuraRequerimientos {
    <#
    .DESCRIPTION
    Verifica que toda la estructura de requerimientos exista
    #>
    Write-Host "🔍 Verificando estructura de requerimientos..." -ForegroundColor $ColorAdvertencia
    
    $estructuraCompleta = $true
    
    # Verificar carpetas base
    $carpetas = @("base", "desarrollo", "experimentos", "edge")
    foreach ($carpeta in $carpetas) {
        if (-not (Test-Path "requerimientos\$carpeta")) {
            Write-Host "   ❌ Carpeta faltante: requerimientos\$carpeta" -ForegroundColor $ColorError
            $estructuraCompleta = $false
        }
    }
    
    # Verificar archivos comunes esenciales
    $archivosComunes = @(
        "requerimientos\base\requerimientos_base_comun.txt",
        "requerimientos\desarrollo\requerimientos_desarrollo_comun.txt",
        "requerimientos\experimentos\requerimientos_experimentos_comun.txt",
        "requerimientos\edge\requerimientos_edge_comun.txt"
    )
    
    foreach ($archivo in $archivosComunes) {
        if (-not (Test-Path $archivo)) {
            Write-Host "   ❌ Archivo común faltante: $archivo" -ForegroundColor $ColorError
            $estructuraCompleta = $false
        }
    }
    
    if ($estructuraCompleta) {
        Write-Host "   ✅ Estructura de requerimientos verificada" -ForegroundColor $ColorExito
    }
    
    return $estructuraCompleta
}

function Get-HerenciaRequerida {
    <#
    .DESCRIPTION
    Determina la herencia requerida para cada tipo de archivo
    #>
    param([string]$FilePath)
    
    $herencia = @()
    
    # Determinar tipo de archivo y herencia requerida
    if ($FilePath -match "desarrollo.*pytorch") {
        $herencia = @(
            "# 🔗 HEREDA: Base PyTorch + Desarrollo Común",
            "-r ../base/requerimientos_base_pytorch.txt",
            "-r requerimientos_desarrollo_comun.txt"
        )
    }
    elseif ($FilePath -match "desarrollo.*tensorflow") {
        $herencia = @(
            "# 🔗 HEREDA: Base TensorFlow + Desarrollo Común", 
            "-r ../base/requerimientos_base_tensorflow.txt",
            "-r requerimientos_desarrollo_comun.txt"
        )
    }
    elseif ($FilePath -match "experimentos.*pytorch") {
        $herencia = @(
            "# 🔗 HEREDA: Desarrollo PyTorch + Experimentos Común",
            "-r ../desarrollo/requerimientos_desarrollo_pytorch.txt", 
            "-r requerimientos_experimentos_comun.txt"
        )
    }
    elseif ($FilePath -match "experimentos.*tensorflow") {
        $herencia = @(
            "# 🔗 HEREDA: Desarrollo TensorFlow + Experimentos Común",
            "-r ../desarrollo/requerimientos_desarrollo_tensorflow.txt",
            "-r requerimientos_experimentos_comun.txt"
        )
    }
    elseif ($FilePath -match "edge.*pytorch") {
        $herencia = @(
            "# 🔗 HEREDA: Edge Común + PyTorch ARM específico",
            "-r requerimientos_edge_comun.txt"
            # NOTA: Edge PyTorch NO hereda de base_pytorch porque usa versiones ARM diferentes
        )
    }
    elseif ($FilePath -match "edge.*tensorflow") {
        $herencia = @(
            "# 🔗 HEREDA: Edge Común + TensorFlow Lite", 
            "-r requerimientos_edge_comun.txt"
            # NOTA: Edge TensorFlow usa tflite-runtime, no el tensorflow completo
        )
    }
    
    return $herencia
}

function Test-HerenciaCorrecta {
    <#
    .DESCRIPTION
    Verifica si un archivo tiene la herencia correcta
    #>
    param([string]$FilePath, [string[]]$HerenciaRequerida)
    
    if (-not (Test-Path $FilePath)) {
        return $false, "Archivo no existe"
    }
    
    $contenido = Get-Content $FilePath -Raw
    $herenciaCorrecta = $true
    $errores = @()
    
    # Verificar cada línea de herencia requerida (ignorando comentarios)
    foreach ($linea in $HerenciaRequerida) {
        if ($linea -notmatch "^#") {  # Solo verificar líneas que no son comentarios
            $patron = [regex]::Escape($linea) -replace "\\\-", "-"  # Escapar para regex
            if ($contenido -notmatch $patron) {
                $herenciaCorrecta = $false
                $errores += "Falta: $linea"
            }
        }
    }
    
    return $herenciaCorrecta, $errores
}

function Backup-Archivo {
    <#
    .DESCRIPTION  
    Crea backup de archivo antes de modificarlo
    #>
    param([string]$FilePath)
    
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupDir = "backups\requerimientos"
    $backupFile = "$backupDir\$(Split-Path $FilePath -Leaf)_$timestamp.bak"
    
    try {
        if (-not (Test-Path $backupDir)) {
            New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        }
        
        Copy-Item -Path $FilePath -Destination $backupFile -Force
        Write-Host "   📦 Backup creado: $(Split-Path $backupFile -Leaf)" -ForegroundColor $ColorInfo
        return $true
    }
    catch {
        Write-Host "   ⚠️  No se pudo crear backup: $_" -ForegroundColor $ColorAdvertencia
        return $false
    }
}

function Repair-Herencia {
    <#
    .DESCRIPTION
    Repara la herencia de un archivo de requerimientos
    #>
    param([string]$FilePath, [string[]]$HerenciaRequerida)
    
    Write-Host "   🔧 Reparando: $(Split-Path $FilePath -Leaf)" -ForegroundColor $ColorAdvertencia
    
    try {
        # Crear backup primero
        Backup-Archivo -FilePath $FilePath
        
        # Leer contenido actual (sin líneas de herencia existentes)
        $contenidoActual = Get-Content $FilePath | Where-Object { 
            $_ -notmatch "^\s*\-r\s+" -and $_ -notmatch "^#\s*🔗 HEREDA:"
        }
        
        # Construir nuevo contenido
        $nuevoContenido = @()
        
        # Agregar encabezado de herencia
        $nuevoContenido += "# ============================================="
        $nuevoContenido += "# HERENCIA JERÁRQUICA - NO MODIFICAR MANUALMENTE"
        $nuevoContenido += "# ============================================="
        $nuevoContenido += ""
        $nuevoContenido += $HerenciaRequerida
        $nuevoContenido += ""
        $nuevoContenido += "# ============================================="
        $nuevoContenido += "# DEPENDENCIAS ESPECÍFICAS"
        $nuevoContenido += "# ============================================="
        $nuevoContenido += ""
        $nuevoContenido += $contenidoActual
        
        # Escribir archivo
        $nuevoContenido | Out-File -FilePath $FilePath -Encoding UTF8
        Write-Host "   ✅ Herencia reparada correctamente" -ForegroundColor $ColorExito
        return $true
    }
    catch {
        Write-Host "   ❌ Error reparando herencia: $_" -ForegroundColor $ColorError
        return $false
    }
}

# 🚀 INICIO DEL SCRIPT
Write-Host "🔄 SINCRONIZADOR DE REQUERIMIENTOS JERÁRQUICOS" -ForegroundColor $ColorTitulo
Write-Host "==============================================" -ForegroundColor $ColorTitulo

Write-Host "🎯 OBJETIVO: Sincronizar estructura jerárquica de dependencias" -ForegroundColor $ColorInfo
Write-Host "💡 ESTRATEGIA: Base → Desarrollo → Experimentos → Edge" -ForegroundColor $ColorInfo
Write-Host "🚫 ADVERTENCIA: Los archivos modificados tendrán backup automático" -ForegroundColor $ColorAdvertencia

# 🔍 VERIFICACIÓN INICIAL
Write-Host "📋 PASO 1/3: Verificación de estructura..." -ForegroundColor $ColorAdvertencia

if (-not (Test-EstructuraRequerimientos)) {
    Write-Host "❌ Estructura de requerimientos incompleta" -ForegroundColor $ColorError
    Write-Host "💡 Ejecuta primero: .\scripts\02_crear_dependencias.ps1" -ForegroundColor White
    exit 1
}

# 📁 LISTA DE ARCHIVOS A VERIFICAR
Write-Host "📁 PASO 2/3: Verificando archivos específicos..." -ForegroundColor $ColorAdvertencia

$requerimientosEspecificos = @(
    "requerimientos\desarrollo\requerimientos_desarrollo_pytorch.txt",
    "requerimientos\desarrollo\requerimientos_desarrollo_tensorflow.txt", 
    "requerimientos\experimentos\requerimientos_experimentos_pytorch.txt",
    "requerimientos\experimentos\requerimientos_experimentos_tensorflow.txt",
    "requerimientos\edge\requerimientos_edge_pytorch.txt",
    "requerimientos\edge\requerimientos_edge_tensorflow.txt"
)

$archivosVerificados = 0
$archivosReparados = 0
$archivosCorrectos = 0
$archivosConError = 0

foreach ($req in $requerimientosEspecificos) {
    Write-Host "🔍 Verificando: $(Split-Path $req -Leaf)" -ForegroundColor $ColorInfo
    
    if (-not (Test-Path $req)) {
        Write-Host "   ❌ Archivo no encontrado" -ForegroundColor $ColorError
        $archivosConError++
        continue
    }
    
    $archivosVerificados++
    
    # Obtener herencia requerida para este archivo
    $herenciaRequerida = Get-HerenciaRequerida -FilePath $req
    
    if ($herenciaRequerida.Count -eq 0) {
        Write-Host "   ⚠️  Tipo de archivo no reconocido" -ForegroundColor $ColorAdvertencia
        $archivosConError++
        continue
    }
    
    # Verificar herencia actual
    $herenciaCorrecta, $errores = Test-HerenciaCorrecta -FilePath $req -HerenciaRequerida $herenciaRequerida
    
    if ($herenciaCorrecta) {
        Write-Host "   ✅ Herencia correcta" -ForegroundColor $ColorExito
        $archivosCorrectos++
    } else {
        Write-Host "   ❌ Herencia incorrecta" -ForegroundColor $ColorError
        foreach ($error in $errores) {
            Write-Host "      • $error" -ForegroundColor $ColorAdvertencia
        }
        
        # Preguntar si reparar
        $reparar = Read-Host "   ¿Reparar automáticamente? (s/N)"
        if ($reparar -eq 's') {
            if (Repair-Herencia -FilePath $req -HerenciaRequerida $herenciaRequerida) {
                $archivosReparados++
            } else {
                $archivosConError++
            }
        } else {
            Write-Host "   💡 Herencia mantenida sin cambios" -ForegroundColor $ColorInfo
            $archivosConError++
        }
    }
}

# 📊 REPORTE FINAL
Write-Host "`n" + "="*50 -ForegroundColor $ColorTitulo
Write-Host "📊 REPORTE DE SINCRONIZACIÓN" -ForegroundColor $ColorDestacado
Write-Host "="*50 -ForegroundColor $ColorTitulo

Write-Host "📈 ESTADÍSTICAS:" -ForegroundColor $ColorInfo
Write-Host "   • Archivos verificados: $archivosVerificados" -ForegroundColor White
Write-Host "   • Archivos correctos: $archivosCorrectos" -ForegroundColor $ColorExito
Write-Host "   • Archivos reparados: $archivosReparados" -ForegroundColor $ColorAdvertencia
Write-Host "   • Archivos con error: $archivosConError" -ForegroundColor $(if ($archivosConError -gt 0) { $ColorError } else { $ColorExito })

if ($archivosConError -eq 0) {
    Write-Host "🎉 SINCRONIZACIÓN COMPLETADA EXITOSAMENTE!" -ForegroundColor White -BackgroundColor DarkGreen
} else {
    Write-Host "⚠️  SINCRONIZACIÓN COMPLETADA CON ADVERTENCIAS" -ForegroundColor $ColorAdvertencia -BackgroundColor DarkBlue
}

Write-Host "🏗️  ESTRUCTURA JERÁRQUICA VERIFICADA:" -ForegroundColor $ColorDestacado
Write-Host "   • 📦 BASE: requerimientos_base_[framework].txt + requerimientos_base_comun.txt" -ForegroundColor White
Write-Host "   • 💻 DESARROLLO: Hereda de BASE + requerimientos_desarrollo_comun.txt" -ForegroundColor White
Write-Host "   • 🔬 EXPERIMENTOS: Hereda de DESARROLLO + requerimientos_experimentos_comun.txt" -ForegroundColor White
Write-Host "   • 📱 EDGE: requerimientos_edge_comun.txt (versiones ARM específicas)" -ForegroundColor White

Write-Host "💡 INFORMACIÓN ADICIONAL:" -ForegroundColor $ColorInfo
Write-Host "   • Backups creados en: backups\requerimientos\" -ForegroundColor White
Write-Host "   • Para regenerar estructura completa: .\scripts\02_crear_dependencias.ps1" -ForegroundColor White
Write-Host "   • Para verificar instalación: .\scripts\USO_SEMANAL\uso_verificar.ps1" -ForegroundColor White

Write-Host "🚀 PRÓXIMOS PASOS:" -ForegroundColor $ColorAdvertencia
if ($archivosReparados -gt 0) {
    Write-Host "   • Ejecutar: .\scripts\03a_configurar_pytorch.ps1 (para actualizar entornos)" -ForegroundColor White
}
Write-Host "   • Verificar sistema: .\scripts\USO_SEMANAL\uso_verificar.ps1" -ForegroundColor White

exit $(if ($archivosConError -eq 0) { 0 } else { 1 })
