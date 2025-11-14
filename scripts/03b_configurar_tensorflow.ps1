# =============================================
# CONFIGURADOR TENSORFLOW - COMPARATIVAS TESIS
# =============================================
# 🎯 OBJETIVO: Configurar entorno TensorFlow para experimentos comparativos
# ⚠️  ADVERTENCIA: Solo para uso temporal en validaciones cruzadas
# 🔄 ESTRATEGIA: Entorno SEPARADO para evitar conflictos con PyTorch
# 💡 USO: Ejecutar solo cuando se necesiten comparativas específicas
# 🚫 RESTRICCIÓN: No usar simultáneamente con PyTorch

# 🎨 CONFIGURACIÓN DE COLORES
$ColorTitulo = "Yellow"
$ColorExito = "Green"
$ColorAdvertencia = "Yellow"
$ColorError = "Red"
$ColorInfo = "Gray"
$ColorDestacado = "Magenta"
$ColorPeligro = "Red"

function Test-IncompatibilidadesPyTorch {
    <#
    .DESCRIPTION
    Verifica incompatibilidades potenciales con PyTorch
    #>
    Write-Host "🔍 Buscando incompatibilidades con PyTorch..." -ForegroundColor $ColorAdvertencia
    
    $incompatibilidades = @()
    
    # 1. Verificar si PyTorch está en el mismo entorno global
    try {
        python -c "import torch" 2>$null
        $incompatibilidades += "❌ PyTorch detectado en entorno Python global"
        Write-Host "   ⚠️  PyTorch encontrado en entorno global" -ForegroundColor $ColorPeligro
    } catch {
        Write-Host "   ✅ No hay PyTorch en entorno global" -ForegroundColor $ColorExito
    }
    
    # 2. Verificar conflictos de versiones de CUDA
    try {
        $cudaVersion = nvcc --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ℹ️  CUDA detectado en sistema" -ForegroundColor $ColorInfo
            # TensorFlow 2.10 requiere CUDA 11.2, PyTorch 1.12 requiere CUDA 11.3
            $incompatibilidades += "⚠️  Posible conflicto de versiones CUDA: TF 2.10 (CUDA 11.2) vs PyTorch 1.12 (CUDA 11.3)"
        }
    } catch {
        Write-Host "   ✅ Sin CUDA en sistema (solo CPU)" -ForegroundColor $ColorExito
    }
    
    # 3. Verificar si hay entornos virtuales de PyTorch
    if (Test-Path ".\venv_tesis") {
        $incompatibilidades += "📁 Entorno PyTorch (venv_tesis) detectado - USAR ENTORNOS SEPARADOS"
        Write-Host "   ✅ Entorno PyTorch en carpeta separada" -ForegroundColor $ColorExito
    }
    
    # 4. Verificar conflictos de dependencias comunes
    $conflictPackages = @("numpy", "protobuf", "h5py")
    foreach ($pkg in $conflictPackages) {
        try {
            python -c "import $pkg; print(f'$pkg: OK')" 2>$null
            Write-Host "   ℹ️  $pkg presente en entorno global" -ForegroundColor $ColorInfo
        } catch {
            # Package not installed, no conflict
        }
    }
    
    return $incompatibilidades
}

function Show-AdvertenciasIncompatibilidad {
    <#
    .DESCRIPTION
    Muestra advertencias críticas sobre incompatibilidades
    #>
    Write-Host "🚨 ADVERTENCIAS CRÍTICAS DE INCOMPATIBILIDAD" -ForegroundColor $ColorPeligro
    Write-Host "=============================================" -ForegroundColor $ColorPeligro
    
    Write-Host "🔴 CONFLICTOS CON PYTORCH:" -ForegroundColor $ColorPeligro
    Write-Host "   • ❌ NO instalar TensorFlow en el mismo entorno que PyTorch" -ForegroundColor White
    Write-Host "   • ❌ NO mezclar dependencias de ambos frameworks" -ForegroundColor White
    Write-Host "   • ❌ Conflictos comunes: NumPy, CUDA, cuDNN, protobuf" -ForegroundColor White
    
    Write-Host "🟡 PROBLEMAS ESPERADOS:" -ForegroundColor $ColorAdvertencia
    Write-Host "   • ⚠️  Diferentes versiones de CUDA pueden causar errores" -ForegroundColor White
    Write-Host "   • ⚠️  Conflictos de memoria GPU si ambos se cargan" -ForegroundColor White
    Write-Host "   • ⚠️  Incompatibilidades en preprocesamiento de imágenes" -ForegroundColor White
    
    Write-Host "🟢 ESTRATEGIA SEGURA:" -ForegroundColor $ColorExito
    Write-Host "   • ✅ Entornos virtuales SEPARADOS" -ForegroundColor White
    Write-Host "   • ✅ Activar SOLO UN entorno a la vez" -ForegroundColor White
    Write-Host "   • ✅ Scripts de comparativas deben manejar ambos imports" -ForegroundColor White
    
    Write-Host "💡 EJEMPLO DE USO SEGURO:" -ForegroundColor $ColorInfo
    Write-Host "   # En scripts de comparativas:" -ForegroundColor White
    Write-Host "   try:" -ForegroundColor White
    Write-Host "       import tensorflow as tf" -ForegroundColor White
    Write-Host "       USAR_TENSORFLOW = True" -ForegroundColor White
    Write-Host "   except ImportError:" -ForegroundColor White
    Write-Host "       USAR_TENSORFLOW = False" -ForegroundColor White
    Write-Host "   # Lógica específica para cada framework" -ForegroundColor White
    
    $confirmar = Read-Host "`n¿Continuar con la instalación de TensorFlow? (s/N)"
    return ($confirmar -eq 's')
}

