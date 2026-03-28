#!/bin/bash
# =============================================================================
# VERIFY BUILD - Verifica que el build de Astro funciona
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

# =============================================================================
# DETECTAR PACKAGE MANAGER
# =============================================================================

get_build_command() {
    local pm=$(detect_package_manager)
    
    case $pm in
        pnpm)
            echo "pnpm run build"
            ;;
        yarn)
            echo "yarn build"
            ;;
        bun)
            echo "bun run build"
            ;;
        *)
            echo "npm run build"
            ;;
    esac
}

# =============================================================================
# VERIFICAR BUILD
# =============================================================================

verify_build() {
    local BUILD_CMD=$(get_build_command)
    
    log_info "Ejecutando: $BUILD_CMD"
    
    # Ejecutar build
    if eval "$BUILD_CMD"; then
        log_success "Build completado exitosamente"
        
        # Verificar que se generó el directorio dist/
        if [ -d "dist" ]; then
            log_success "Directorio dist/ generado"
            log_info "Archivos generados: $(find dist -type f | wc -l)"
            return 0
        else
            log_warning "El directorio dist/ no se generó"
            return 1
        fi
    else
        log_error "El build falló"
        return 1
    fi
}

# =============================================================================
# MOSTRAR POSIBLES CAUSAS DE ERROR
# =============================================================================

show_error_help() {
    echo ""
    print_box "POSIBLES CAUSAS DEL ERROR:

1. Dependencias no instaladas
   Solución: npm install (o pnpm install, yarn install)

2. Errores en el código de la plantilla
   Solución: Revisa los archivos .astro en busca de errores

3. Configuración de astro.config.* incorrecta
   Solución: Verifica que site y base estén correctos

4. Versión de Node.js incompatible
   Solución: Usa Node.js 18.x o superior

5. Memoria insuficiente
   Solución: Intenta con NODE_OPTIONS='--max-old-space-size=4096'"
}

# =============================================================================
# MAIN
# =============================================================================

main() {
    log_step "Verificando Build"
    
    # Verificar que existe package.json
    if [ ! -f "package.json" ]; then
        log_error "No se encontró package.json"
        log_error "Asegúrate de estar en un proyecto Astro"
        exit 1
    fi
    
    # Verificar que existe el script build
    if ! grep -q '"build"' package.json; then
        log_error "No se encontró el script 'build' en package.json"
        exit 1
    fi
    
    # Ejecutar verificación
    if verify_build; then
        log_success "¡Todo correcto! El proyecto está listo para deploy"
        exit 0
    else
        show_error_help
        exit 1
    fi
}

# Ejecutar main
main "$@"
