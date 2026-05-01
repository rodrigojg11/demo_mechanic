# Cruz Auto · Taller Mecánico — Demo Homepage

> Parte de la serie [`DEMOS_homepages`](../) · Diseñado en Oak Cliff, Dallas TX

---

## Español

### ¿Qué es esto?

Homepage de demostración para un taller mecánico ficticio llamado **Cruz Auto**. Es un prototipo interactivo de una sola página, listo para abrir en el navegador sin ningún proceso de instalación o build.

Está pensado como base de partida para negocios del rubro automotriz que necesiten una presencia web profesional: basta con reemplazar los textos, precios e imágenes con los datos reales del negocio.

### Funcionalidades

- **Hero** cinematográfico con foto de fondo, indicador de estado en vivo y estadísticas del taller
- **Sobre el mecánico** — bio, especialidades y certificaciones
- **6 servicios** con precios USD, duración estimada y click directo a reserva
- **Reserva online multi-step** — servicio → calendario → horario → datos del vehículo (marca, modelo, año) + confirmación por SMS simulada
- **Galería** con filtros por categoría (Motor, Frenos, Llantas, Suspensión, Diagnóstico) y upload de fotos propias
- **5 reseñas** de clientes con CTA a Google
- **Horarios** con resaltado del día actual
- **Mapa simulado** de W Davis St, Oak Cliff con pin animado
- **Toggle claro/oscuro** en la navegación
- **Botón flotante de WhatsApp**
- Diseño completamente responsive (desktop, tablet, mobile)

### Cómo usar

```bash
# Opción 1 — abrir directo en el navegador
open index.html

# Opción 2 — servir con cualquier servidor estático
npx serve .
```

No requiere Node.js, npm, ni ningún proceso de compilación. React y Babel se cargan desde CDN.

### Personalización

Todo el contenido editable está en la sección `DATA` al inicio del `<script type="text/babel">` dentro de `index.html`:

| Constante   | Qué contiene                                      |
|-------------|---------------------------------------------------|
| `BUSINESS`  | Nombre, dirección, teléfono, email, redes         |
| `MECHANIC`  | Bio, foto, especialidades, certificaciones        |
| `SERVICES`  | Lista de servicios con nombre, precio y duración  |
| `GALLERY`   | URLs de imágenes y etiquetas de categoría         |
| `REVIEWS`   | Testimoniales de clientes                         |
| `HOURS`     | Horarios de atención por día                      |

Para cambiar las fotos, reemplazá las URLs de Unsplash en `GALLERY` y `MECHANIC.photo` por imágenes propias. La galería también permite subir fotos directamente desde el navegador.

### Stack técnico

- **React 18** + **Babel standalone** (JSX compilado en el browser)
- **CSS custom properties** para el sistema de diseño y el toggle dark/light
- Sin dependencias npm · Sin proceso de build · Un solo archivo

---

## English

### What is this?

A demo homepage for a fictional auto repair shop called **Cruz Auto**. It's a single-page interactive prototype that opens directly in the browser — no installation or build process required.

It's designed as a starting point for automotive businesses that need a professional web presence. Simply replace the text, prices, and images with real business data to make it your own.

### Features

- **Cinematic hero** with background photo, live status indicator, and shop stats
- **About the mechanic** — bio, specialties, and certifications
- **6 services** with USD pricing, estimated duration, and direct booking link
- **Multi-step online booking** — service → calendar → time slot → vehicle info (make, model, year) + simulated SMS confirmation
- **Gallery** with category filters (Engine, Brakes, Tires, Suspension, Diagnostics) and user photo upload
- **5 customer reviews** with a Google review CTA
- **Business hours** with today's highlight
- **Simulated map** of W Davis St, Oak Cliff with animated pin
- **Dark/light toggle** in the navigation
- **Floating WhatsApp button**
- Fully responsive design (desktop, tablet, mobile)

### How to run

```bash
# Option 1 — open directly in the browser
open index.html

# Option 2 — serve with any static server
npx serve .
```

No Node.js, npm, or build step required. React and Babel are loaded from CDN.

### Customization

All editable content lives in the `DATA` section at the top of the `<script type="text/babel">` block inside `index.html`:

| Constant    | Contents                                          |
|-------------|---------------------------------------------------|
| `BUSINESS`  | Name, address, phone, email, social links         |
| `MECHANIC`  | Bio, photo, specialties, certifications           |
| `SERVICES`  | Service list with name, price, and duration       |
| `GALLERY`   | Image URLs and category tags                      |
| `REVIEWS`   | Customer testimonials                             |
| `HOURS`     | Business hours per day                            |

To swap photos, replace the Unsplash URLs in `GALLERY` and `MECHANIC.photo` with your own images. The gallery also supports uploading photos directly from the browser.

### Tech stack

- **React 18** + **Babel standalone** (JSX compiled in the browser)
- **CSS custom properties** for the design system and dark/light toggle
- No npm dependencies · No build process · Single file

---

## Demo series

| Project | Business |
|---|---|
| [`demo_barber`](../demo_barber/) | ST Machine Barber Studio · Oak Cliff, Dallas |
| [`demo_nails`](../demo_nails/) | Pao Nails · Brickell, Miami |
| [`demo_pastry`](../demo_pastry/) | Dulce Encanto Repostería · Medellín |
| [`demo_mechanic`](../demo_mechanic/) | Cruz Auto · Oak Cliff, Dallas |
