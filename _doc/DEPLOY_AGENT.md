# Agente de Despliegue - Documentación

## Propósito

Este agente automatiza el despliegue del sitio AstroWind a GitHub Pages, incluyendo:
- Ejecución del workflow de GitHub Actions
- Monitoreo del estado del despliegue
- Reporte de éxitos o fallos con logs detallados

## Ubicación

- **Script del agente**: `.github/workflows/deploy-agent.sh`
- **Workflow de despliegue**: `.github/workflows/deploy.yml`

## Requisitos Previos

1. **GitHub CLI instalado** (`gh`)
   ```bash
   # macOS
   brew install gh
   
   # Linux (Debian/Ubuntu)
   sudo apt install gh
   
   # Windows (Chocolatey)
   choco install gh
   ```

2. **Autenticación con GitHub**
   ```bash
   gh auth login
   # Selecciona: GitHub.com → HTTPS → Login with a browser
   ```

3. **Permisos necesarios**
   - `repo` (acceso completo al repositorio)
   - `workflow` (ejecutar workflows)

## Uso

### Ejecución Manual

```bash
cd /workspaces/reaprovechador
chmod +x .github/workflows/deploy-agent.sh
.github/workflows/deploy-agent.sh
```

### Flujo del Agente

```
┌─────────────────────────────────────────────────────────────┐
│  1. Verificar autenticación con GitHub CLI                  │
│  2. Verificar que el workflow existe                        │
│  3. Ejecutar workflow de despliegue                         │
│  4. Monitorear estado (polling cada 10s, máx 10 min)        │
│  5a. ÉXITO → Reportar URL del sitio                         │
│  5b. FALLO → Obtener logs y pasar control al usuario        │
└─────────────────────────────────────────────────────────────┘
```

## Comandos Útiles

### Ver estado del último despliegue
```bash
gh run list --repo cyb-c/reaprovechador --limit 5
```

### Ver logs del último run
```bash
gh run view --repo cyb-c/reaprovechador --log --latest
```

### Re-ejecutar último workflow fallido
```bash
gh run rerun --repo cyb-c/reaprovechador --failed
```

### Ver workflows disponibles
```bash
gh workflow list --repo cyb-c/reaprovechador
```

## Integración con el Asistente Principal

### Cuando el agente detecta un error:

1. **El agente se detiene** y muestra los logs de error
2. **Pasa el control** al asistente principal (Qwen)
3. **El usuario** proporciona los logs al asistente
4. **El asistente** corrige los errores usando la skill `astro-docs`
5. **El usuario** vuelve a invocar el agente de despliegue

### Ejemplo de flujo de corrección:

```bash
# 1. Usuario ejecuta el agente
./deploy-agent.sh

# 2. Agente reporta error (ej: CSS no carga)
# [ERROR] El despliegue falló...
# [INFO] Logs: ...error de build...

# 3. Usuario copia logs y pide ayuda al asistente
# "El despliegue falló, aquí están los logs: [...]"

# 4. Asistente corrige el error (ej: actualiza config.yaml)

# 5. Usuario hace commit y push
git add -A && git commit -m "fix: ..." && git push

# 6. Usuario vuelve a ejecutar el agente
./deploy-agent.sh
```

## Configuración Personalizable

Edita las variables al inicio del script:

```bash
REPO="cyb-c/reaprovechador"           # Tu repositorio
WORKFLOW_NAME="Deploy to GitHub Pages" # Nombre del workflow
MAX_WAIT_TIME=600                      # Tiempo máximo (segundos)
CHECK_INTERVAL=10                      # Intervalo de chequeo (segundos)
```

## Solución de Problemas

### Error: "gh: command not found"
Instala GitHub CLI (ver Requisitos Previos)

### Error: "authentication required"
```bash
gh auth login
```

### Error: "workflow not found"
Verifica que `.github/workflows/deploy.yml` existe y se llama "Deploy to GitHub Pages"

### Error: "resource not accessible by integration"
El token de GitHub necesita permisos de `repo` y `workflow`

### El despliegue falla consistentemente
1. Revisa los logs con `gh run view --log --latest`
2. Verifica que `npm run build` funciona localmente
3. Consulta la skill `astro-docs` para patrones correctos

## Referencias

- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Astro Deploy Guide](https://docs.astro.build/en/guides/deploy/)
- Skill: `~/.qwen/skills/astro-docs.md`
