# Astro Skill - Instrucción Base

## Uso

Para activar la skill `astro-docs` en tus prompts, usa este formato:

```
Usa la skill astro-docs (~/.qwen/skills/astro-docs.md) como guía principal para esta tarea.

[Describe tu tarea específica aquí]
```

---

## Ejemplos

### 1. Crear proyecto nuevo

```
Usa la skill astro-docs (~/.qwen/skills/astro-docs.md) como guía principal.

Crea un sitio de documentación con Starlight que incluya:
- Sidebar con 3 secciones
- Tema personalizado con colores corporativos
- Deploy a GitHub Pages
```

### 2. Componentes Astro

```
Usa la skill astro-docs para seguir patrones v5 correctos.

Scaffoldea un componente Card con:
- Props tipados con TypeScript
- Slots nombrados
- Estilos scoped
```

### 3. Content Collections

```
Sigue la skill astro-docs para la Content Layer API.

Configura collections para un blog con:
- Loader glob() para markdown
- Schema con Zod
- Referencias entre collections
```

### 4. Proyecto completo desde plantilla

```
Usa la skill astro-docs como referencia obligatoria.

Inicializa un proyecto Astro v5 desde una plantilla:
- URL: https://github.com/usuario/plantilla
- Configura para GitHub Pages
- Tailwind CSS integrado
- Blog con MDX
```

### 5. Migración de plantilla

```
Usa la skill astro-docs para migrar esta plantilla Astro a:
- Astro 5 con Content Layer API
- Estructura de carpetas moderna
- TypeScript estricto
- Deploy a GitHub Pages
```

---

## Referencia

- **Skill file:** `~/.qwen/skills/astro-docs.md`
- **Skill repo:** https://github.com/asachs01/astro-docs-skill
- **Docs Astro:** https://docs.astro.build/en/
- **Docs Starlight:** https://starlight.astro.build/

---

## Instalación de la Skill

Si la skill no está instalada, ejecuta:

```bash
mkdir -p ~/.qwen/skills/astro-docs
git clone https://github.com/asachs01/astro-docs-skill ~/.qwen/skills/astro-docs
```

O copia manualmente el archivo `SKILL.md` desde el repositorio.
