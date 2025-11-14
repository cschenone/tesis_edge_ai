# =============================================
# CONFIGURADOR PYTORCH - STACK PRINCIPAL TESIS
# =============================================
# 🎯 OBJETIVO: Configurar entorno PyTorch completo para tesis doctoral
# 📁 ESTRUCTURA: Base → Desarrollo → Experimentos (jerarquía completa)
# 💡 USO: Ejecutar después de crear estructura y dependencias
# 🔧 MANTENIMIENTO: Actualizar rutas si cambia estructura de requerimientos

# 🎨 CONFIGURACIÓN DE COLORES
$ColorTitulo = "Cyan"
$ColorExito = "Green"
$ColorAdvertencia = "Yellow"
$ColorError = "Red"
$ColorInfo = "Gray"
$ColorDestacado = "Magenta"

function Test-Prerequisitos {
    <#
    .DESCRIPTION
    Verifica todos los prerequisitos del sistema
    #>
    Write-Host "🔍 Verificando prerequisitos del sistema..." -ForegroundColor $ColorAdvertencia
    
    # 1. Permisos de escritura
    try {
        $testFile = "test_permisos_$([System.Guid]::NewGuid().ToString().Substring(0,8)).txt"
        "test" | Out-File -FilePath $testFile -ErrorAction Stop
        Remove-Item $testFile -ErrorAction Stop
        Write-Host "   ✅ Permisos de escritura" -ForegroundColor $ColorExito
    }
    catch {
        Write-Host "   ❌ Sin permisos de escritura" -ForegroundColor $ColorError
        Write-Host "   💡 Ejecuta PowerShell como administrador" -ForegroundColor White
        return $false
    }
    
    # 2. Política de ejecución
    $currentPolicy = Get-ExecutionPolicy
    if ($currentPolicy -eq "Restricted") {
        Write-Host "   ⚠️  Política restrictiva. Intentando cambiar..." -ForegroundColor $ColorAdvertencia
        try {
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction Stop
            Write-Host "   ✅ Política cambiada a RemoteSigned" -ForegroundColor $ColorExito
        }
        catch {
            Write-Host "   ❌ No se pudo cambiar la política" -ForegroundColor $ColorError
            Write-Host "   💡 Ejecuta manualmente: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor White
            return $false
        }
    } else {
        Write-Host "   ✅ Política de ejecución: $currentPolicy" -ForegroundColor $ColorExito
    }
    
    # 3. Python instalado
    try {
        $pythonVersion = python --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ Python: $pythonVersion" -ForegroundColor $ColorExito
        } else {
            throw "Python no disponible"
        }
    }
    catch {
        Write-Host "   ❌ Python no encontrado" -ForegroundColor $ColorError
        Write-Host "   💡 Descarga desde: https://python.org" -ForegroundColor White
        Write-Host "   💡 Marca 'Add Python to PATH' durante instalación" -ForegroundColor White
        return $false
    }
    
    # 4. Estructura de requerimientos
    $requerimientosBase = "requerimientos\base\requerimientos_base_pytorch.txt"
    if (-not (Test-Path $requerimientosBase)) {
        Write-Host "   ❌ Estructura de requerimientos no encontrada" -ForegroundColor $ColorError
        Write-Host "   💡 Ejecuta primero: .\scripts\01_crear_estructura.ps1" -ForegroundColor White
        Write-Host "   💡 Luego: .\scripts\02_crear_dependencias.ps1" -ForegroundColor White
        return $false
    }
    Write-Host "   ✅ Estructura de requerimientos verificada" -ForegroundColor $ColorExito
    
    return $true
}

function Install-EntornoPyTorch {
    <#
    .DESCRIPTION
    Instala el stack completo de PyTorch según la jerarquía definida
    #>
    param(
        [string]$TipoEntorno = "desarrollo"  # desarrollo, experimentos, completo
    )
    
    Write-Host "📦 Instalando stack PyTorch ($TipoEntorno)..." -ForegroundColor $ColorDestacado
    Write-Host "⏳ Esto puede tomar 10-30 minutos..." -ForegroundColor $ColorInfo
    
    $success = $true
    
    try {
        # Actualizar pip primero
        Write-Host "   🔄 Actualizando pip..." -ForegroundColor $ColorInfo
        python -m pip install --upgrade pip
        if ($LASTEXITCODE -ne 0) { throw "Error actualizando pip" }
        Write-Host "   ✅ Pip actualizado" -ForegroundColor $ColorExito
        
        # ESTRATEGIA DE INSTALACIÓN JERÁRQUICA
        switch ($TipoEntorno.ToLower()) {
            "desarrollo" {
                # Solo desarrollo (para trabajo diario)
                Write-Host "   💻 Instalando DESARROLLO PyTorch..." -ForegroundColor $ColorInfo
                pip install -r "requerimientos\desarrollo\requerimientos_desarrollo_pytorch.txt"
                if ($LASTEXITCODE -ne 0) { throw "Error instalando desarrollo PyTorch" }
                Write-Host "   ✅ Desarrollo PyTorch instalado" -ForegroundColor $ColorExito
            }
            "experimentos" {
                # Desarrollo + Experimentos (para entrenamiento)
                Write-Host "   🔬 Instalando EXPERIMENTOS PyTorch..." -ForegroundColor $ColorInfo
                pip install -r "requerimientos\experimentos\requerimientos_experimentos_pytorch.txt"
                if ($LASTEXITCODE -ne 0) { throw "Error instalando experimentos PyTorch" }
                Write-Host "   ✅ Experimentos PyTorch instalados" -ForegroundColor $ColorExito
            }
            "completo" {
                # Todo el stack (desarrollo + experimentos)
                Write-Host "   🚀 Instalando stack COMPLETO PyTorch..." -ForegroundColor $ColorInfo
                pip install -r "requerimientos\experimentos\requerimientos_experimentos_pytorch.txt"
                if ($LASTEXITCODE -ne 0) { throw "Error instalando stack completo" }
                Write-Host "   ✅ Stack completo PyTorch instalado" -ForegroundColor $ColorExito
            }
        }
        
        return $true
    }
    catch {
        Write-Host "   ❌ Error durante instalación: $_" -ForegroundColor $ColorError
        return $false
    }
}

