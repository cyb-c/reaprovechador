#!/bin/bash
# =============================================================================
# AGENTE DE DESPLIEGUE - GitHub Pages (Agnóstico para Astro)
# =============================================================================
# Este script informa sobre el estado del despliegue y proporciona comandos
# útiles para monitorear el workflow de GitHub Actions
# =============================================================================

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Funciones de log
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[ÉXITO]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[ADVERTENCIA]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Obtener información del repo
REPO_OWNER=$(gh repo view --json owner --jq '.owner.login' 2>/dev/null || echo "")
REPO_NAME=$(gh repo view --json name --jq '.name' 2>/dev/null || echo "")

if [ -z "$REPO_OWNER" ] || [ -z "$REPO_NAME" ]; then
    log_error "No se pudo detectar el repositorio. Asegúrate de estar en un repo de GitHub."
    exit 1
fi

REPO="$REPO_OWNER/$REPO_NAME"
WORKFLOW_NAME="Deploy to GitHub Pages"

echo ""
echo "========================================="
echo "   AGENTE DE DESPLIEGUE - Astro          "
echo "   GitHub Pages                          "
echo "========================================="
echo ""

# Verificar autenticación
log_info "Verificando autenticación con GitHub CLI..."
if ! command -v gh &> /dev/null; then
    log_error "GitHub CLI (gh) no está instalado."
    log_info "Instálalo: https://cli.github.com/"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    log_error "No estás autenticado con GitHub."
    log_info "Ejecuta: gh auth login"
    exit 1
fi

log_success "Autenticación verificada"

# Mostrar URLs útiles
echo ""
echo "========================================="
echo "   ENLACES ÚTILES                        "
echo "========================================="
echo ""
echo "📁 Repositorio:"
echo "   https://github.com/$REPO_OWNER/$REPO_NAME"
echo ""
echo "🔄 GitHub Actions:"
echo "   https://github.com/$REPO_OWNER/$REPO_NAME/actions"
echo ""
echo "🌐 Sitio Desplegado:"
echo "   https://$REPO_OWNER.github.io/$REPO_NAME/"
echo ""

# Verificar último run
echo "========================================="
echo "   ÚLTIMOS DESPLIEGUES                   "
echo "========================================="
echo ""

if gh run list --repo "$REPO" --limit 5 &> /dev/null; then
    gh run list --repo "$REPO" --limit 5
    echo ""
    
    # Mostrar el más reciente
    LATEST_RUN=$(gh run list --repo "$REPO" --limit 1 --json databaseId,status,conclusion --jq '.[0]')
    
    if [ -n "$LATEST_RUN" ]; then
        echo "Estado del último deploy:"
        echo "$LATEST_RUN" | jq -r '"  Status: \(.status) | Conclusión: \(.conclusion // "en progreso")"'
    fi
else
    log_warning "No se pudieron obtener los runs del workflow"
fi

echo ""
echo "========================================="
echo "   COMANDOS ÚTILES                       "
echo "========================================="
echo ""
echo "Ver últimos 5 runs:"
echo "  gh run list --repo $REPO --limit 5"
echo ""
echo "Ver logs del último run:"
echo "  gh run view --repo $REPO --log --latest"
echo ""
echo "Ver un run específico:"
echo "  gh run view <RUN_ID> --repo $REPO --log"
echo ""
echo "Ver workflows disponibles:"
echo "  gh workflow list --repo $REPO"
echo ""
echo "========================================="
echo ""

log_info "Para desplegar, haz push a la rama main:"
echo "  git add -A"
echo "  git commit -m \"tus cambios\""
echo "  git push"
echo ""
log_success "El workflow se ejecutará automáticamente"
echo ""
