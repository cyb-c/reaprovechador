# Blueprint Arquitectónico + Starter Kit - Comprensión del Requerimiento

## Índice de Contenidos

1. [Objetivo Principal](#1-objetivo-principal)
2. [Qué He Entendido](#2-qué-he-entendido)
3. [Componentes del Starter Kit](#3-componentes-del-starter-kit)
4. [Flujo de Ejecución del Agente](#4-flujo-de-ejecución-del-agente)
5. [Estructura de Directorios Propuesta](#5-estructura-de-directorios-propuesta)
6. [Agnosticismo de la Plantilla Astro](#6-agnosticismo-de-la-plantilla-astro)
7. [Documentación Incluida](#7-documentación-incluida)
8. [Preguntas de Aclaración](#8-preguntas-de-aclaración)

---

## 1. Objetivo Principal

Crear un **kit reutilizable y agnóstico** que permita:
- Replicar en cualquier repositorio futuro todo lo trabajado en este proyecto
- Que un agente de IA en un IDE pueda ejecutar el proceso completo
- Que funcione con **cualquier plantilla Astro** proporcionada por el usuario

---

## 2. Qué He Entendido

### 2.1. Propósito del Starter Kit

Debo generar un **paquete autocontenido** en un directorio independiente que incluya:

1. **Agente de despliegue** configurado para GitHub Pages
2. **Workflow de GitHub Actions** listo para usar
3. **Scripts de inicialización** que:
   - Soliciten al usuario la URL de la plantilla Astro
   - Descarguen e instalen dicha plantilla
   - Configuren las rutas para GitHub Pages
   - Activen el deploy automático

### 2.2. Características Clave

| Característica | Descripción |
|----------------|-------------|
| **Agnóstico** | No ligado a AstroWind ni ninguna plantilla específica |
| **Reutilizable** | Copiable a cualquier repositorio nuevo |
| **Ejecutable por IA** | Un agente en un IDE puede correrlo paso a paso |
| **Configurable** | El usuario proporciona la URL de la plantilla |
| **Autocontenido** | Todo lo necesario está en el kit |

### 2.3. Lo que NO debe hacer

- ❌ No debe incluir una plantilla Astro específica (como AstroWind)
- ❌ No debe tener rutas hardcodeadas a este repositorio (`cyb-c/reaprovechador`)
- ❌ No debe depender de configuraciones específicas del proyecto actual

---

## 3. Componentes del Starter Kit

### 3.1. Scripts de Inicialización

```
starter-kit/
├── init.sh (o init.ps1 para Windows)
├── scripts/
│   ├── download-template.sh
│   ├── configure-github-pages.sh
│   └── setup-deploy-agent.sh
```

**Funciones:**
- `init.sh`: Script principal que orquesta todo
- `download-template.sh`: Descarga la plantilla desde la URL proporcionada
- `configure-github-pages.sh`: Actualiza `config.yaml` con las URLs correctas
- `setup-deploy-agent.sh`: Copia y configura el workflow de deploy

### 3.2. Agente de Despliegue

```
.github/
└── workflows/
    ├── deploy.yml (template con placeholders)
    └── deploy-agent.sh
```

**Características:**
- Workflow genérico que funciona con cualquier proyecto Astro
- Script del agente con mensajes configurables
- Comandos de monitoreo compatibles con cualquier repo

### 3.3. Configuración Base

```
src/
└── config.yaml.template ( plantilla con variables )
```

**Variables a reemplazar:**
- `{{REPO_OWNER}}`: Dueño del repositorio (ej: `cyb-c`)
- `{{REPO_NAME}}`: Nombre del repositorio (ej: `mi-sitio-web`)
- `{{SITE_NAME}}`: Nombre del sitio (ej: `Mi Sitio Web`)

### 3.4. Documentación

```
_doc/
├── ASTRO_SKILL_PROMPT.md
├── DEPLOY_AGENT.md
└── STARTER_KIT_README.md
```

---

## 4. Flujo de Ejecución del Agente

```
┌─────────────────────────────────────────────────────────────────┐
│  AGENTE DE IA EN EL IDE                                         │
│                                                                 │
│  1. Saluda al usuario y explica el propósito                    │
│     "Voy a configurar tu proyecto Astro con deploy automático"  │
│                                                                 │
│  2. Solicita la URL de la plantilla Astro                       │
│     "Proporciona la URL del repositorio de la plantilla:"       │
│     Ej: https://github.com/arthelokyo/astrowind                 │
│                                                                 │
│  3. Solicita información del repositorio destino                │
│     - Owner: cyb-c                                              │
│     - Nombre del repo: mi-sitio-web                             │
│     - Nombre del sitio: Mi Sitio Web                            │
│                                                                 │
│  4. Ejecuta init.sh                                             │
│     - Descarga la plantilla                                     │
│     - Reemplaza placeholders en config.yaml                     │
│     - Copia workflows de GitHub Actions                         │
│     - Instala dependencias (npm install)                        │
│                                                                 │
│  5. Verifica que el build funciona                              │
│     - Ejecuta npm run build                                     │
│     - Reporta éxito o error                                     │
│                                                                 │
│  6. Instruye al usuario para el primer deploy                   │
│     - git add -A && git commit -m "initial" && git push         │
│     - El deploy automático se activará                          │
│                                                                 │
│  7. Proporciona URLs de monitoreo                               │
│     - GitHub Actions: https://github.com/.../actions            │
│     - Sitio: https://{{owner}}.github.io/{{repo}}/              │
└─────────────────────────────────────────────────────────────────┘
```

---

## 5. Estructura de Directorios Propuesta

```
astro-deploy-starter-kit/
│
├── README.md                    # Instrucciones de uso del kit
├── init.sh                      # Script principal de inicialización
├── init.ps1                     # Versión Windows PowerShell
│
├── .github/
│   └── workflows/
│       ├── deploy.yml           # Workflow template (con placeholders)
│       └── deploy-agent.sh      # Agente de despliegue agnóstico
│
├── src/
│   └── config.yaml.template     # Template con {{VARIABLES}}
│
├── scripts/
│   ├── download-template.sh     # Descarga plantilla desde URL
│   ├── configure-repo.sh        # Configura URLs y paths
│   ├── verify-build.sh          # Verifica que npm run build funciona
│   └── utils.sh                 # Funciones utilitarias
│
├── _doc/
│   ├── ASTRO_SKILL_PROMPT.md    # Guía de uso de prompts base
│   ├── DEPLOY_AGENT.md          # Doc del agente (agnóstica)
│   └── STARTER_KIT_README.md    # Doc específica del starter kit
│
├── templates/
│   ├── .gitignore.template      # .gitignore base para Astro
│   └── package.json.template    # Scripts básicos de Astro
│
└── temp/
    └── (archivos temporales de inicialización)
```

---

## 6. Agnosticismo de la Plantilla Astro

### 6.1. Lo que el Kit NO Asume

| Suposición | Por qué evitarla |
|------------|------------------|
| Estructura específica de carpetas | Cada plantilla puede organizar `src/` diferente |
| Nombre de archivos específico | `astro.config.mjs` vs `astro.config.ts` |
| Package manager específico | npm, pnpm, yarn, bun |
| Existencia de `config.yaml` | Algunas plantillas no lo usan |

### 6.2. Lo que el Kit SÍ Debe Hacer

1. **Detectar automáticamente**:
   - Si existe `astro.config.*` (cualquier extensión)
   - Si existe `src/config.yaml` o similar
   - Qué package manager usa (package-lock.json, pnpm-lock.yaml, etc.)

2. **Proporcionar instrucciones manuales** si la detección falla:
   ```
   ⚠️ No se pudo detectar automáticamente la configuración.
   Por favor, verifica manualmente:
   
   1. astro.config.mjs/ts debe tener:
      - site: 'https://{{owner}}.github.io/{{repo}}'
      - base: '/{{repo}}'
   
   2. El workflow .github/workflows/deploy.yml debe existir
   ```

3. **Usar patrones genéricos**:
   ```bash
   # En lugar de:
   npm run build
   
   # Preferir (detectar automáticamente):
   if [ -f "pnpm-lock.yaml" ]; then
     pnpm run build
   elif [ -f "yarn.lock" ]; then
     yarn build
   elif [ -f "bun.lockb" ]; then
     bun run build
   else
     npm run build
   fi
   ```

---

## 7. Documentación Incluida

### 7.1. `_doc/ASTRO_SKILL_PROMPT.md`

**Contenido actual** (del proyecto) que se mantendrá:
- Instrucciones base para usar la skill astro-docs
- Ejemplos de prompts para diferentes tipos de proyectos
- Referencia a la skill `~/.qwen/skills/astro-docs.md`

**Adaptaciones**:
- Hacer los ejemplos genéricos (no mencionar AstroWind específicamente)
- Incluir ejemplo de "proyecto desde plantilla personalizada"

### 7.2. `_doc/DEPLOY_AGENT.md`

**Secciones requeridas**:
1. Propósito (agnóstico)
2. Requisitos previos (cualquier proyecto Astro)
3. Flujo de inicialización (con URL de plantilla)
4. Verificación del estado (comandos genéricos)
5. Solución de problemas (comunes a cualquier plantilla Astro)
6. Referencias (links a docs oficiales de Astro)

### 7.3. `_doc/STARTER_KIT_README.md` (NUEVO)

**Contenido**:
- Qué es este starter kit
- Cómo usarlo (paso a paso)
- Qué hace el script `init.sh`
- Cómo personalizar para necesidades específicas
- FAQ

---

## 8. Preguntas de Aclaración

Antes de proceder con la implementación, necesito confirmar:

### 8.1. Ubicación del Starter Kit

**Opción A**: Dentro del repositorio actual (como subdirectorio)
```
/workspaces/reaprovechador/
├── astro-deploy-starter-kit/  ← NUEVO
├── src/
├── .github/
└── ...
```

**Opción B**: Repositorio separado (más limpio para reutilización)
```
/workspaces/astro-deploy-starter-kit/  ← NUEVO REPOSITORIO
├── .github/
├── scripts/
├── _doc/
└── ...
```

**Opción C**: Subdirectorio con intención de extraer después
```
/workspaces/reaprovechador/
├── starter-kit/  ← Se crea aquí, luego se mueve a repo separado
└── ...
```

**¿Cuál prefieres?**

### 8.2. Nivel de Automatización del Script `init.sh`

**Nivel 1**: Semi-automático (pide input al usuario)
```bash
./init.sh
# Pregunta interactivamente:
# - URL de la plantilla
# - Owner del repo
# - Nombre del repo
```

**Nivel 2**: Por argumentos (más scripteable)
```bash
./init.sh --template https://github.com/... --owner cyb-c --repo mi-sitio
```

**Nivel 3**: Híbrido (argumentos opcionales, pide lo que falta)
```bash
./init.sh --template https://github.com/...
# Pide solo lo que no se proporcionó
```

**¿Cuál prefieres?**

### 8.3. Soporte de Sistema Operativo

- ¿Solo Linux/Mac (bash scripts)?
- ¿Incluir también PowerShell para Windows (`.ps1`)?

### 8.4. Plantillas de Configuración

Para `config.yaml.template`, algunas plantillas Astro:
- **No usan** `config.yaml` (usan directamente `astro.config.*`)
- **Algunas usan** archivos YAML para contenido

**Pregunta**: ¿El kit debe:
- **Opción A**: Solo funcionar con plantillas que usan `config.yaml`
- **Opción B**: Detectar y modificar `astro.config.*` directamente
- **Opción C**: Proporcionar instrucciones manuales si no detecta el patrón

**¿Cuál prefieres?**

### 8.5. Registro de la Skill Astro-Docs

El kit asume que la skill `astro-docs` ya está registrada en `~/.qwen/skills/`.

**Pregunta**: ¿El script `init.sh` debe:
- **Opción A**: Asumir que ya está instalada
- **Opción B**: Intentar copiarla desde `.skills/astro-docs-skill/` si existe
- **Opción C**: Proporcionar instrucciones para instalarla manualmente

**¿Cuál prefieres?**

---

## Resumen de lo que Voy a Crear (una vez aclarado lo anterior)

| Archivo | Estado |
|---------|--------|
| `astro-deploy-starter-kit/README.md` | ✏️ Por crear |
| `astro-deploy-starter-kit/init.sh` | ✏️ Por crear |
| `astro-deploy-starter-kit/.github/workflows/deploy.yml` | ✏️ Por crear (template) |
| `astro-deploy-starter-kit/.github/workflows/deploy-agent.sh` | ✏️ Por crear (agnóstico) |
| `astro-deploy-starter-kit/src/config.yaml.template` | ✏️ Por crear |
| `astro-deploy-starter-kit/scripts/*` | ✏️ Por crear |
| `astro-deploy-starter-kit/_doc/ASTRO_SKILL_PROMPT.md` | 📝 Adaptar del actual |
| `astro-deploy-starter-kit/_doc/DEPLOY_AGENT.md` | 📝 Adaptar del actual |
| `astro-deploy-starter-kit/_doc/STARTER_KIT_README.md` | ✏️ Por crear |

---

## Próximo Paso

**Por favor, responde las preguntas de la sección 8** para que pueda proceder con la implementación correcta.

Una vez aclarado, generaré todo el starter kit en el directorio que indiques.
