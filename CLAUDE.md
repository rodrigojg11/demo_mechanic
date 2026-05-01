# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Proyecto

Homepage para un **taller mecánico / auto shop** — parte de la serie `DEMOS_homepages`. El proyecto hermano de referencia es `../demo_barber/`.

## Stack

Archivo único `index.html` — React 18 + JSX compilado en browser con Babel standalone. Sin build tool, sin dependencias npm. Abrir directamente en navegador o servir con cualquier servidor estático.

```bash
# Servir localmente
npx serve .
# o simplemente abrir index.html en el navegador
```

## Arquitectura esperada

Todo el código vive en un solo `<script type="text/babel">` dentro de `index.html`, dividido en secciones marcadas con comentarios. Seguir exactamente el mismo patrón que `../demo_barber/index.html`:

- **DATA** — `BUSINESS`, `MECHANIC`, `SERVICES`, `GALLERY`, `REVIEWS`, `HOURS`
- **ICONS** — componente `Icon` con SVGs inline
- **NAV** — navegación sticky con toggle dark/light y menú mobile
- **HERO** — sección fullscreen con foto de fondo, stats, CTAs
- **ABOUT** — bio del mecánico/dueño con foto y especialidades
- **SERVICES** — lista de servicios con precios; click → pre-llena cita
- **BOOKING** — flujo multi-step (servicio → fecha → hora → datos del vehículo → confirmación)
- **GALLERY** — grid con filtros por categoría (trabajos terminados, equipo, instalaciones) + upload de fotos del usuario (FileReader)
- **REVIEWS** — reseñas de clientes + CTA a Google
- **LOCATION** — horarios + dirección + contacto
- **FOOTER** — columnas + botón flotante WhatsApp
- **APP** — root component: maneja theme dark/light, loader de arranque, scroll reveal con IntersectionObserver

## Variables CSS clave

Seguir el mismo sistema de design tokens que `../demo_barber/`:

`--bg`, `--bg-2`, `--bg-3` — fondos  
`--accent`, `--accent-2` — color de acento (para mecánico: naranja, rojo, o azul industrial)  
`--ink`, `--ink-2`, `--ink-3` — texto  
`[data-theme="light"]` en `<body>` activa el tema claro.

## Para reemplazar fotos reales

Cambiar las URLs en los arrays `GALLERY` y `MECHANIC.photo` en la sección DATA. Las imágenes de placeholder deben venir de Unsplash. El upload de fotos del usuario ya funciona sin cambios.

## Referencia

Ver `../demo_barber/index.html` como plantilla completa — copiar estructura y adaptar contenido al rubro de taller mecánico.
