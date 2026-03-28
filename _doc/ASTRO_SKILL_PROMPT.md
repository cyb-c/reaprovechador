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
- Deploy a Azure Static Web Apps
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

### 4. Proyecto completo

```
Activa la skill astro-docs como referencia obligatoria.

Inicializa un proyecto Astro v5 desde cero con:
- Tailwind CSS
- React para islas interactivas
- Content collections para productos
- Deploy a Vercel
```

---

## 📋 Proyecto Actual: AstroWind

### Lo instalado

| Elemento | Estado |
|----------|--------|
| Plantilla | AstroWind v1.0.0-beta.52 |
| Astro | v5.12.9 |
| Tailwind CSS | v3.4.17 |
| TypeScript | v5.8.3 |
| Ubicación | `/workspaces/reaprovechador/astrowind/` |

### Características de AstroWind

- ✅ Astro 5 con patrones v5
- ✅ Tailwind CSS integrado
- ✅ TypeScript
- ✅ Blog con MDX support
- ✅ SEO automático (sitemap, Open Graph)
- ✅ Dark mode
- ✅ Optimización de imágenes (Unpic)
- ✅ RSS feed automático
- ✅ Analytics (Google Analytics, Splitbee)

### Comandos útiles

```bash
cd /workspaces/reaprovechador/astrowind

npm run dev       # Dev server en localhost:4321
npm run build     # Build para producción
npm run preview   # Preview build local
npm run check     # Check de tipo y lint
npm run fix       # Auto-fix de ESLint + Prettier
```

---

## 🚀 Cómo seguir para crear tu web

### Paso 1: Explora la plantilla

```bash
cd /workspaces/reaprovechador/astrowind
```

**Archivos clave para editar:**

| Archivo | Qué hace |
|---------|----------|
| `src/config.yaml` | Configuración del sitio (título, menú, redes sociales) |
| `src/pages/index.astro` | Página de inicio |
| `src/layouts/PageLayout.astro` | Layout principal |
| `src/components/` | Componentes reutilizables |
| `src/content/blog/` | Entradas del blog |
| `public/` | Imágenes, favicon, assets estáticos |

### Paso 2: Personaliza el contenido

Dime qué tipo de web quieres y te ayudo:

```
Usa la skill astro-docs (~/.qwen/skills/astro-docs.md) como guía principal.

Quiero modificar AstroWind para:
- [Describe tu web: corporativa, blog, portfolio, tienda, etc.]
- [Colores de marca]
- [Secciones que necesitas]
- [Funcionalidades especiales]
```

### Paso 3: Ejemplos por tipo de web

#### Web Corporativa

```
Usa la skill astro-docs como guía principal.

Modifica AstroWind para una web corporativa de consultoría con:
- Hero section con imagen de fondo
- Sección de servicios (3 cards)
- Sección de equipo
- Formulario de contacto
- Colores: azul (#1a56db) y gris
```

#### Portfolio Personal

```
Usa la skill astro-docs como guía principal.

Convierte AstroWind en un portfolio personal con:
- Hero con foto y bio corta
- Galería de proyectos con imágenes
- Sección de habilidades (skills)
- Timeline de experiencia
- Enlaces a GitHub, LinkedIn, Twitter
```

#### Blog Técnico

```
Usa la skill astro-docs para la Content Layer API.

Configura AstroWind como blog técnico con:
- Categories: Tutoriales, Opinión, News
- Tags para filtrado
- Autor múltiple con perfiles
- Newsletter signup
- Comentarios con Giscus o Utterances
```

#### Landing Page de Producto

```
Usa la skill astro-docs como guía principal.

Transforma AstroWind en landing page para un SaaS con:
- Hero con CTA principal
- Features section (iconos + descripción)
- Pricing cards (3 planes)
- Testimonios
- FAQ accordion
- Footer con links legales
```

### Paso 4: Deploy (cuando esté lista)

La plantilla soporta:

| Plataforma | Config |
|------------|--------|
| **Netlify** | `netlify.toml` incluido |
| **Vercel** | `vercel.json` incluido |
| **Docker** | `Dockerfile` + `docker-compose.yml` |
| **Azure Static Web Apps** | Ver skill astro-docs |

---

## Referencia

- **Skill file:** `~/.qwen/skills/astro-docs.md`
- **Skill source:** `/workspaces/reaprovechador/.skills/astro-docs-skill/SKILL.md`
- **Plantilla:** [AstroWind GitHub](https://github.com/arthelokyo/astrowind)
- **Docs Astro:** https://docs.astro.build/en/
- **Docs Starlight:** https://starlight.astro.build/
