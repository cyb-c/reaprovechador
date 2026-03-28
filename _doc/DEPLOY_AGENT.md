# Agente de Despliegue - Documentación

## Propósito

Automatizar y monitorear el despliegue del sitio AstroWind a GitHub Pages.

## Ubicación

- **Script del agente**: `.github/workflows/deploy-agent.sh`
- **Workflow de despliegue**: `.github/workflows/deploy.yml`

## ⚠️ Limitación en GitHub Codespaces

El token `GITHUB_TOKEN` en Codespaces **no tiene permisos** para ejecutar workflows manualmente por razones de seguridad.

### Flujo de Trabajo Recomendado

```
┌─────────────────────────────────────────────────────────────┐
│  1. Haces cambios en el código                              │
│  2. git add -A && git commit -m "mensaje" && git push       │
│  3. El workflow se ejecuta AUTOMÁTICAMENTE                  │
│  4. Esperas 2-5 minutos                                     │
│  5. Sitio actualizado en: cyb-c.github.io/reaprovechador    │
└─────────────────────────────────────────────────────────────┘
```

## Uso del Agente (Solo Informativo)

El script `deploy-agent.sh` es útil para:
- Verificar el estado de la autenticación
- Mostrar la URL del workflow
- Proporcionar comandos útiles para monitorear el despliegue

### Ejecutar (en entorno local con token adecuado)

```bash
cd /workspaces/reaprovechador
.github/workflows/deploy-agent.sh
```

## Comandos Útiles

### Ver estado de workflows
```bash
gh workflow list --repo cyb-c/reaprovechador
```

### Ver últimos runs
```bash
gh run list --repo cyb-c/reaprovechador --limit 5
```

### Ver logs del último run
```bash
gh run view --repo cyb-c/reaprovechador --log --latest
```

### Ver un run específico
```bash
gh run view <RUN_ID> --repo cyb-c/reaprovechador --log
```

## Deploy Automático

Cada push a la rama `main` dispara automáticamente:

1. **Build**: `npm install` + `npm run build`
2. **Deploy**: Sube la carpeta `dist/` a GitHub Pages
3. **URL**: https://cyb-c.github.io/reaprovechador/

### Verificar estado del deploy

1. Ve a: https://github.com/cyb-c/reaprovechador/actions
2. Click en el workflow más reciente
3. Espera a que todos los checks estén en ✅

## Solución de Problemas

### El CSS no carga después del deploy

**Causa**: `base` en `config.yaml` no coincide con el nombre del repositorio

**Solución**:
```yaml
# src/config.yaml
site:
  site: 'https://cyb-c.github.io/reaprovechador'
  base: '/reaprovechador'  # Debe coincidir con el repo
```

### Workflow falla con error 403

**Causa**: Token sin permisos (común en Codespaces)

**Solución**: El deploy automático por push SÍ funciona. Solo el trigger manual está bloqueado.

### Build falla

1. Revisa los logs en: https://github.com/cyb-c/reaprovechador/actions
2. Ejecuta `npm run build` localmente para reproducir el error
3. Corrige el error y haz push nuevamente

## Referencias

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Astro Deploy Guide](https://docs.astro.build/en/guides/deploy/)
- Skill: `~/.qwen/skills/astro-docs.md`
