#!/bin/bash
# =============================================================================
# CONFIGURE REPO - Configura URLs para GitHub Pages
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

# Variables globales
REPO_OWNER=""
REPO_NAME=""
SITE_NAME=""
CONFIGURED=false

# =============================================================================
# PARSE ARGUMENTOS
# =============================================================================

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --owner)
                REPO_OWNER="$2"
                shift 2
                ;;
            --repo)
                REPO_NAME="$2"
                shift 2
                ;;
            --name)
                SITE_NAME="$2"
                shift 2
                ;;
            -h|--help)
                echo "Uso: $0 --owner <owner> --repo <repo> [--name <nombre>]"
                echo ""
                echo "Opciones:"
                echo "  --owner    Owner del repositorio GitHub"
                echo "  --repo     Nombre del repositorio"
                echo "  --name     Nombre del sitio (para SEO)"
                exit 0
                ;;
            *)
                log_error "Opción desconocida: $1"
                exit 1
                ;;
        esac
    done
}

# =============================================================================
# CONFIGURAR ASTRO.CONFIG.*
# =============================================================================

configure_astro_config() {
    local ASTRO_CONFIG=$(detect_astro_config)
    
    if [ -z "$ASTRO_CONFIG" ]; then
        log_warning "No se encontró astro.config.*"
        return 1
    fi
    
    log_info "Configurando $ASTRO_CONFIG..."
    
    # Backup
    backup_file "$ASTRO_CONFIG"
    
    # Verificar si ya tiene site y base
    if grep -q "site:" "$ASTRO_CONFIG" && grep -q "base:" "$ASTRO_CONFIG"; then
        log_warning "El archivo ya tiene site y base configurados"
        
        # Reemplazar valores existentes
        sed -i "s|site: ['\"]https://[^'\"]*['\"]|site: 'https://$REPO_OWNER.github.io/$REPO_NAME'|g" "$ASTRO_CONFIG"
        sed -i "s|base: ['\"][^'\"]*['\"]|base: '/$REPO_NAME'|g" "$ASTRO_CONFIG"
        
        log_success "site y base actualizados"
    else
        # Agregar site y base
        if grep -q "output:" "$ASTRO_CONFIG"; then
            sed -i "/output:/a\\  site: 'https://$REPO_OWNER.github.io/$REPO_NAME',\\n  base: '/$REPO_NAME'," "$ASTRO_CONFIG"
        elif grep -q "integrations:" "$ASTRO_CONFIG"; then
            sed -i "/integrations:/i\\  site: 'https://$REPO_OWNER.github.io/$REPO_NAME',\\n  base: '/$REPO_NAME'," "$ASTRO_CONFIG"
        else
            sed -i "/defineConfig({/a\\  site: 'https://$REPO_OWNER.github.io/$REPO_NAME',\\n  base: '/$REPO_NAME'," "$ASTRO_CONFIG"
        fi
        
        log_success "site y base agregados"
    fi
    
    CONFIGURED=true
    return 0
}

# =============================================================================
# CONFIGURAR CONFIG.YAML
# =============================================================================

configure_config_yaml() {
    local CONFIG_YAML=$(detect_config_yaml)
    
    if [ -z "$CONFIG_YAML" ]; then
        return 1
    fi
    
    log_info "Configurando $CONFIG_YAML..."
    
    # Backup
    backup_file "$CONFIG_YAML"
    
    # Reemplazar valores
    sed -i "s|site: 'https://[^']*'|site: 'https://$REPO_OWNER.github.io/$REPO_NAME'|g" "$CONFIG_YAML"
    sed -i "s|site: \"https://[^\"]*\"|site: \"https://$REPO_OWNER.github.io/$REPO_NAME\"|g" "$CONFIG_YAML"
    sed -i "s|base: '/'|base: '/$REPO_NAME'|g" "$CONFIG_YAML"
    
    if [ -n "$SITE_NAME" ]; then
        sed -i "s|name:.*|name: $SITE_NAME|g" "$CONFIG_YAML"
    fi
    
    log_success "Config YAML actualizado"
    CONFIGURED=true
    return 0
}

# =============================================================================
# MOSTRAR INSTRUCCIONES MANUALES
# =============================================================================

show_manual_instructions() {
    echo ""
    print_box "CONFIGURACIÓN MANUAL REQUERIDA

Edita tu archivo astro.config.* y agrega:

  export default defineConfig({
    site: 'https://$REPO_OWNER.github.io/$REPO_NAME',
    base: '/$REPO_NAME',
    // ... resto de configuración
  });"
}

# =============================================================================
# MAIN
# =============================================================================

main() {
    parse_args "$@"
    
    log_step "Configurando GitHub Pages"
    
    # Validar argumentos requeridos
    if [ -z "$REPO_OWNER" ] || [ -z "$REPO_NAME" ]; then
        log_error "Se requiere --owner y --repo"
        echo "Uso: $0 --owner <owner> --repo <repo> [--name <nombre>]"
        exit 1
    fi
    
    log_info "Owner: $REPO_OWNER"
    log_info "Repo: $REPO_NAME"
    log_info "Sitio: ${SITE_NAME:-'No especificado'}"
    
    # Intentar configurar automáticamente
    configure_astro_config || true
    configure_config_yaml || true
    
    # Si no se pudo configurar
    if [ "$CONFIGURED" = false ]; then
        log_warning "No se pudo configurar automáticamente"
        show_manual_instructions
    fi
    
    # Limpiar backups
    cleanup_backups
    
    log_success "Configuración completada"
}

# Ejecutar main
main "$@"
