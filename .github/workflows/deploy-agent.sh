#!/bin/bash
# =============================================================================
# AGENTE DE DESPLIEGUE - GitHub Pages para AstroWind
# =============================================================================
# Este script automatiza el despliegue a GitHub Pages
# - Ejecuta el workflow de GitHub Actions
# - Monitorea el estado del despliegue
# - Reporta éxitos o fallos con logs detallados
# =============================================================================

set -e

# Configuración
REPO="cyb-c/reaprovechador"
WORKFLOW_NAME="Deploy to GitHub Pages"
MAX_WAIT_TIME=600  # 10 minutos máximo
CHECK_INTERVAL=10  # Verificar cada 10 segundos

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# =============================================================================
# FUNCIONES
# =============================================================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[ÉXITO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[ADVERTENCIA]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar autenticación con GitHub CLI
check_gh_auth() {
    log_info "Verificando autenticación con GitHub CLI..."
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI (gh) no está instalado. Instálalo con: brew install gh o apt install gh"
        exit 1
    fi
    
    if ! gh auth status &> /dev/null; then
        log_error "No estás autenticado con GitHub. Ejecuta: gh auth login"
        exit 1
    fi
    
    log_success "Autenticación verificada"
}

# Verificar que el workflow existe
check_workflow() {
    log_info "Verificando workflow '${WORKFLOW_NAME}'..."
    
    WORKFLOW_ID=$(gh api repos/${REPO}/actions/workflows | jq -r ".workflows[] | select(.name==\"${WORKFLOW_NAME}\") | .id")
    
    if [ -z "$WORKFLOW_ID" ]; then
        log_error "Workflow '${WORKFLOW_NAME}' no encontrado"
        exit 1
    fi
    
    log_success "Workflow encontrado (ID: ${WORKFLOW_ID})"
}

# Ejecutar el workflow
run_workflow() {
    log_info "Ejecutando workflow '${WORKFLOW_NAME}'..."
    
    RUN_ID=$(gh workflow run ${WORKFLOW_ID} --repo ${REPO} --json id -q '.id')
    
    if [ -z "$RUN_ID" ]; then
        log_error "No se pudo ejecutar el workflow"
        exit 1
    fi
    
    log_success "Workflow iniciado (Run ID: ${RUN_ID})"
    echo $RUN_ID
}

# Monitorear el estado del workflow
monitor_workflow() {
    local RUN_ID=$1
    local ELAPSED=0
    
    log_info "Monitoreando despliegue..."
    log_info "URL: https://github.com/${REPO}/actions/runs/${RUN_ID}"
    
    while [ $ELAPSED -lt $MAX_WAIT_TIME ]; do
        sleep $CHECK_INTERVAL
        ELAPSED=$((ELAPSED + CHECK_INTERVAL))
        
        STATUS=$(gh api repos/${REPO}/actions/runs/${RUN_ID} --json status -q '.status')
        CONCLUSION=$(gh api repos/${REPO}/actions/runs/${RUN_ID} --json conclusion -q '.conclusion')
        
        case $STATUS in
            "queued")
                log_info "Estado: En cola... (${ELAPSED}s)"
                ;;
            "in_progress")
                log_info "Estado: En progreso... (${ELAPSED}s)"
                ;;
            "completed")
                if [ "$CONCLUSION" == "success" ]; then
                    log_success "¡Despliegue completado exitosamente!"
                    log_info "Sitio disponible en: https://cyb-c.github.io/reaprovechador/"
                    return 0
                else
                    log_error "El despliegue falló con conclusión: ${CONCLUSION}"
                    return 1
                fi
                ;;
            *)
                log_warning "Estado desconocido: ${STATUS}"
                ;;
        esac
    done
    
    log_error "Tiempo máximo de espera alcanzado (${MAX_WAIT_TIME}s)"
    return 1
}

# Obtener logs de error
get_error_logs() {
    local RUN_ID=$1
    
    log_info "Obteniendo logs de error..."
    
    # Obtener jobs del run
    JOBS=$(gh api repos/${REPO}/actions/runs/${RUN_ID}/jobs --json steps,name,conclusion,steps)
    
    echo ""
    echo "========================================="
    echo "         LOG DE ERRORES                  "
    echo "========================================="
    echo "$JOBS" | jq -r '.jobs[] | select(.conclusion=="failure") | "\n=== Job: \(.name) ===\n"'
    
    # Intentar obtener logs detallados de jobs fallidos
    for JOB_ID in $(echo "$JOBS" | jq -r '.jobs[] | select(.conclusion=="failure") | .id'); do
        log_info "Logs detallados para job ${JOB_ID}:"
        gh run view ${RUN_ID} --repo ${REPO} --log 2>/dev/null || log_warning "No se pudieron obtener logs detallados"
    done
    
    echo "========================================="
    echo "   FIN DEL LOG DE ERRORES                "
    echo "========================================="
}

# Generar reporte de estado
generate_report() {
    local RUN_ID=$1
    local SUCCESS=$2
    
    echo ""
    echo "========================================="
    echo "       REPORTE DE DESPLIEGUE             "
    echo "========================================="
    echo "Repositorio: ${REPO}"
    echo "Workflow: ${WORKFLOW_NAME}"
    echo "Run ID: ${RUN_ID}"
    echo "URL del run: https://github.com/${REPO}/actions/runs/${RUN_ID}"
    
    if [ $SUCCESS -eq 0 ]; then
        echo "Estado: ✅ EXITOSO"
        echo "Sitio: https://cyb-c.github.io/reaprovechador/"
    else
        echo "Estado: ❌ FALLIDO"
        echo "Acción requerida: Revisar logs y corregir errores"
    fi
    
    echo "========================================="
}

# =============================================================================
# MAIN
# =============================================================================

main() {
    echo "========================================="
    echo "   AGENTE DE DESPLIEGUE - AstroWind      "
    echo "   GitHub Pages                          "
    echo "========================================="
    echo ""
    
    # Paso 1: Verificar autenticación
    check_gh_auth
    
    # Paso 2: Verificar workflow
    check_workflow
    
    # Paso 3: Ejecutar workflow
    RUN_ID=$(run_workflow)
    
    # Paso 4: Monitorear
    if monitor_workflow $RUN_ID; then
        generate_report $RUN_ID 0
        exit 0
    else
        generate_report $RUN_ID 1
        get_error_logs $RUN_ID
        
        echo ""
        log_error "========================================="
        log_error "   DESPLIEGUE FALLIDO                    "
        log_error "========================================="
        log_error ""
        log_error "Acciones recomendadas:"
        log_error "1. Revisar los logs de error arriba"
        log_error "2. Corregir los errores en el código"
        log_error "3. Volver a ejecutar este agente"
        log_error ""
        log_error "Para asistencia, proporciona los logs al asistente principal"
        log_error "========================================="
        
        exit 1
    fi
}

# Ejecutar main
main "$@"
