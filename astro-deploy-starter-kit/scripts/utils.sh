#!/bin/bash
# =============================================================================
# UTILS - Funciones utilitarias para scripts del Starter Kit
# =============================================================================

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# =============================================================================
# FUNCIONES DE LOG
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

# =============================================================================
# DETECCIÓN DE HERRAMIENTAS
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

check_command() {
    if ! command -v "$1" &> /dev/null; then
        log_error "$1 no está instalado"
        return 1
    fi
    return 0
}

# =============================================================================
# VALIDACIONES
# =============================================================================

validate_github_url() {
    local url="$1"
    if [[ ! "$url" =~ ^https://github\.com/ ]]; then
        log_error "La URL debe ser de GitHub (ej: https://github.com/usuario/plantilla)"
        return 1
    fi
    return 0
}

validate_repo_name() {
    local name="$1"
    if [[ ! "$name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        log_error "El nombre del repo solo puede contener letras, números, guiones y guiones bajos"
        return 1
    fi
    return 0
}

# =============================================================================
# UTILIDADES DE GIT
# =============================================================================

get_git_owner() {
    git remote get-url origin 2>/dev/null | sed 's|.*github.com[/:]||' | cut -d'/' -f1
}

get_git_repo() {
    git remote get-url origin 2>/dev/null | sed 's|.*github.com[/:]||' | cut -d'/' -f2 | sed 's/\.git$//'
}

is_git_repo() {
    if [ -d ".git" ]; then
        return 0
    fi
    return 1
}

# =============================================================================
# UTILIDADES DE GITHUB CLI
# =============================================================================

is_gh_authenticated() {
    if gh auth status &> /dev/null; then
        return 0
    fi
    return 1
}

get_gh_owner() {
    gh api user --jq '.login' 2>/dev/null
}

# =============================================================================
# UTILIDADES DE ARCHIVOS
# =============================================================================

file_exists() {
    if [ -f "$1" ]; then
        return 0
    fi
    return 1
}

dir_exists() {
    if [ -d "$1" ]; then
        return 0
    fi
    return 1
}

is_dir_empty() {
    if [ -d "$1" ] && [ -z "$(ls -A "$1")" ]; then
        return 0
    fi
    return 1
}

backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        cp "$file" "$file.backup"
        log_info "Backup creado: $file.backup"
    fi
}

restore_backup() {
    local file="$1"
    if [ -f "$file.backup" ]; then
        mv "$file.backup" "$file"
        log_info "Backup restaurado: $file"
    fi
}

cleanup_backups() {
    find . -name "*.backup" -type f -delete 2>/dev/null
}

# =============================================================================
# UTILIDADES DE STRING
# =============================================================================

slugify() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-'
}

extract_github_owner() {
    echo "$1" | sed 's|https://github.com/||' | cut -d'/' -f1
}

extract_github_repo() {
    echo "$1" | sed 's|https://github.com/||' | cut -d'/' -f2
}

# =============================================================================
# EJECUCIÓN DE COMANDOS
# =============================================================================

run_command() {
    local cmd="$1"
    local description="${2:-Ejecutando comando}"
    
    log_info "$description..."
    
    if eval "$cmd"; then
        log_success "Completado"
        return 0
    else
        log_error "Falló: $cmd"
        return 1
    fi
}

run_silent() {
    local cmd="$1"
    eval "$cmd" &> /dev/null
    return $?
}

# =============================================================================
# MENSAJES INTERACTIVOS
# =============================================================================

confirm_action() {
    local message="${1:-¿Estás seguro?}"
    echo -n "$message (s/n): "
    read response
    
    if [[ "$response" == "s" || "$response" == "S" ]]; then
        return 0
    fi
    return 1
}

prompt_input() {
    local prompt="$1"
    local default="$2"
    
    if [ -n "$default" ]; then
        echo -n "$prompt [$default]: "
    else
        echo -n "$prompt: "
    fi
    
    read input
    
    if [ -z "$input" ] && [ -n "$default" ]; then
        echo "$default"
    else
        echo "$input"
    fi
}

# =============================================================================
# HEADER Y FORMATEO
# =============================================================================

print_header() {
    local title="$1"
    clear
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    printf "║     %-50s║\n" "$title"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
}

print_section() {
    local title="$1"
    echo -e "\n${CYAN}──────────────────────────────────────────────────────${NC}"
    echo -e "${CYAN}  $title${NC}"
    echo -e "${CYAN}──────────────────────────────────────────────────────${NC}\n"
}

print_box() {
    local content="$1"
    echo ""
    echo "┌──────────────────────────────────────────────────────┐"
    while IFS= read -r line; do
        printf "│ %-53s│\n" "$line"
    done <<< "$content"
    echo "└──────────────────────────────────────────────────────┘"
    echo ""
}
