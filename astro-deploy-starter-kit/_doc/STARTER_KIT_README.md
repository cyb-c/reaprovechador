# Astro Deploy Starter Kit - Documentación

## 📋 ¿Qué es este Starter Kit?

Un paquete autocontenido que configura **cualquier proyecto Astro** con:

- ✅ Deploy automático a GitHub Pages
- ✅ Workflow de GitHub Actions
- ✅ Agente de despliegue
- ✅ Documentación completa
- ✅ Integración con Astro Docs Skill

---

## 🎯 Objetivo

Permitir que un agente de IA (o un usuario) pueda:

1. Partir de **cualquier plantilla Astro** (proporcionada vía URL)
2. Configurar el deploy automático a GitHub Pages
3. Tener toda la infraestructura lista para usar

---

## 📁 Estructura del Kit

```
astro-deploy-starter-kit/
│
├── README.md                    # Este archivo
├── init.sh                      # Script principal de inicialización
│
├── .github/
│   └── workflows/
│       ├── deploy.yml           # Workflow template
│       └── deploy-agent.sh      # Agente de despliegue
│
├── scripts/
│   ├── download-template.sh     # Descarga plantilla desde URL
│   ├── configure-repo.sh        # Configura URLs y paths
│   ├── verify-build.sh          # Verifica que el build funciona
│   └── utils.sh                 # Funciones utilitarias
│
├── templates/
│   ├── .gitignore.template      # .gitignore base para Astro
│   └── package.json.template    # Scripts básicos de Astro
│
└── _doc/
    ├── ASTRO_SKILL_PROMPT.md    # Guía de uso de prompts
    ├── DEPLOY_AGENT.md          # Doc del agente
    └── STARTER_KIT_README.md    # Este archivo
```

---

## 🚀 Cómo Usar este Starter Kit

### Opción A: Agente de IA en un IDE

El agente seguirá estos pasos:

1. **Saluda al usuario** y explica el propósito
2. **Solicita la URL** de la plantilla Astro
3. **Solicita información** del repositorio destino:
   - Owner del repo
   - Nombre del repo
   - Nombre del sitio (para SEO)
4. **Ejecuta `init.sh`** que:
   - Descarga la plantilla
   - Reemplaza placeholders
   - Copia workflows
   - Instala dependencias
   - Verifica el build
5. **Instruye al usuario** para el primer deploy

### Opción B: Usuario Manual

```bash
# 1. Copia este starter kit a tu proyecto
cp -r astro-deploy-starter-kit/* /tu/proyecto/

# 2. Ejecuta el script de inicialización
cd /tu/proyecto/
./init.sh

# 3. Sigue las instrucciones interactivas
```

---

## 📝 Paso a Paso del Script `init.sh`

### Paso 1: Información del Proyecto

El script solicita:
- URL de la plantilla Astro (ej: `https://github.com/arthelokyo/astrowind`)
- Owner de tu repositorio GitHub
- Nombre de tu repositorio
- Nombre del sitio web (para SEO)

### Paso 2: Descarga de la Plantilla

- Usa `npx degit` para descargar limpiamente
- Fallback a `git clone` si degit no está disponible
- Copia todos los archivos al directorio actual

### Paso 3: Configurando GitHub Pages

**Detección automática**:
- Busca `astro.config.mjs`, `astro.config.ts`, o `astro.config.js`
- Busca `src/config.yaml` o `src/config.yml`

**Configuración automática**:
- Agrega/modifica `site` y `base` en `astro.config.*`
- Actualiza `config.yaml` si existe

**Fallback manual**:
- Si no detecta los archivos, muestra instrucciones manuales

### Paso 4: Configurando Agente de Despliegue

- Copia `.github/workflows/deploy.yml`
- Copia `.github/workflows/deploy-agent.sh`
- Copia documentación a `_doc/`

### Paso 5: Instalando Dependencias

**Detección automática del package manager**:
- `pnpm-lock.yaml` → `pnpm install`
- `yarn.lock` → `yarn install`
- `bun.lockb` → `bun install`
- Default → `npm install`

### Paso 6: Verificando Build

- Ejecuta `npm run build` (o el comando del package manager)
- Reporta éxito o error
- Si falla, ofrece continuar o cancelar

### Paso 7: Configurando Astro-Docs Skill

**Intenta en este orden**:
1. Verifica si ya está instalada en `~/.qwen/skills/astro-docs/`
2. Intenta copiar desde `.skills/astro-docs-skill/` local
3. Intenta clonar desde GitHub
4. Si todo falla, muestra instrucciones manuales

---

## 🔧 Scripts Utilitarios

### `scripts/download-template.sh`

Descarga una plantilla Astro desde GitHub.

```bash
./scripts/download-template.sh https://github.com/usuario/plantilla
```

### `scripts/configure-repo.sh`

Configura las URLs para GitHub Pages.

```bash
./scripts/configure-repo.sh --owner cyb-c --repo mi-sitio --name "Mi Sitio"
```

### `scripts/verify-build.sh`

Verifica que el build funciona.

```bash
./scripts/verify-build.sh
```

### `scripts/utils.sh`

Funciones utilitarias para otros scripts.

```bash
source scripts/utils.sh
log_info "Mensaje de información"
log_success "Operación completada"
log_error "Error ocurrido"
```

---

## 🛠️ Personalización

### Modificar el Workflow

Edita `.github/workflows/deploy.yml` para:
- Cambiar la versión de Node.js
- Agregar pasos personalizados
- Modificar el directorio de build

### Modificar el Agente

Edita `.github/workflows/deploy-agent.sh` para:
- Cambiar los mensajes
- Agregar comandos personalizados
- Modificar la lógica de detección

### Agregar Scripts Propios

Agrega scripts al directorio `scripts/` y llámalos desde `init.sh`.

---

## 📚 Documentación Incluida

| Archivo | Propósito |
|---------|-----------|
| `_doc/ASTRO_SKILL_PROMPT.md` | Guía para usar la skill astro-docs |
| `_doc/DEPLOY_AGENT.md` | Documentación del agente de despliegue |
| `_doc/STARTER_KIT_README.md` | Este archivo |

---

## ❓ FAQ

### ¿Funciona con cualquier plantilla Astro?

Sí, el kit es agnóstico. Detecta automáticamente:
- El archivo de configuración de Astro
- El package manager usado
- La estructura de carpetas

### ¿Qué pasa si mi plantilla no usa `config.yaml`?

El kit configura directamente `astro.config.*`. `config.yaml` es opcional.

### ¿Puedo usar este kit en un proyecto existente?

Sí, pero ten cuidado:
- El script puede sobrescribir archivos existentes
- Revisa los cambios antes de hacer commit
- Haz backup primero

### ¿El deploy es realmente automático?

Sí, cada push a `main` dispara el workflow automáticamente.

### ¿Funciona en Windows?

El kit está diseñado para Linux/Mac (bash). Para Windows:
- Usa WSL (Windows Subsystem for Linux)
- O adapta los scripts a PowerShell

---

## 🎯 Checklist de Uso

- [ ] Copiar starter kit al proyecto
- [ ] Ejecutar `init.sh`
- [ ] Proporcionar URL de la plantilla
- [ ] Proporcionar datos del repositorio
- [ ] Verificar que la configuración es correcta
- [ ] Esperar a que termine la instalación
- [ ] Verificar que el build funciona
- [ ] Hacer el primer commit y push
- [ ] Monitorear el deploy en GitHub Actions

---

*Última actualización: 2026-03-28*
