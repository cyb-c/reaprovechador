#!/bin/bash
# =============================================================================
# ASTRO DEPLOY STARTER KIT - Script de Inicialización
# =============================================================================
# Este script configura un proyecto Astro con deploy automático a GitHub Pages
# Funciona con cualquier plantilla Astro proporcionada por el usuario
# =============================================================================

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Directorios
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STARTER_KIT_DIR="$SCRIPT_DIR"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# =============================================================================
# FUNCIONES DE UTILIDAD
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

log_step() {
    echo -e "\n${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}\n"
}

print_header() {
    clear
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║     🚀 ASTRO DEPLOY STARTER KIT - Inicialización         ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
}

# =============================================================================
# DETECCIÓN AUTOMÁTICA
# =============================================================================

detect_package_manager() {
    if [ -f "pnpm-lock.yaml" ]; then
        echo "pnpm"
    elif [ -f "yarn.lock" ]; then
        echo "yarn"
    elif [ -f "bun.lockb" ]; then
        echo "bun"
    else
        echo "npm"
    fi
}

detect_astro_config() {
    if [ -f "astro.config.mjs" ]; then
        echo "astro.config.mjs"
    elif [ -f "astro.config.ts" ]; then
        echo "astro.config.ts"
    elif [ -f "astro.config.js" ]; then
        echo "astro.config.js"
    else
        echo ""
    fi
}

detect_config_yaml() {
    if [ -f "src/config.yaml" ]; then
        echo "src/config.yaml"
    elif [ -f "src/config.yml" ]; then
        echo "src/config.yml"
    else
        echo ""
    fi
}

# =============================================================================
# INPUT DEL USUARIO
# =============================================================================