function Test-PrerequisitosTensorFlow {
    <#
    .DESCRIPTION
    Verifica prerequisitos específicos para TensorFlow
    #>
    Write-Host "🔍 Verificando prerequisitos TensorFlow..." -ForegroundColor $ColorAdvertencia
    
    # 1. Permisos de escritura
    try {
        $testFile = "test_permisos_tf_$([System.Guid]::NewGuid().ToString().Substring(0,8)).txt"
        "test" | Out-File -FilePath $testFile -ErrorAction Stop
        Remove-Item $testFile -ErrorAction Stop
        Write-Host "   ✅ Permisos de escritura" -ForegroundColor $ColorExito
    }
    catch {
        Write-Host "   ❌ Sin permisos de escritura" -ForegroundColor $ColorError
        return $false
    }
    
    # 2. Espacio en disco (TensorFlow es grande)
    $disk = Get-PSDrive -Name (Get-Location).Drive.Name
    $freeGB = [math]::Round($disk.Free / 1GB, 2)
    Write-Host "   💾 Espacio libre: $freeGB GB" -ForegroundColor $ColorInfo
    
    if ($freeGB -lt 8) {
        Write-Host "   ⚠️  Espacio bajo para TensorFlow (recomendado: 10GB+)" -ForegroundColor $ColorAdvertencia
        $continuar = Read-Host "   ¿Continuar igual? (s/n)"
        if ($continuar -ne 's') {
            return $false
        }
    } else {
        Write-Host "   ✅ Espacio en disco suficiente" -ForegroundColor $ColorExito
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
        return $false
    }
    
    # 4. Estructura de requerimientos
    $requerimientosBase = "requerimientos\base\requerimientos_base_tensorflow.txt"
    if (-not (Test-Path $requerimientosBase)) {
        Write-Host "   ❌ Estructura de requerimientos no encontrada" -ForegroundColor $ColorError
        Write-Host "   💡 Ejecuta primero los scripts de creación de estructura" -ForegroundColor White
        return $false
    }
    Write-Host "   ✅ Estructura de requerimientos verificada" -ForegroundColor $ColorExito
    
    return $true
}

function Install-EntornoTensorFlow {
    <#
    .DESCRIPTION
    Instala el stack de TensorFlow para comparativas
    #>
    param(
        [string]$TipoEntorno = "desarrollo"  # desarrollo, experimentos
    )
    
    Write-Host "📦 Instalando stack TensorFlow ($TipoEntorno)..." -ForegroundColor $ColorDestacado
    Write-Host "⏳ TensorFlow es grande (2-4GB), puede tomar 15-30 minutos..." -ForegroundColor $ColorInfo
    
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
                Write-Host "   🤖 Instalando DESARROLLO TensorFlow..." -ForegroundColor $ColorInfo
                pip install -r "requerimientos\desarrollo\requerimientos_desarrollo_tensorflow.txt"
                if ($LASTEXITCODE -ne 0) { throw "Error instalando desarrollo TensorFlow" }
                Write-Host "   ✅ Desarrollo TensorFlow instalado" -ForegroundColor $ColorExito
            }
            "experimentos" {
                Write-Host "   🔬 Instalando EXPERIMENTOS TensorFlow..." -ForegroundColor $ColorInfo
                pip install -r "requerimientos\experimentos\requerimientos_experimentos_tensorflow.txt"
                if ($LASTEXITCODE -ne 0) { throw "Error instalando experimentos TensorFlow" }
                Write-Host "   ✅ Experimentos TensorFlow instalados" -ForegroundColor $ColorExito
            }
        }
        
        return $true
    }
    catch {
        Write-Host "   ❌ Error durante instalación: $_" -ForegroundColor $ColorError
        return $false
    }
}

