# Guía de Despliegue en GitHub Pages

## Índice de Contenidos

1. [Requisitos Previos](#1-requisitos-previos)
2. [Configuración y Preparativos](#2-configuración-y-preparativos)
3. [Pasos de Despliegue](#3-pasos-de-despliegue)
4. [Información Necesaria del Usuario](#4-información-necesaria-del-usuario)
5. [Solución de Problemas Comunes](#5-solución-de-problemas-comunes)

---

## 1. Requisitos Previos

### 1.1. Cuenta y Herramientas

| Requisito | Descripción | Estado |
|-----------|-------------|--------|
| **Cuenta de GitHub** | Necesaria para crear repositorio y activar GitHub Pages | ❓ |
| **Git instalado** | Para subir el código al repositorio | ✅ Disponible |
| **Node.js** | v18.17.1+ o v20.3.0+ o v21.0.0+ | ✅ v24.11.1 instalado |
| **Proyecto AstroWind** | Build exitoso del sitio | ✅ En `/workspaces/reaprovechador/astrowind/` |

### 1.2. Verificación del Build

Antes de desplegar, debemos asegurar que el build funciona:

```bash
cd /workspaces/reaprovechador/astrowind
npm run build
```

**Criterio de éxito:**
- Se genera el directorio `dist/` sin errores
- El contenido de `dist/` es navegable localmente con `npm run preview`

---

## 2. Configuración y Preparativos

### 2.1. Configurar `astro.config.ts` para GitHub Pages

GitHub Pages sirve el sitio en una **subruta** (ej: `usuario.github.io/nombre-repo/`).

**Cambios necesarios en `astro.config.ts`:**

```typescript
export default defineConfig({
  output: 'static',
  
  // ⚠️ AGREGAR: URL base del sitio
  site: 'https://TU_USUARIO.github.io/TU_REPOSITORIO',
  base: '/TU_REPOSITORIO',  // ⚠️ Nombre del repositorio (sin .git)
  
  // ... resto de configuraciones
});
```

**Importante:**
- `site`: URL completa donde se alojará el sitio
- `base`: Debe coincidir exactamente con el nombre del repositorio
- Si el repositorio se llama `mi-web`, entonces `base: '/mi-web'`

### 2.2. Crear Workflow de GitHub Actions

Se debe crear el archivo `.github/workflows/deploy.yml`:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: 'pages'
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Build
        run: npm run build

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./dist

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### 2.3. Crear `.gitignore` Actualizado

Verificar que el `.gitignore` excluya:
```
node_modules/
dist/
.DS_Store
*.log
```

### 2.4. Crear `README.md` del Proyecto

Documento básico con:
- Nombre del proyecto
- Descripción
- Instrucciones de desarrollo local
- Link al sitio desplegado

---

## 3. Pasos de Despliegue

### Resumen del Proceso

```
┌─────────────────────────────────────────────────────────────┐
│  PASO 1  →  Crear repositorio en GitHub                     │
│  PASO 2  →  Configurar astro.config.ts (site + base)        │
│  PASO 3  →  Crear workflow de GitHub Actions                │
│  PASO 4  →  Inicializar Git y hacer primer commit           │
│  PASO 5  →  Subir código al repositorio                     │
│  PASO 6  →  Configurar GitHub Pages en settings             │
│  PASO 7  →  Esperar build automático y verificar despliegue │
└─────────────────────────────────────────────────────────────┘
```

### Paso 1: Crear Repositorio en GitHub

1. Ir a https://github.com/new
2. Nombre del repositorio: `[nombre-de-tu-web]`
3. Visibilidad: **Público** (requerido para GitHub Pages gratuito)
4. **NO** inicializar con README, .gitignore, o license (ya los tenemos)
5. Click en "Create repository"

### Paso 2: Configurar `astro.config.ts`

Editar el archivo con los valores del repositorio creado.

### Paso 3: Crear Workflow de GitHub Actions

Crear la carpeta y archivo:
```
.github/workflows/deploy.yml
```

### Paso 4: Inicializar Git y Commit

```bash
cd /workspaces/reaprovechador/astrowind
git init
git add .
git commit -m "Initial commit: AstroWind site ready for GitHub Pages"
```

### Paso 5: Subir Código al Repositorio

```bash
# Conectar con el repositorio remoto
git remote add origin https://github.com/TU_USUARIO/TU_REPOSITORIO.git

# Subir código
git branch -M main
git push -u origin main
```

### Paso 6: Configurar GitHub Pages

1. Ir al repositorio en GitHub
2. Click en **Settings** → **Pages**
3. En **Build and deployment**:
   - **Source**: GitHub Actions (recomendado)
4. Guardar cambios

### Paso 7: Verificar Despliegue

1. Ir a **Actions** en el repositorio
2. Ver el workflow "Deploy to GitHub Pages" ejecutándose
3. Esperar a que termine (≈ 2-5 minutos)
4. Click en el deploy exitoso para ver la URL
5. Visitar la URL para verificar el sitio

---

## 4. Información Necesaria del Usuario

Para completar el despliegue, necesito que proporciones:

### 4.1. Datos Obligatorios

| Dato | Descripción | Ejemplo |
|------|-------------|---------|
| **Usuario de GitHub** | Tu nombre de usuario en GitHub | `juanperez` |
| **Nombre del repositorio** | Cómo se llamará el repositorio | `mi-web-empresa` |
| **URL final deseada** | ¿User/Project o dominio personalizado? | `juanperez.github.io/mi-web-empresa` |

### 4.2. Decisiones de Configuración

| Decisión | Opciones | Recomendación |
|----------|----------|---------------|
| **Visibilidad del repo** | Público / Privado | Público (GitHub Pages gratis) |
| **Rama de despliegue** | `main` / `master` / otra | `main` (estándar actual) |
| **Build automático** | On push a main / Manual | On push (más cómodo) |

### 4.3. Accesos Necesarios

| Acceso | Para qué | Cómo proporcionar |
|--------|----------|-------------------|
| **Token de GitHub** (opcional) | Para push automático desde este entorno | PAT con scope `repo` |
| **Confirmación manual** | Si no hay token, tú haces el push | Te guío paso a paso |

### 4.4. Personalización del Sitio (Opcional pero Recomendado)

| Elemento | Descripción |
|----------|-------------|
| **Título del sitio** | Nombre que aparece en la pestaña del navegador |
| **Descripción** | Meta descripción para SEO |
| **Logo/Favicon** | Imagen corporativa o personal |
| **Redes sociales** | Links a Twitter, LinkedIn, GitHub, etc. |
| **Google Analytics** | ID de tracking si lo usas |

---

## 5. Solución de Problemas Comunes

### 5.1. Error: 404 en la URL del sitio

| Causa | Solución |
|-------|----------|
| `base` no configurado en `astro.config.ts` | Agregar `base: '/nombre-repo'` |
| Workflow falló | Revisar logs en Actions |
| GitHub Pages no activado | Settings → Pages → Activar |

### 5.2. Error: Build falla en GitHub Actions

| Causa | Solución |
|-------|----------|
| Node.js incompatible | Verificar `engines` en package.json |
| Dependencias faltan | Asegurar `npm ci` en workflow |
| Errores de TypeScript | Correr `npm run check` localmente |

### 5.3. Error: Imágenes o assets no cargan

| Causa | Solución |
|-------|----------|
| Rutas absolutas sin `base` | Astro maneja esto automáticamente con `base` configurado |
| Assets en `public/` con ruta hardcodeada | Usar rutas relativas o `import.meta.env.BASE_URL` |

### 5.4. Error: CSS no se aplica

| Causa | Solución |
|-------|----------|
| Cache del navegador | Hard refresh (Ctrl+F5) |
| Tailwind no genera clases | Verificar `content` en `tailwind.config.js` |

---

## Checklist Final

Antes de solicitar el despliegue, verifica:

- [ ] Tengo cuenta de GitHub activa
- [ ] Sé el nombre que quiero para el repositorio
- [ ] El build local funciona (`npm run build` sin errores)
- [ ] Tengo claro si quiero dominio personalizado o `user.github.io/repo`

---

## Próximos Pasos

Una vez proporciones la información de la **Sección 4**, procederé a:

1. ✅ Actualizar `astro.config.ts` con `site` y `base`
2. ✅ Crear `.github/workflows/deploy.yml`
3. ✅ Preparar el repositorio para push
4. ✅ Guiarte en el push final y configuración en GitHub

---

**Documento generado:** `(new Date()).toISOString()`  
**Proyecto:** AstroWind en `/workspaces/reaprovechador/astrowind/`  
**Skill de referencia:** `~/.qwen/skills/astro-docs.md`
