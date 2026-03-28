# 🚀 Astro Deploy Starter Kit

> Configura cualquier proyecto Astro con deploy automático a GitHub Pages

[![Astro](https://img.shields.io/badge/Astro-5.x-blue.svg)](https://astro.build)
[![GitHub Pages](https://img.shields.io/badge/GitHub_Pages-Automático-black.svg)](https://pages.github.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📋 ¿Qué es esto?

Un **starter kit autocontenido** que permite:

1. **Inicializar cualquier proyecto Astro** desde una plantilla (URL de GitHub)
2. **Configurar deploy automático** a GitHub Pages
3. **Tener toda la infraestructura** lista para usar

Diseñado para ser **ejecutado por un agente de IA** en un IDE.

---

## ⚡ Inicio Rápido

### Para Agentes de IA

```bash
# 1. El agente clona/copias este starter kit
# 2. Ejecuta el script de inicialización
./init.sh

# 3. Sigue las instrucciones interactivas
#    - Ingresa URL de la plantilla Astro
#    - Ingresa datos del repositorio
#    - Espera a que termine la instalación

# 4. Hace el primer deploy
git add -A
git commit -m "feat: inicializar proyecto Astro"
git push -u origin main
```

### Para Usuarios Manuales

```bash
# Copia el contenido de este directorio a tu proyecto
cp -r astro-deploy-starter-kit/* /tu/proyecto/

# Ejecuta la inicialización
cd /tu/proyecto/
./init.sh
```

---

## 📁 Estructura

```
astro-deploy-starter-kit/
│
├── README.md                    # Este archivo
├── init.sh                      # Script principal de inicialización ⭐
│
├── .github/
│   └── workflows/
│       ├── deploy.yml           # Workflow de GitHub Actions
│       └── deploy-agent.sh      # Agente de despliegue
│
├── scripts/                     # Scripts utilitarios
│   ├── download-template.sh
│   ├── configure-repo.sh
│   ├── verify-build.sh
│   └── utils.sh
│
├── templates/                   # Templates base
│   ├── .gitignore.template
│   └── package.json.template
│
└── _doc/                        # Documentación
    ├── ASTRO_SKILL_PROMPT.md
    ├── DEPLOY_AGENT.md
    └── STARTER_KIT_README.md
```

---

## 🎯 Características

| Característica | Descripción |
|----------------|-------------|
| **Agnóstico** | Funciona con cualquier plantilla Astro |
| **Automático** | Deploy con cada push a `main` |
| **Detecta automáticamente** | Package manager, config files, estructura |
| **Interactivo** | Solicita información al usuario paso a paso |
| **Documentado** | Incluye guías completas en `_doc/` |

---

## 🔧 Requisitos Previos

- **Node.js** 18.x o superior
- **Git** instalado
- **GitHub CLI** (`gh`) recomendado
- **Cuenta de GitHub** con repositorio creado

---

## 📖 Uso Detallado

### Paso 1: Ejecutar `init.sh`

```bash
./init.sh
```

El script te solicitará:

1. **URL de la plantilla Astro**
   - Ej: `https://github.com/arthelokyo/astrowind`
   - Debe ser un repositorio público de GitHub

2. **Owner de tu repositorio**
   - Tu usuario de GitHub
   - Ej: `cyb-c`

3. **Nombre de tu repositorio**
   - El nombre del repo donde harás deploy
   - Ej: `mi-sitio-web`

4. **Nombre del sitio**
   - Para SEO y metadatos
   - Ej: `Mi Sitio Web`

### Paso 2: Esperar la Instalación

El script hará automáticamente:

- ✅ Descarga la plantilla desde GitHub
- ✅ Configura `astro.config.*` para GitHub Pages
- ✅ Copia workflows de GitHub Actions
- ✅ Instala dependencias (npm/pnpm/yarn)
- ✅ Verifica que el build funciona
- ✅ Configura Astro-Docs Skill (opcional)

### Paso 3: Primer Deploy

```bash
# Verifica los cambios
git status

# Haz commit y push
git add -A
git commit -m "feat: inicializar proyecto Astro con deploy"
git push -u origin main
```

### Paso 4: Monitorear el Deploy

1. Ve a: `https://github.com/{owner}/{repo}/actions`
2. Click en el workflow más reciente
3. Espera 2-5 minutos
4. Visita: `https://{owner}.github.io/{repo}/`

---

## 🛠️ Scripts Disponibles

### `init.sh`

Script principal que orquesta toda la inicialización.

```bash
./init.sh
```

### `scripts/download-template.sh`

Descarga una plantilla desde GitHub.

```bash
./scripts/download-template.sh https://github.com/usuario/plantilla
```

### `scripts/configure-repo.sh`

Configura URLs para GitHub Pages.

```bash
./scripts/configure-repo.sh --owner cyb-c --repo mi-sitio --name "Mi Sitio"
```

### `scripts/verify-build.sh`

Verifica que el build funciona.

```bash
./scripts/verify-build.sh
```

---

## 📚 Documentación

| Archivo | Descripción |
|---------|-------------|
| [`_doc/ASTRO_SKILL_PROMPT.md`](_doc/ASTRO_SKILL_PROMPT.md) | Guía para usar la skill astro-docs |
| [`_doc/DEPLOY_AGENT.md`](_doc/DEPLOY_AGENT.md) | Documentación del agente de despliegue |
| [`_doc/STARTER_KIT_README.md`](_doc/STARTER_KIT_README.md) | Documentación completa del starter kit |

---

## 🔍 Solución de Problemas

### El CSS no carga

Verifica que `astro.config.*` tenga:

```javascript
export default defineConfig({
  site: 'https://{owner}.github.io/{repo}',
  base: '/{repo}',  // ← Debe coincidir con el nombre del repo
});
```

### Build falla

```bash
# Ejecuta build localmente para ver el error
npm run build

# O con el package manager que uses
pnpm run build
yarn build
```

### Workflow no se ejecuta

1. Verifica que `.github/workflows/deploy.yml` existe
2. Verifica que el push fue a la rama `main`
3. Revisa: `https://github.com/{owner}/{repo}/actions`

### Error 403 en el agente

Normal en GitHub Codespaces. El deploy automático por push SÍ funciona.

---

## 🎯 Ejemplos de Uso

### Ejemplo 1: AstroWind

```bash
./init.sh
# URL: https://github.com/arthelokyo/astrowind
# Owner: cyb-c
# Repo: reaprovechador
# Sitio: Reaprovechador
```

### Ejemplo 2: Starlight

```bash
./init.sh
# URL: https://github.com/withastro/starlight
# Owner: tu-usuario
# Repo: docs
# Sitio: Mi Documentación
```

### Ejemplo 3: Plantilla Personalizada

```bash
./init.sh
# URL: https://github.com/tu-usuario/tu-plantilla
# Owner: tu-usuario
# Repo: mi-sitio
# Sitio: Mi Sitio Web
```

---

## 📝 License

MIT - Ver [LICENSE](LICENSE) para más detalles.

---

## 🙏 Créditos

- **Astro Docs Skill**: https://github.com/asachs01/astro-docs-skill
- **Astro**: https://astro.build
- **GitHub Pages**: https://pages.github.com

---

*Última actualización: 2026-03-28*
