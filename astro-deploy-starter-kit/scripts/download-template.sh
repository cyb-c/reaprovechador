#!/bin/bash
# =============================================================================
# DOWNLOAD TEMPLATE - Descarga plantilla Astro desde GitHub
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

# =============================================================================
# MAIN
# =============================================================================

main() {
    local TEMPLATE_URL="$1"
    
    if [ -z "$TEMPLATE_URL" ]; then
        echo "Uso: $0 <URL_DE_PLANTILLA>"
        echo "Ejemplo: $0 https://github.com/arthelokyo/astrowind"
        exit 1
    fi
    
    # Validar URL
    if ! validate_github_url "$TEMPLATE_URL"; then
        exit 1
    fi
    
    log_info "Descargando plantilla desde: $TEMPLATE_URL"
    
    # Extraer owner y repo
    local TEMPLATE_OWNER=$(extract_github_owner "$TEMPLATE_URL")
    local TEMPLATE_REPO=$(extract_github_repo "$TEMPLATE_URL")
    
    log_info "Plantilla: $TEMPLATE_OWNER/$TEMPLATE_REPO"
    
    # Intentar con degit primero (más limpio)
    if command -v npx &> /dev/null; then
        log_info "Usando npx degit..."
        if npx degit "$TEMPLATE_OWNER/$TEMPLATE_REPO" . 2>/dev/null; then
            log_success "Plantilla descargada con degit"
            return 0
        fi
    fi
    
    # Fallback a git clone
    log_warning "degit no disponible, usando git clone..."
    
    local TEMP_DIR="temp_template_$$"
    
    if git clone "$TEMPLATE_URL" "$TEMP_DIR" 2>/dev/null; then
        # Copiar archivos
        cp -r "$TEMP_DIR"/* . 2>/dev/null || true
        cp -r "$TEMP_DIR"/.[!.]* . 2>/dev/null || true
        
        # Limpiar
        rm -rf "$TEMP_DIR"
        
        log_success "Plantilla descargada con git clone"
        return 0
    else
        log_error "No se pudo descargar la plantilla"
        log_error "Verifica la URL e intenta manualmente"
        return 1
    fi
}

# Ejecutar main con argumentos
main "$@"