get_user_input() {
    log_step "Paso 1: Información del Proyecto"
    
    echo ""
    echo "Por favor, proporciona la siguiente información:"
    echo ""
    
    # URL de la plantilla
    echo -n "📦 URL del repositorio de la plantilla Astro: "
    read TEMPLATE_URL
    
    # Validar URL básica
    if [[ ! "$TEMPLATE_URL" =~ ^https://github\.com/ ]]; then
        log_error "La URL debe ser de GitHub (ej: https://github.com/usuario/plantilla)"
        exit 1
    fi
    
    # Owner del repositorio
    echo -n "👤 Owner de tu repositorio GitHub (ej: cyb-c): "
    read REPO_OWNER
    
    # Nombre del repositorio
    echo -n "📁 Nombre de tu repositorio (ej: mi-sitio-web): "
    read REPO_NAME
    
    # Nombre del sitio (para SEO)
    echo -n "🏷️ Nombre del sitio web (para SEO, ej: Mi Sitio Web): "
    read SITE_NAME
    
    echo ""
    log_info "Resumen de la configuración:"
    echo "   Plantilla: $TEMPLATE_URL"
    echo "   Owner: $REPO_OWNER"
    echo "   Repo: $REPO_NAME"
    echo "   Sitio: $SITE_NAME"
    echo ""
    
    # Confirmar
    echo -n "¿Continuar con esta configuración? (s/n): "
    read CONFIRM
    
    if [[ "$CONFIRM" != "s" && "$CONFIRM" != "S" ]]; then
        log_error "Inicialización cancelada"
        exit 1
    fi
}

# =============================================================================
# DESCARGA DE LA PLANTILLA
# =============================================================================

download_template() {
    log_step "Paso 2: Descargando Plantilla Astro"
    
    # Extraer owner y repo de la URL
    TEMPLATE_OWNER=$(echo "$TEMPLATE_URL" | sed 's|https://github.com/||' | cut -d'/' -f1)
    TEMPLATE_REPO=$(echo "$TEMPLATE_URL" | sed 's|https://github.com/||' | cut -d'/' -f2)
    
    log_info "Plantilla: $TEMPLATE_OWNER/$TEMPLATE_REPO"
    
    # Verificar si ya existe un directorio src/
    if [ -d "src" ] && [ "$(ls -A src)" ]; then
        log_warning "El directorio src/ ya existe y no está vacío"
        echo -n "¿Deseas continuar? Esto puede causar conflictos (s/n): "
        read OVERWRITE
        
        if [[ "$OVERWRITE" != "s" && "$OVERWRITE" != "S" ]]; then
            log_error "Inicialización cancelada"
            exit 1
        fi
    fi
    
    # Usar degit para descargar (más limpio que git clone)
    log_info "Descargando plantilla..."
    
    if command -v npx &> /dev/null; then
        npx degit "$TEMPLATE_OWNER/$TEMPLATE_REPO" . 2>/dev/null || {
            log_warning "degit no disponible, usando git clone..."
            git clone "$TEMPLATE_URL" temp_template 2>/dev/null || {
                log_error "No se pudo descargar la plantilla"
                log_error "Verifica la URL e intenta manualmente"
                exit 1
            }
            cp -r temp_template/* . 2>/dev/null || true
            cp -r temp_template/.[!.]* . 2>/dev/null || true
            rm -rf temp_template
        }
    else
        log_error "npx no está disponible. Instala Node.js primero."
        exit 1
    fi
    
    log_success "Plantilla descargada"
}

# =============================================================================
# CONFIGURACIÓN DE GITHUB PAGES
# =============================================================================

configure_github_pages() {
    log_step "Paso 3: Configurando GitHub Pages"
    
    # Detectar archivo de configuración de Astro
    ASTRO_CONFIG=$(detect_astro_config)
    CONFIG_YAML=$(detect_config_yaml)
    
    log_info "Detectando configuración..."
    echo "   Astro config: ${ASTRO_CONFIG:-'No detectado'}"
    echo "   Config YAML: ${CONFIG_YAML:-'No detectado'}"
    echo ""
    
    CONFIGURED=false
    
    # Opción 1: Modificar astro.config.* directamente
    if [ -n "$ASTRO_CONFIG" ]; then
        log_info "Configurando $ASTRO_CONFIG para GitHub Pages..."
        
        # Crear backup
        cp "$ASTRO_CONFIG" "$ASTRO_CONFIG.backup"
        
        # Verificar si ya tiene site y base configurados
        if grep -q "site:" "$ASTRO_CONFIG" && grep -q "base:" "$ASTRO_CONFIG"; then
            log_warning "El archivo ya tiene site y base configurados"
            echo -n "¿Deseas actualizarlos? (s/n): "
            read UPDATE
            
            if [[ "$UPDATE" == "s" || "$UPDATE" == "S" ]]; then
                # Reemplazar valores existentes
                sed -i "s|site: ['\"]https://[^'\"]*['\"]|site: 'https://$REPO_OWNER.github.io/$REPO_NAME'|g" "$ASTRO_CONFIG"
                sed -i "s|base: ['\"][^'\"]*['\"]|base: '/$REPO_NAME'|g" "$ASTRO_CONFIG"
                log_success "site y base actualizados"
                CONFIGURED=true
            fi
        else
            # Agregar site y base después de output o integrations
            if grep -q "output:" "$ASTRO_CONFIG"; then
                # Insertar después de output
                sed -i "/output:/a\\  site: 'https://$REPO_OWNER.github.io/$REPO_NAME',\\n  base: '/$REPO_NAME'," "$ASTRO_CONFIG"
            elif grep -q "integrations:" "$ASTRO_CONFIG"; then
                # Insertar antes de integrations
                sed -i "/integrations:/i\\  site: 'https://$REPO_OWNER.github.io/$REPO_NAME',\\n  base: '/$REPO_NAME'," "$ASTRO_CONFIG"
            else
                # Insertar después de defineConfig
                sed -i "/defineConfig({/a\\  site: 'https://$REPO_OWNER.github.io/$REPO_NAME',\\n  base: '/$REPO_NAME'," "$ASTRO_CONFIG"
            fi
            log_success "site y base agregados"
            CONFIGURED=true
        fi
    fi
    
    # Opción 2: Modificar config.yaml si existe
    if [ -n "$CONFIG_YAML" ]; then
        log_info "Configurando $CONFIG_YAML..."
        
        cp "$CONFIG_YAML" "$CONFIG_YAML.backup"
        
        # Reemplazar valores en YAML
        sed -i "s|site: 'https://[^']*'|site: 'https://$REPO_OWNER.github.io/$REPO_NAME'|g" "$CONFIG_YAML"
        sed -i "s|site: \"https://[^\"]*\"|site: \"https://$REPO_OWNER.github.io/$REPO_NAME\"|g" "$CONFIG_YAML"
        sed -i "s|base: '/'|base: '/$REPO_NAME'|g" "$CONFIG_YAML"
        sed -i "s|name:.*|name: $SITE_NAME|g" "$CONFIG_YAML"
        
        log_success "Config YAML actualizado"
        CONFIGURED=true
    fi
    
    # Si no se pudo configurar automáticamente
    if [ "$CONFIGURED" = false ]; then
        log_warning "No se pudo configurar automáticamente"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  CONFIGURACIÓN MANUAL REQUERIDA"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "Edita tu archivo astro.config.* y agrega:"
        echo ""
        echo "  export default defineConfig({"
        echo "    site: 'https://$REPO_OWNER.github.io/$REPO_NAME',"
        echo "    base: '/$REPO_NAME',"
        echo "    // ... resto de configuración"
        echo "  });"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        
        echo -n "¿Has realizado los cambios manualmente? (s/n): "
        read MANUAL_DONE
        
        if [[ "$MANUAL_DONE" != "s" && "$MANUAL_DONE" != "S" ]]; then
            log_error "Configuración incompleta. El deploy puede fallar."
            log_info "Puedes editar el archivo y continuar después."
        fi
    fi
    
    # Limpiar backups
    rm -f "$ASTRO_CONFIG.backup" 2>/dev/null || true
    rm -f "$CONFIG_YAML.backup" 2>/dev/null || true
}

# =============================================================================
# CONFIGURACIÓN DEL DEPLOY AGENT
# =============================================================================

configure_deploy_agent() {
    log_step "Paso 4: Configurando Agente de Despliegue"
    
    # Crear directorio .github/workflows si no existe
    mkdir -p .github/workflows
    
    # Copiar workflow de deploy
    if [ -f "$STARTER_KIT_DIR/.github/workflows/deploy.yml" ]; then
        cp "$STARTER_KIT_DIR/.github/workflows/deploy.yml" .github/workflows/
        log_success "Workflow de deploy copiado"
    else
        log_warning "deploy.yml no encontrado en el starter kit"
    fi
    
    # Copiar script del agente
    if [ -f "$STARTER_KIT_DIR/.github/workflows/deploy-agent.sh" ]; then
        cp "$STARTER_KIT_DIR/.github/workflows/deploy-agent.sh" .github/workflows/
        chmod +x .github/workflows/deploy-agent.sh
        log_success "Deploy agent copiado"
    else
        log_warning "deploy-agent.sh no encontrado en el starter kit"
    fi
    
    # Copiar documentación
    if [ -d "$STARTER_KIT_DIR/_doc" ]; then
        mkdir -p _doc
        cp -r "$STARTER_KIT_DIR/_doc/"* _doc/ 2>/dev/null || true
        log_success "Documentación copiada"
    fi
}

# =============================================================================
# INSTALACIÓN DE DEPENDENCIAS
# =============================================================================

install_dependencies() {
    log_step "Paso 5: Instalando Dependencias"
    
    PACKAGE_MANAGER=$(detect_package_manager)
    log_info "Package manager detectado: $PACKAGE_MANAGER"
    
    case $PACKAGE_MANAGER in
        pnpm)
            pnpm install
            ;;
        yarn)
            yarn install
            ;;
        bun)
            bun install
            ;;
        *)
            npm install
            ;;
    esac
    
    log_success "Dependencias instaladas"
}

# =============================================================================
# VERIFICACIÓN DEL BUILD
# =============================================================================

verify_build() {
    log_step "Paso 6: Verificando Build"
    
    PACKAGE_MANAGER=$(detect_package_manager)
    
    log_info "Ejecutando build de prueba..."
    
    case $PACKAGE_MANAGER in
        pnpm)
            pnpm run build || BUILD_SUCCESS=false
            ;;
        yarn)
            yarn build || BUILD_SUCCESS=false
            ;;
        bun)
            bun run build || BUILD_SUCCESS=false
            ;;
        *)
            npm run build || BUILD_SUCCESS=false
            ;;
    esac
    
    if [ "$BUILD_SUCCESS" = false ]; then
        log_error "El build falló"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  POSIBLES CAUSAS:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  1. Dependencias no instaladas correctamente"
        echo "  2. Errores en el código de la plantilla"
        echo "  3. Configuración de astro.config.* incorrecta"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo -n "¿Deseas continuar de todos modos? (s/n): "
        read CONTINUE_ANYWAY
        
        if [[ "$CONTINUE_ANYWAY" != "s" && "$CONTINUE_ANYWAY" != "S" ]]; then
            log_error "Inicialización cancelada. Corrige los errores e intenta de nuevo."
            exit 1
        fi
    else
        log_success "Build completado exitosamente"
    fi
}

# =============================================================================
# SETUP DE LA SKILL ASTRO-DOCS
# =============================================================================

setup_astro_skill() {
    log_step "Paso 7: Configurando Skill Astro-Docs"
    
    SKILL_DIR="$HOME/.qwen/skills/astro-docs"
    LOCAL_SKILL="$STARTER_KIT_DIR/../.skills/astro-docs-skill"
    SKILL_REPO="https://github.com/asachs01/astro-docs-skill"
    
    # Verificar si ya está instalada
    if [ -d "$SKILL_DIR" ] && [ -f "$SKILL_DIR/SKILL.md" ]; then
        log_success "Skill astro-docs ya está instalada"
        return 0
    fi
    
    # Intentar copiar desde .skills/ local
    if [ -d "$LOCAL_SKILL" ]; then
        log_info "Copiando skill desde .skills/astro-docs-skill..."
        mkdir -p "$SKILL_DIR"
        cp -r "$LOCAL_SKILL"/* "$SKILL_DIR/" 2>/dev/null || {
            log_warning "No se pudo copiar desde .skills/"
        }
        
        if [ -f "$SKILL_DIR/SKILL.md" ]; then
            log_success "Skill copiada exitosamente"
            return 0
        fi
    fi
    
    # Intentar clonar desde GitHub
    log_info "Intentando clonar skill desde GitHub..."
    
    if command -v git &> /dev/null; then
        git clone "$SKILL_REPO" "$SKILL_DIR" 2>/dev/null || {
            log_warning "No se pudo clonar desde GitHub"
        }
        
        if [ -f "$SKILL_DIR/SKILL.md" ]; then
            log_success "Skill clonada exitosamente"
            return 0
        fi
    fi
    
    # Instrucciones manuales
    log_warning "No se pudo instalar la skill automáticamente"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  INSTALACIÓN MANUAL DE LA SKILL"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Ejecuta los siguientes comandos:"
    echo ""
    echo "  mkdir -p ~/.qwen/skills/astro-docs"
    echo "  git clone $SKILL_REPO ~/.qwen/skills/astro-docs"
    echo ""
    echo "O copia manualmente el archivo SKILL.md desde:"
    echo "  $SKILL_REPO"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# =============================================================================
# RESUMEN FINAL
# =============================================================================

print_summary() {
    log_step "Inicialización Completada"
    
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                    🎉 ¡LISTO! 🎉                          ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    echo "Tu proyecto Astro está configurado para deploy automático."
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  PRÓXIMOS PASOS:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "  1. Verifica que los cambios estén correctos:"
    echo "     git status"
    echo ""
    echo "  2. Haz el primer commit:"
    echo "     git add -A"
    echo "     git commit -m \"feat: inicializar proyecto Astro con deploy\""
    echo ""
    echo "  3. Sube a GitHub (esto dispara el deploy automático):"
    echo "     git push -u origin main"
    echo ""
    echo "  4. Monitorea el deploy:"
    echo "     https://github.com/$REPO_OWNER/$REPO_NAME/actions"
    echo ""
    echo "  5. Cuando termine (2-5 min), visita tu sitio:"
    echo "     https://$REPO_OWNER.github.io/$REPO_NAME/"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📚 Documentación disponible en:"
    echo "   _doc/DEPLOY_AGENT.md"
    echo "   _doc/ASTRO_SKILL_PROMPT.md"
    echo ""
}

# =============================================================================
# MAIN
# =============================================================================

main() {
    print_header
    
    echo "Este script configurará tu proyecto Astro con:"
    echo "  ✅ Deploy automático a GitHub Pages"
    echo "  ✅ Workflow de GitHub Actions"
    echo "  ✅ Agente de despliegue"
    echo "  ✅ Documentación completa"
    echo ""
    
    echo -n "¿Deseas continuar? (s/n): "
    read START_CONFIRM
    
    if [[ "$START_CONFIRM" != "s" && "$START_CONFIRM" != "S" ]]; then
        log_error "Inicialización cancelada"
        exit 1
    fi
    
    # Ejecutar pasos
    get_user_input
    download_template
    configure_github_pages
    configure_deploy_agent
    install_dependencies
    verify_build
    setup_astro_skill
    print_summary
    
    log_success "¡Inicialización completada!"
}

# Ejecutar main
main "$@"
