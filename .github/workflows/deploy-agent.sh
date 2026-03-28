#!/bin/bash
# =============================================================================
# AGENTE DE DESPLIEGUE - GitHub Pages para AstroWind (VERSIÓN SIMPLIFICADA)
# =============================================================================

set -e

REPO="cyb-c/reaprovechador"
WORKFLOW_NAME="Deploy to GitHub Pages"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[ÉXITO]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[ADVERTENCIA]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo "========================================="
echo "   AGENTE DE DESPLIEGUE - AstroWind      "
echo "========================================="

# Verificar autenticación
log_info "Verificando autenticación..."
if ! gh auth status &> /dev/null; then
    log_error "No estás autenticado. Ejecuta: gh auth login"
    exit 1
fi
log_success "Autenticación OK"

# Ejecutar workflow
log_info "Ejecutando workflow '${WORKFLOW_NAME}'..."
if ! gh workflow run "$WORKFLOW_NAME" --repo "$REPO" 2>&1; then
    log_error "No se pudo ejecutar el workflow"
    log_error "Posible causa: El token no tiene permisos de workflow"
    exit 1
fi
log_success "Workflow ejecutado"

# Esperar un momento para que GitHub registre el run
sleep 5

# Obtener el último run
log_info "Obteniendo estado del despliegue..."
RUN_URL="https://github.com/${REPO}/actions/workflows/deploy.yml"

echo ""
echo "========================================="
echo "   ESTADO DEL DESPLIEGUE                 "
echo "========================================="
echo "URL: ${RUN_URL}"
echo ""
log_info "Verifica el estado en GitHub Actions"
echo ""

# Intentar obtener estado (puede fallar en Codespaces)
if gh run list --repo "$REPO" --limit 1 2>/dev/null; then
    echo ""
    log_info "Para ver logs: gh run view --repo ${REPO} --log"
fi

echo ""
echo "========================================="
echo "   PRÓXIMOS PASOS                        "
echo "========================================="
echo "1. El workflow se está ejecutando"
echo "2. Revisa: https://github.com/${REPO}/actions"
echo "3. Cuando termine (2-5 min), visita:"
echo "   https://cyb-c.github.io/reaprovechador/"
echo "========================================="
