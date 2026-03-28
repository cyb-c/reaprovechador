# Agente de Despliegue - GitHub Pages (AstroWind)

## 📋 Propósito

Automatizar y monitorear el despliegue del sitio AstroWind a GitHub Pages.

---

## 📁 Archivos Clave

| Archivo | Propósito |
|---------|-----------|
| `.github/workflows/deploy-agent.sh` | Script informativo del agente |
| `.github/workflows/deploy.yml` | Workflow automático de GitHub Actions |
| `src/config.yaml` | Configuración del sitio (URL y base) |
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
│     - Install: npm install                                  │
│     - Build: npm run build                                  │
│     - Deploy: Sube dist/ a GitHub Pages                     │
│                                                             │
│  5. Sitio actualizado en: cyb-c.github.io/reaprovechador    │
└─────────────────────────────────────────────────────────────┘
```

---

## 📊 Verificar Estado del Despliegue

### Opción 1: GitHub Web (Recomendado)

1. Ve a: https://github.com/cyb-c/reaprovechador/actions
2. Click en el workflow más reciente ("Deploy to GitHub Pages")
3. Espera a que todos los checks estén en ✅
4. Click en "deploy" para ver la URL

### Opción 2: GitHub CLI

```bash
# Ver últimos 5 runs
gh run list --repo cyb-c/reaprovechador --limit 5

# Ver logs del último run
gh run view --repo cyb-c/reaprovechador --log --latest

# Ver un run específico
gh run view <RUN_ID> --repo cyb-c/reaprovechador --log

# Ver workflows disponibles
gh workflow list --repo cyb-c/reaprovechador
```

### Opción 3: Script del Agente (Informativo)

```bash
cd /workspaces/reaprovechador
.github/workflows/deploy-agent.sh
```

> **Nota**: En Codespaces, el script solo mostrará información. El deploy real ocurre automáticamente con el push.

---

## 🔧 Configuración Requerida

### `src/config.yaml`

```yaml
site:
  name: Reaprovechador
  site: 'https://cyb-c.github.io/reaprovechador'
  base: '/reaprovechador'  # ⚠️ Debe coincidir con el nombre del repo
  trailingSlash: false
```

### `.github/workflows/deploy.yml`

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]  # Se ejecuta con cada push a main
  workflow_dispatch:  # Permite trigger manual (no funciona en Codespaces)

# ... resto de configuración
```

---

## 🛠️ Solución de Problemas

### El CSS no carga después del deploy

**Síntoma**: La página se ve sin estilos, solo texto y enlaces.

**Causa**: `base` en `config.yaml` no coincide con el nombre del repositorio.

**Solución**:
```yaml
# src/config.yaml
site:
  site: 'https://cyb-c.github.io/reaprovechador'
  base: '/reaprovechador'  # ← Debe ser /<nombre-del-repo>
```

### Workflow falla con error 403

**Síntoma**: `HTTP 403: Resource not accessible by integration`

**Causa**: Token sin permisos para trigger manual (normal en Codespaces).

**Solución**: El deploy automático por push SÍ funciona. Solo ignora el error del trigger manual.

### Build falla

**Síntoma**: El workflow marca ❌ en el paso de build.

**Pasos**:
1. Revisa los logs en: https://github.com/cyb-c/reaprovechador/actions
2. Ejecuta `npm run build` localmente para reproducir el error
3. Corrige el error (usa la skill `astro-docs` si es necesario)
4. Haz push nuevamente

### Página 404 después del deploy

**Causas posibles**:
1. El workflow aún no terminó (espera 2-5 min)
2. GitHub Pages no está configurado correctamente

**Verificación**:
1. Ve a: https://github.com/cyb-c/reaprovechador/settings/pages
2. En **Build and deployment**:
   - **Source**: Debe decir "GitHub Actions"
3. Si dice "Deploy from a branch", cámbialo a "GitHub Actions"

---

## 📝 Comandos Útiles

### Desarrollo Local

```bash
# Instalar dependencias
npm install

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
gh run list --repo cyb-c/reaprovechador

# Ver logs detallados
gh run view --repo cyb-c/reaprovechador --log

# Abrir el repo en el navegador
gh repo view cyb-c/reaprovechador --web
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
│  6. Asistente corrige usando skill astro-docs               │
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

- **Ubicación**: `~/.qwen/skills/astro-docs.md`
- **Propósito**: Guía patrones correctos de Astro v5
- **Uso**: El asistente la consulta automáticamente para correcciones

### URLs del Proyecto

| Descripción | URL |
|-------------|-----|
| Repositorio | https://github.com/cyb-c/reaprovechador |
| Actions | https://github.com/cyb-c/reaprovechador/actions |
| Settings | https://github.com/cyb-c/reaprovechador/settings |
| Sitio Desplegado | https://cyb-c.github.io/reaprovechador/ |

---

## 🎯 Checklist de Despliegue Exitoso

- [ ] `npm run build` funciona localmente sin errores
- [ ] `src/config.yaml` tiene `site` y `base` correctos
- [ ] `.github/workflows/deploy.yml` existe y está bien configurado
- [ ] Push a `main` se completó
- [ ] Workflow en GitHub Actions está en ✅
- [ ] Sitio carga correctamente en https://cyb-c.github.io/reaprovechador/
- [ ] CSS y JS cargan sin errores 404

---

*Última actualización: 2026-03-28*