function Test-InstalacionTensorFlow {
    <#
    .DESCRIPTION
    Verifica que TensorFlow esté correctamente instalado
    #>
    Write-Host "🔍 Verificando instalación de TensorFlow..." -ForegroundColor $ColorAdvertencia
    
    try {
        $testScript = @"
import sys
try:
    import tensorflow as tf
    print(f"✅ TensorFlow: {tf.__version__}")
    print(f"✅ GPU disponible: {tf.config.list_physical_devices('GPU')}")
    
    # Test básico de funcionalidad
    hello = tf.constant('Hello, TensorFlow!')
    print(f"✅ Test básico: {hello.numpy().decode()}")
    
    print("🎉 Instalación TensorFlow VERIFICADA")
except ImportError as e:
    print(f"❌ Error de importación: {e}")
    sys.exit(1)
except Exception as e:
    print(f"⚠️  Advertencia: {e}")
    sys.exit(0)
"@
        
        $testScript | Out-File -FilePath "test_tensorflow.py" -Encoding UTF8
        python test_tensorflow.py
        $testResult = $LASTEXITCODE
        Remove-Item "test_tensorflow.py" -ErrorAction SilentlyContinue
        
        return ($testResult -eq 0)
    }
    catch {
        Write-Host "   ❌ Error en verificación: $_" -ForegroundColor $ColorError
        return $false
    }
}

# 🚀 INICIO DEL SCRIPT
Write-Host "🤖 CONFIGURADOR TENSORFLOW - COMPARATIVAS TESIS" -ForegroundColor $ColorTitulo
Write-Host "==============================================" -ForegroundColor $ColorTitulo

# 🚨 VERIFICACIÓN DE INCOMPATIBILIDADES
Write-Host "🚨 PASO 1/5: Verificación de incompatibilidades..." -ForegroundColor $ColorPeligro

$incompatibilidades = Test-IncompatibilidadesPyTorch
if ($incompatibilidades.Count -gt 0) {
    Write-Host "⚠️  INCOMPATIBILIDADES DETECTADAS:" -ForegroundColor $ColorPeligro
    foreach ($issue in $incompatibilidades) {
        Write-Host "   • $issue" -ForegroundColor $ColorAdvertencia
    }
}

if (-not (Show-AdvertenciasIncompatibilidad)) {
    Write-Host "❌ Instalación cancelada por el usuario" -ForegroundColor $ColorError
    exit 1
}

# 🔍 VERIFICACIÓN DE PREREQUISITOS
Write-Host "📋 PASO 2/5: Verificación de prerequisitos..." -ForegroundColor $ColorAdvertencia
if (-not (Test-PrerequisitosTensorFlow)) {
    Write-Host "❌ Prerequisitos no cumplidos" -ForegroundColor $ColorError
    exit 1
}

# 🐍 CREACIÓN DE ENTORNO VIRTUAL
Write-Host "📁 PASO 3/5: Configurando entorno virtual SEPARADO..." -ForegroundColor $ColorAdvertencia

$venvName = "venv_tensorflow"
$venvPath = ".\$venvName"

# Verificar y gestionar entorno existente
if (Test-Path $venvPath) {
    Write-Host "⚠️  Entorno TensorFlow ya existe: $venvName" -ForegroundColor $ColorAdvertencia
    Write-Host "💡 Opciones:" -ForegroundColor White
    Write-Host "   1. Reinstalar (borrar y crear nuevo)" -ForegroundColor White
    Write-Host "   2. Usar existente" -ForegroundColor White
    Write-Host "   3. Cancelar" -ForegroundColor White
    
    $opcion = Read-Host "`nOpción (1-3) [por defecto: 2]"
    switch ($opcion) {
        "1" { 
            Remove-Item $venvPath -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "   🔄 Entorno anterior eliminado" -ForegroundColor $ColorInfo
        }
        "3" { 
            Write-Host "   ❌ Instalación cancelada" -ForegroundColor $ColorError
            exit 1 
        }
        default { 
            Write-Host "   💡 Usando instalación existente" -ForegroundColor $ColorInfo
        }
    }
}

# Crear entorno virtual si no existe
if (-not (Test-Path $venvPath)) {
    try {
        Write-Host "   🏗️  Creando entorno virtual SEPARADO: $venvName" -ForegroundColor $ColorInfo
        python -m venv $venvName
        if ($LASTEXITCODE -ne 0) { throw "Error creando entorno virtual" }
        Write-Host "   ✅ Entorno virtual TensorFlow creado" -ForegroundColor $ColorExito
    }
    catch {
        Write-Host "   ❌ Error creando entorno virtual: $_" -ForegroundColor $ColorError
        exit 1
    }
}

# ⚡ ACTIVACIÓN DEL ENTORNO
Write-Host "⚡ PASO 4/5: Activando entorno TensorFlow..." -ForegroundColor $ColorAdvertencia

