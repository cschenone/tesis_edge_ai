# Script de configuración inicial de Git para la tesis
Write-Host "🎯 CONFIGURANDO GIT PARA TESIS DOCTORAL" -ForegroundColor Green

# Configurar identidad
git config --global user.name "Carlos Schenone"
git config --global user.email "cschenone@unaj.edu.ar"

# Configurar editor
git config --global core.editor "code --wait"
git config --global color.ui auto

# Verificar configuración
Write-Host "✅ Configuración completada:" -ForegroundColor Green
git config --global --list

Write-Host "`n🎓 ¡Configuración lista! Revisa GUIA_GIT_TESIS.md para continuar." -ForegroundColor Cyan
