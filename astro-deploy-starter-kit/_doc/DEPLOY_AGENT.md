# Agente de Despliegue - GitHub Pages (Astro)

## 📋 Propósito

Automatizar y monitorear el despliegue de cualquier proyecto Astro a GitHub Pages.

---

## 📁 Archivos Clave

| Archivo | Propósito |
|---------|-----------|
| `.github/workflows/deploy-agent.sh` | Script informativo del agente |
| `.github/workflows/deploy.yml` | Workflow automático de GitHub Actions |
| `astro.config.*` | Configuración de Astro (site + base) |
| `_doc/DEPLOY_AGENT.md` | Esta documentación |

---

## ⚠️ Limitación en GitHub Codespaces

El token `GITHUB_TOKEN` en Codespaces **NO tiene permisos** para ejecutar workflows manualmente por razones de seguridad.

### ¿Qué significa esto?

- ❌ **No funciona**: Ejecución manual con `./deploy-agent.sh`
- ✅ **SÍ funciona**: Deploy automático con cada `git push`

---

## 🚀 Flujo de Trabajo Recomendado

```
┌─────────────────────────────────────────────────────────────┐
│  1. Haces cambios en el código                              │
│                                                             │
│  2. git add -A && git commit -m "mensaje" && git push       │
│                                                             │
│  3. El workflow se ejecuta AUTOMÁTICAMENTE                  │
│     (GitHub Actions detecta el push a main)                 │
│                                                             │
│  4. Esperas 2-5 minutos                                     │
│     - Install: npm install / pnpm install / yarn install    │
│     - Build: npm run build                                  │
│     - Deploy: Sube dist/ a GitHub Pages                     │
│                                                             │
│  5. Sitio actualizado en: owner.github.io/repo/             │
└─────────────────────────────────────────────────────────────┘
```

---

## 📊 Verificar Estado del Despliegue

### Opción 1: GitHub Web (Recomendado)

1. Ve a: `https://github.com/{owner}/{repo}/actions`
2. Click en el workflow más reciente ("Deploy to GitHub Pages")
3. Espera a que todos los checks estén en ✅
4. Click en "deploy" para ver la URL

### Opción 2: GitHub CLI

```bash
# Ver últimos 5 runs
gh run list --repo {owner}/{repo} --limit 5

# Ver logs del último run
gh run view --repo {owner}/{repo} --log --latest

# Ver un run específico
gh run view <RUN_ID> --repo {owner}/{repo} --log

# Ver workflows disponibles
gh workflow list --repo {owner}/{repo}
```

### Opción 3: Script del Agente (Informativo)

```bash
cd /path/to/proyecto
.github/workflows/deploy-agent.sh
```

> **Nota**: En Codespaces, el script solo mostrará información. El deploy real ocurre automáticamente con el push.

---

## 🔧 Configuración Requerida

### `astro.config.mjs` / `astro.config.ts`

```javascript
import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://{owner}.github.io/{repo}',
  base: '/{repo}',  // ⚠️ Debe coincidir con el nombre del repo
  // ... resto de configuración
});
```

### `.github/workflows/deploy.yml`

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]  # Se ejecuta con cada push a main
  workflow_dispatch:  # Permite trigger manual (no funciona en Codespaces)

# ... resto de configuración (ver deploy.yml template)
```

---

## 🛠️ Solución de Problemas

### El CSS no carga después del deploy

**Síntoma**: La página se ve sin estilos, solo texto y enlaces.

**Causa**: `base` en `astro.config.*` no coincide con el nombre del repositorio.

**Solución**:
```javascript
// astro.config.mjs
export default defineConfig({
  site: 'https://{owner}.github.io/{repo}',
  base: '/{repo}'  // ← Debe ser /<nombre-del-repo>
});
```

### Workflow falla con error 403

**Síntoma**: `HTTP 403: Resource not accessible by integration`

**Causa**: Token sin permisos para trigger manual (normal en Codespaces).

**Solución**: El deploy automático por push SÍ funciona. Solo ignora el error del trigger manual.

### Build falla

**Síntoma**: El workflow marca ❌ en el paso de build.

**Pasos**:
1. Revisa los logs en: `https://github.com/{owner}/{repo}/actions`
2. Ejecuta `npm run build` (o `pnpm build`, `yarn build`) localmente para reproducir el error
3. Corrige el error
4. Haz push nuevamente