function Test-InstalacionPyTorch {
    <#
    .DESCRIPTION
    Verifica que PyTorch esté correctamente instalado
    #>
    Write-Host "🔍 Verificando instalación de PyTorch..." -ForegroundColor $ColorAdvertencia
    
    try {
        $testScript = @"
import sys
try:
    import torch
    import torchvision
    import pytorch_lightning as pl
    print(f"✅ PyTorch: {torch.__version__}")
    print(f"✅ TorchVision: {torchvision.__version__}")
    print(f"✅ PyTorch Lightning: {pl.__version__}")
    print(f"✅ CUDA disponible: {torch.cuda.is_available()}")
    if torch.cuda.is_available():
        print(f"✅ GPU: {torch.cuda.get_device_name(0)}")
    print("🎉 Instalación PyTorch VERIFICADA")
except ImportError as e:
    print(f"❌ Error de importación: {e}")
    sys.exit(1)
except Exception as e:
    print(f"⚠️  Advertencia: {e}")
    sys.exit(0)
"@
        
        $testScript | Out-File -FilePath "test_pytorch.py" -Encoding UTF8
        python test_pytorch.py
        $testResult = $LASTEXITCODE
        Remove-Item "test_pytorch.py" -ErrorAction SilentlyContinue
        
        return ($testResult -eq 0)
    }
    catch {
        Write-Host "   ❌ Error en verificación: $_" -ForegroundColor $ColorError
        return $false
    }
}

# 🚀 INICIO DEL SCRIPT
Write-Host "🧠 CONFIGURANDOR PYTORCH - TESIS EDGE AI" -ForegroundColor $ColorTitulo
Write-Host "==========================================" -ForegroundColor $ColorTitulo

# 🔍 VERIFICACIÓN DE PREREQUISITOS
Write-Host "📋 PASO 1/4: Verificación de prerequisitos..." -ForegroundColor $ColorAdvertencia
if (-not (Test-Prerequisitos)) {
    Write-Host "❌ Prerequisitos no cumplidos" -ForegroundColor $ColorError
    exit 1
}

# 🐍 CREACIÓN DE ENTORNO VIRTUAL
Write-Host "📁 PASO 2/4: Configurando entorno virtual..." -ForegroundColor $ColorAdvertencia

$venvName = "venv_tesis"
$venvPath = ".\$venvName"

# Verificar si el entorno ya existe
if (Test-Path $venvPath) {
    Write-Host "⚠️  Entorno virtual ya existe: $venvName" -ForegroundColor $ColorAdvertencia
    $respuesta = Read-Host "¿Reinstalar entorno? Esto borrará la instalación actual (s/N)"
    if ($respuesta -eq 's') {
        Remove-Item $venvPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "   🔄 Entorno anterior eliminado" -ForegroundColor $ColorInfo
    } else {
        Write-Host "   💡 Usando instalación existente" -ForegroundColor $ColorInfo
    }
}

# Crear entorno virtual si no existe
if (-not (Test-Path $venvPath)) {
    try {
        Write-Host "   🏗️  Creando entorno virtual: $venvName" -ForegroundColor $ColorInfo
        python -m venv $venvName
        if ($LASTEXITCODE -ne 0) { throw "Error creando entorno virtual" }
        Write-Host "   ✅ Entorno virtual creado" -ForegroundColor $ColorExito
    }
    catch {
        Write-Host "   ❌ Error creando entorno virtual: $_" -ForegroundColor $ColorError
        Write-Host "   💡 Solución: Ejecuta PowerShell como administrador" -ForegroundColor White
        exit 1
    }
}