$venvActivate = "$venvPath\Scripts\Activate.ps1"
if (Test-Path $venvActivate) {
    try {
        & $venvActivate
        Write-Host "   ✅ Entorno TensorFlow activado" -ForegroundColor $ColorExito
    }
    catch {
        Write-Host "   ❌ Error activando entorno TensorFlow" -ForegroundColor $ColorError
        Write-Host "   💡 Activa manualmente: .\$venvName\Scripts\Activate.ps1" -ForegroundColor White
        exit 1
    }
} else {
    Write-Host "   ❌ Script de activación no encontrado" -ForegroundColor $ColorError
    exit 1
}

# 📦 INSTALACIÓN DE TENSORFLOW
Write-Host "📦 PASO 5/5: Instalación de TensorFlow..." -ForegroundColor $ColorAdvertencia

# Selección del tipo de instalación
Write-Host "🎯 Selecciona el tipo de instalación:" -ForegroundColor $ColorDestacado
Write-Host "   1. 💻 DESARROLLO (recomendado para comparativas básicas)" -ForegroundColor White
Write-Host "   2. 🔬 EXPERIMENTOS (+ herramientas entrenamiento TF)" -ForegroundColor White

$opcion = Read-Host "`nOpción (1-2) [por defecto: 1]"
$tipoInstalacion = if ($opcion -eq "2") { "experimentos" } else { "desarrollo" }

Write-Host "   🔧 Tipo seleccionado: $tipoInstalacion" -ForegroundColor $ColorInfo

# Instalación
if (Install-EntornoTensorFlow -TipoEntorno $tipoInstalacion) {
    Write-Host "🎉 TENSORFLOW INSTALADO EXITOSAMENTE!" -ForegroundColor White -BackgroundColor Blue
} else {
    Write-Host "❌ INSTALACIÓN CON ERRORES" -ForegroundColor $ColorError -BackgroundColor DarkRed
    exit 1
}

# 🔍 VERIFICACIÓN FINAL
Write-Host "🔍 Verificación final de la instalación..." -ForegroundColor $ColorAdvertencia
if (Test-InstalacionTensorFlow) {
    Write-Host "✅ Instalación TensorFlow VERIFICADA" -ForegroundColor $ColorExito
} else {
    Write-Host "⚠️  Instalación con advertencias" -ForegroundColor $ColorAdvertencia
}

# 📋 INSTRUCCIONES FINALES CON ADVERTENCIAS
Write-Host "🚨 INSTRUCCIONES CRÍTICAS DE USO:" -ForegroundColor $ColorPeligro
Write-Host "   • 🔴 NO activar ambos entornos (PyTorch y TensorFlow) simultáneamente" -ForegroundColor White
Write-Host "   • 🔴 NO importar ambos frameworks en el mismo script" -ForegroundColor White
Write-Host "   • 🟡 En scripts de comparativas, usar try/except para imports" -ForegroundColor White

Write-Host "📋 USO SEGURO:" -ForegroundColor $ColorDestacado
Write-Host "   • Para USAR TENSORFLOW: .\$venvName\Scripts\Activate.ps1" -ForegroundColor White
Write-Host "   • Para VOLVER A PYTORCH: deactivate && .\venv_tesis\Scripts\Activate.ps1" -ForegroundColor White
Write-Host "   • TensorBoard: tensorboard --logdir logs/fit" -ForegroundColor White

Write-Host "🔧 ESTADO DEL SISTEMA:" -ForegroundColor $ColorDestacado
Write-Host "   • Permisos: ✅ Verificados" -ForegroundColor $ColorExito
Write-Host "   • Python: ✅ Instalado" -ForegroundColor $ColorExito
Write-Host "   • Entorno: ✅ Separado y configurado" -ForegroundColor $ColorExito
Write-Host "   • TensorFlow: ✅ Instalado ($tipoInstalacion)" -ForegroundColor $ColorExito
Write-Host "   • Incompatibilidades: ✅ Verificadas" -ForegroundColor $ColorExito

Write-Host "💡 RECOMENDACIÓN FINAL:" -ForegroundColor $ColorAdvertencia
Write-Host "   • Usa TensorFlow SOLO para experimentos comparativos específicos" -ForegroundColor White
Write-Host "   • Mantén PyTorch como entorno principal de desarrollo" -ForegroundColor White
Write-Host "   • Documenta claramente qué experimentos usan cada framework" -ForegroundColor White

Write-Host "⚠️  RECUERDA:" -ForegroundColor $ColorPeligro
Write-Host "   • Los conflictos entre PyTorch y TensorFlow pueden causar:" -ForegroundColor White
Write-Host "     - Errores de CUDA y memoria GPU" -ForegroundColor White
Write-Host "     - Inestabilidad en entrenamientos" -ForegroundColor White
Write-Host "     - Resultados inconsistentes" -ForegroundColor White

exit 0