### Página 404 después del deploy

**Causas posibles**:
1. El workflow aún no terminó (espera 2-5 min)
2. GitHub Pages no está configurado correctamente

**Verificación**:
1. Ve a: `https://github.com/{owner}/{repo}/settings/pages`
2. En **Build and deployment**:
   - **Source**: Debe decir "GitHub Actions"
3. Si dice "Deploy from a branch", cámbialo a "GitHub Actions"

---

## 📝 Comandos Útiles

### Desarrollo Local

```bash
# Instalar dependencias
npm install    # o pnpm install, yarn install

# Servidor de desarrollo (localhost:4321)
npm run dev

# Build de producción
npm run build

# Preview del build
npm run preview
```

### Git + Deploy

```bash
# Ver cambios
git status
git diff

# Commit y push (dispara deploy automático)
git add -A
git commit -m "feat: descripción del cambio"
git push

# Ver últimos commits
git log --oneline -5
```

### GitHub CLI

```bash
# Autenticación (si no estás autenticado)
gh auth login

# Ver estado de autenticación
gh auth status

# Ver runs del workflow
gh run list --repo {owner}/{repo}

# Ver logs detallados
gh run view --repo {owner}/{repo} --log

# Abrir el repo en el navegador
gh repo view {owner}/{repo} --web
```

---

## 🔄 Flujo Completo de Corrección de Errores

```
┌─────────────────────────────────────────────────────────────┐
│  1. Push a main                                             │
│     ↓                                                       │
│  2. Workflow se ejecuta automáticamente                     │
│     ↓                                                       │
│  3a. ✅ ÉXITO → Sitio actualizado                           │
│     ↓                                                       │
│  3b. ❌ FALLO → Revisar logs en GitHub Actions              │
│     ↓                                                       │
│  4. Copiar log de error                                     │
│     ↓                                                       │
│  5. Pedir ayuda al asistente (proporciona el log)           │
│     ↓                                                       │
│  6. Asistente corrige errores                               │
│     ↓                                                       │
│  7. git add -A && git commit && git push                    │
│     ↓                                                       │
│  8. Volver al paso 2                                        │
└─────────────────────────────────────────────────────────────┘
```

---

## 📚 Referencias

### Documentación Oficial

- [GitHub Actions](https://docs.github.com/en/actions)
- [GitHub Pages](https://pages.github.com/)
- [Astro Deploy Guide](https://docs.astro.build/en/guides/deploy/)
- [GitHub CLI](https://cli.github.com/manual/)

### Skill Astro-Docs

- **Ubicación**: `~/.qwen/skills/astro-docs/`
- **Repo**: https://github.com/asachs01/astro-docs-skill
- **Propósito**: Guía patrones correctos de Astro v5

### URLs del Proyecto

| Descripción | URL |
|-------------|-----|
| Repositorio | `https://github.com/{owner}/{repo}` |
| Actions | `https://github.com/{owner}/{repo}/actions` |
| Settings | `https://github.com/{owner}/{repo}/settings` |
| Sitio Desplegado | `https://{owner}.github.io/{repo}/` |

---

## 🎯 Checklist de Despliegue Exitoso

- [ ] `npm run build` funciona localmente sin errores
- [ ] `astro.config.*` tiene `site` y `base` correctos
- [ ] `.github/workflows/deploy.yml` existe y está bien configurado
- [ ] Push a `main` se completó
- [ ] Workflow en GitHub Actions está en ✅
- [ ] Sitio carga correctamente en `https://{owner}.github.io/{repo}/`
- [ ] CSS y JS cargan sin errores 404

---

*Última actualización: 2026-03-28*