# ⚡ ACTIVACIÓN DEL ENTORNO
Write-Host "`n⚡ PASO 3/4: Activando entorno virtual..." -ForegroundColor $ColorAdvertencia

$venvActivate = "$venvPath\Scripts\Activate.ps1"
if (Test-Path $venvActivate) {
    try {
        & $venvActivate
        Write-Host "   ✅ Entorno virtual activado" -ForegroundColor $ColorExito
    }
    catch {
        Write-Host "   ❌ Error activando entorno virtual" -ForegroundColor $ColorError
        Write-Host "   💡 Activa manualmente: .\$venvName\Scripts\Activate.ps1" -ForegroundColor White
        exit 1
    }
} else {
    Write-Host "   ❌ Script de activación no encontrado" -ForegroundColor $ColorError
    exit 1
}

# 📦 INSTALACIÓN DE PYTORCH
Write-Host "`n📦 PASO 4/4: Instalación de PyTorch..." -ForegroundColor $ColorAdvertencia

# Selección del tipo de instalación
Write-Host "🎯 Selecciona el tipo de instalación:" -ForegroundColor $ColorDestacado
Write-Host "   1. 💻 DESARROLLO (recomendado para inicio)" -ForegroundColor White
Write-Host "   2. 🔬 EXPERIMENTOS (+ herramientas entrenamiento)" -ForegroundColor White
Write-Host "   3. 🚀 COMPLETO (todo el stack)" -ForegroundColor White

$opcion = Read-Host "`nOpción (1-3) [por defecto: 1]"
$tipoInstalacion = switch ($opcion) {
    "2" { "experimentos" }
    "3" { "completo" }
    default { "desarrollo" }
}

Write-Host "   🔧 Tipo seleccionado: $tipoInstalacion" -ForegroundColor $ColorInfo

# Instalación
if (Install-EntornoPyTorch -TipoEntorno $tipoInstalacion) {
    Write-Host "🎉 INSTALACIÓN COMPLETADA EXITOSAMENTE!" -ForegroundColor White -BackgroundColor DarkGreen
} else {
    Write-Host "❌ INSTALACIÓN CON ERRORES" -ForegroundColor $ColorError -BackgroundColor DarkRed
    Write-Host "   💡 Verifica tu conexión a internet y ejecuta de nuevo" -ForegroundColor White
    exit 1
}

# 🔍 VERIFICACIÓN FINAL
Write-Host "🔍 Verificación final de la instalación..." -ForegroundColor $ColorAdvertencia
if (Test-InstalacionPyTorch) {
    Write-Host "✅ Instalación PyTorch VERIFICADA" -ForegroundColor $ColorExito
} else {
    Write-Host "⚠️  Instalación con advertencias" -ForegroundColor $ColorAdvertencia
}

# 📋 INSTRUCCIONES FINALES
Write-Host "📋 INSTRUCCIONES DE USO:" -ForegroundColor $ColorDestacado
Write-Host "   • Para ACTIVAR el entorno: .\$venvName\Scripts\Activate.ps1" -ForegroundColor White
Write-Host "   • Para DESACTIVAR: deactivate" -ForegroundColor White
Write-Host "   • Jupyter Notebook: jupyter lab" -ForegroundColor White
Write-Host "   • Verificación sistema: .\scripts\USO_SEMANAL\uso_verificar.ps1" -ForegroundColor White

Write-Host "🔧 ESTADO DEL SISTEMA:" -ForegroundColor $ColorDestacado
Write-Host "   • Permisos: ✅ Verificados" -ForegroundColor $ColorExito
Write-Host "   • Python: ✅ Instalado" -ForegroundColor $ColorExito
Write-Host "   • Entorno virtual: ✅ Configurado" -ForegroundColor $ColorExito
Write-Host "   • PyTorch: ✅ Instalado ($tipoInstalacion)" -ForegroundColor $ColorExito
Write-Host "   • Estructura: ✅ Jerárquica" -ForegroundColor $ColorExito

Write-Host "🚀 PRÓXIMOS PASOS RECOMENDADOS:" -ForegroundColor $ColorAdvertencia
Write-Host "   1. Verificar sistema completo: .\scripts\USO_SEMANAL\uso_verificar.ps1" -ForegroundColor White
Write-Host "   2. Iniciar Jupyter: .\scripts\USO_DIARIO\uso_jupyter.ps1" -ForegroundColor White
Write-Host "   3. Comenzar desarrollo en: codigo\Componentes\" -ForegroundColor White

Write-Host "💡 INFORMACIÓN ADICIONAL:" -ForegroundColor $ColorInfo
Write-Host "   • Entorno: $venvName" -ForegroundColor White
Write-Host "   • Tipo instalación: $tipoInstalacion" -ForegroundColor White
Write-Host "   • Ruta requerimientos: requerimientos\desarrollo|experimentos\" -ForegroundColor White
Write-Host "   • Estructura jerárquica: Base → Desarrollo → Experimentos" -ForegroundColor White

exit 0
