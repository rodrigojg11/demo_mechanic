# Project Preferences

These preferences are mandatory for this Rails application and should be followed in every future change.

## Product Language

- All user-facing application copy must be written in English.
- Internal documentation can be bilingual only when useful, but code, labels, forms, buttons, validations, and UI text should default to English.

## Frontend

- Use Bootstrap for layout, components, responsive behavior, and utility classes.
- Use plain CSS only when Bootstrap is not enough or when the design requires a small custom layer.
- Avoid additional frontend frameworks unless explicitly approved.

## Forms

- Build all Rails forms with `simple_form`.
- Keep validations and error messages connected to the model layer.

## JavaScript

- Use Stimulus for all JavaScript behavior.
- Do not add standalone JavaScript patterns when a Stimulus controller is the right fit.
- Keep controllers small, focused, and named by the behavior they own.

## Hotwire

- Use Hotwire for page updates and notifications:
  - Turbo Drive for navigation.
  - Turbo Frames for scoped page replacement.
  - Turbo Streams for live updates, notifications, and partial refreshes.

## Background Work And Cache

- Use Solid Queue for background jobs.
- Use Solid Cache for caching.
- Keep jobs idempotent whenever possible.

## External Integrations

- All external API calls must go through service objects.
- Services should expose a small public interface and hide provider-specific details.
- Keep HTTP clients, credentials, retries, and error handling out of controllers and views.

## Data Ownership

- Models are responsible for data rules, validations, scopes, associations, and domain behavior.
- Controllers should orchestrate requests, not own business logic.
- Views should render state, not compute business rules.

## Architecture

- Follow SOLID principles.
- Prefer small, cohesive objects with clear responsibilities.
- Keep dependencies explicit and avoid hidden coupling.
- Avoid premature abstraction, but extract objects when behavior becomes shared or complex.

## Security

- Protect all links, forms, inputs, and endpoints against CSRF, XSS, SQL injection, mass assignment, and unsafe redirects.
- Use Rails helpers for escaping and URL generation.
- Use strong parameters.
- Avoid raw SQL; when needed, parameterize safely.
- Never trust client-side input.
- Treat security as a primary requirement, not a cleanup task.

## Pagination

- Use Pagy for pagination.
- Infinite scroll is acceptable when it improves the UX, preferably implemented with Pagy plus Turbo Frames/Streams.

## Database Performance

- Optimize queries and avoid N+1 issues.
- Use `includes`, `preload`, `eager_load`, counter caches, scopes, indexes, and query limits where appropriate.
- Review query behavior whenever adding list pages, dashboards, feeds, or reports.

## Project Memory

- Every internal feature or meaningful modification must update the project memory.
- Project memory lives in `CLAUDE.md` and, when the change affects preferences or operating rules, in this file too.
- Keep memory updates concise, current, and useful for future sessions.
