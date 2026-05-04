# CLAUDE.md

This file is the working memory for Claude Code in this repository. Keep it concise, current, and useful.

## Objective

Cruz Auto is a Ruby on Rails application for an auto repair shop homepage and appointment flow. The product should evolve from the current demo into a production-ready Rails app with editable business content, real appointments, customer-facing service pages, gallery/reviews, notifications, and secure operational workflows.

## Product Scope

- The app will not include a mechanic/admin dashboard for now.
- The backend exists mainly for appointment scheduling, notifications, calendar integration, reminders, confirmations, cancellations, and optional payments.
- Payments must never be required to request an appointment.
- Customers may choose to pay in advance or pay after the job is completed.
- If a customer chooses to pay later, they should continue filling out and submitting the appointment form normally.
- Appointment flow and payment flow must stay separate so Stripe can be added without making payment mandatory.

## Current State

- Rails 7.2 app converted from a former single-file static prototype.
- Homepage is server-rendered with ERB.
- Most homepage business content is currently defined in `PagesController#home`; services now come from the `services` table.
- Static homepage content is centralized in `HomepageContent`; `PagesController#home` only assigns content, services, and the booking form object.
- Active Record is enabled with SQLite for local development and test.
- Core booking models exist: `Customer`, `Vehicle`, `Service`, `Appointment`, `AppointmentConfirmationToken`, `Notification`, and `CalendarEvent`.
- Appointment domain rules live in `Appointment`: future date, shop hours, service fit, allowed statuses, and double-booking prevention.
- Booking UI now uses a Turbo Frame and `simple_form` through `AppointmentRequest`.
- Appointment requests create `Customer`, `Vehicle`, and `Appointment` records.
- Appointment payment preference is stored as `pay_now` or `pay_after_service`.
- Payments are tracked through `Payment` records with provider, status, amount, checkout URL, and external reference fields.
- Payment states are `optional_pending`, `paid_advance`, `paid_after_service`, `failed`, and `refunded`.
- `pay_after_service` creates a manual `optional_pending` payment record and never blocks appointment creation.
- `pay_now` creates a Stripe-intended `optional_pending` payment record with a secure signed checkout placeholder; live Stripe Checkout API calls are not connected yet.
- Stripe webhook handling lives at `POST /stripe/webhooks`; successful `checkout.session.completed` events mark the related payment as `paid_advance`.
- Availability is calculated by `ShopAvailability` using shop hours, blocked dates, existing blocking appointments, service duration, and service buffer.
- `BlockedDate` supports future blocked days and holidays.
- Appointments with `customer_cancelled` or `expired_unconfirmed` status no longer block availability.
- Appointment requests enqueue internal notifications through `AppointmentNotificationService`.
- Notification delivery uses Solid Queue jobs with placeholder delivery that records notification status in the database.
- Customer response links are tokenized routes for confirm, cancel, and reschedule.
- Customer response links use Rails signed IDs with an appointment-response purpose and expiration.
- Cancelling or rescheduling through a secure token releases the appointment slot.
- Reminder and unconfirmed-expiration jobs are scheduled relative to the appointment time.
- Calendar integration is represented by `CalendarEventService` and `CalendarEvent`.
- New appointments create an internal mechanic calendar event and an ICS payload for customer calendar invites.
- Calendar event references are stored in `calendar_events.external_id`, `calendar_url`, `ics_payload`, `synced_at`, and `cancelled_at`.
- Cancelling, rescheduling, or expiring an appointment marks the calendar event cancelled and regenerates a CANCEL ICS payload.
- Cancelling, rescheduling, or expiring an appointment marks any unpaid pending payment record as `failed`.
- The old JSON preview endpoint remains available only as a demo endpoint.
- The active development Ruby is `3.3.11` through rbenv, with Bundler `2.7.2`.
- Foundation gems are installed: Bootstrap, simple_form, stimulus-rails, turbo-rails, solid_queue, solid_cache, and pagy.
- JavaScript behavior lives in Stimulus controllers under `app/javascript/controllers`.
- Bootstrap is served as a local compiled asset; custom CSS should now be treated as a minimal brand layer and reduced whenever Bootstrap can cover the need.
- Legacy `index.html` has been archived as `docs/archive/legacy-index.html`. Do not build new features there.
- Minitest coverage now exists for appointment rules, availability, payments, calendar events, Stripe webhook handling, and critical booking/confirmation flows.

## Stack Direction

- Ruby on Rails.
- English-only user-facing application copy.
- Bootstrap for UI and layout.
- Plain CSS only when Bootstrap is insufficient.
- `simple_form` for all forms.
- Stimulus for JavaScript behavior.
- Hotwire Turbo for page updates, notifications, Turbo Frames, and Turbo Streams.
- Solid Queue for background jobs.
- Solid Cache for caching.
- Pagy for pagination or infinite scroll.
- Service objects for all external API requests.

See `PROJECT_PREFERENCES.md` for mandatory project preferences and architectural rules.

## Architecture

- Models own data rules, validations, associations, scopes, and domain behavior.
- Controllers orchestrate requests and should stay thin.
- Views render state and should not own business logic.
- External integrations belong in service objects.
- Follow SOLID principles and keep responsibilities explicit.
- Optimize all list/query features to avoid N+1 issues.

## Security

- Treat security as a first-class requirement.
- Protect forms, links, inputs, and endpoints against CSRF, XSS, SQL injection, unsafe redirects, and mass assignment.
- Prefer Rails helpers and strong parameters.
- Avoid raw SQL; parameterize safely when raw SQL is truly needed.
- Never trust client-side input.
- Real application forms keep Rails CSRF protection enabled; only the Stripe webhook endpoint skips CSRF and must verify `Stripe-Signature`.
- Public payment and appointment-response links must use signed IDs with explicit purposes and expirations.
- Use `allow_other_host: false` for redirects unless an external redirect is intentionally required and validated.

## Current Files

- `app/controllers/pages_controller.rb`: thin homepage controller; loads `HomepageContent`, services, and the booking form object.
- `app/models/homepage_content.rb`: static homepage content until editable business content is moved to database-backed models.
- `app/controllers/appointments_controller.rb`: CSRF-protected demo booking preview endpoint.
- `app/forms/appointment_request.rb`: form object for the customer-facing appointment request flow.
- `app/views/appointments/_form.html.erb`: Turbo Frame booking form built with `simple_form`.
- `app/views/appointments/_success.html.erb`: Turbo Frame success state after appointment creation.
- `app/models/*.rb`: core booking domain models and validations.
- `app/models/shop_availability.rb`: appointment availability calculator.
- `app/models/blocked_date.rb`: future blocked date and holiday support.
- `app/services/appointment_notification_service.rb`: creates mechanic/customer notifications, secure response links, reminder jobs, and expiration jobs.
- `app/jobs/notification_delivery_job.rb`: placeholder notification delivery through Solid Queue.
- `app/jobs/appointment_reminder_job.rb`: 24-hour customer reminder orchestration.
- `app/jobs/appointment_expiration_job.rb`: releases unconfirmed appointments before appointment time.
- `app/controllers/appointment_responses_controller.rb`: secure confirm/cancel/reschedule token links.
- `app/services/calendar_event_service.rb`: internal calendar sync and ICS generation.
- `app/controllers/calendars_controller.rb`: serves appointment `.ics` calendar files.
- `app/models/payment.rb`: optional appointment payment tracking.
- `app/services/appointment_payment_service.rb`: prepares manual or Stripe-intended payment records without requiring payment.
- `app/services/payments/stripe_checkout_service.rb`: prepares the signed checkout URL placeholder for Stripe Checkout.
- `app/services/payments/stripe_webhook_service.rb`: verifies and processes Stripe webhook payloads.
- `app/controllers/payments_controller.rb`: secure signed checkout placeholder for future Stripe integration.
- `app/controllers/stripe_webhooks_controller.rb`: Stripe webhook endpoint.
- `db/seeds.rb`: seed data for customer-facing services.
- `app/views/pages/home.html.erb`: main homepage.
- `app/views/layouts/application.html.erb`: application layout.
- `app/views/shared/_icon.html.erb`: inline SVG helper partial.
- `app/assets/stylesheets/application.scss`: Bootstrap import plus the current brand CSS.
- `app/javascript/controllers/chrome_controller.js`: navigation, theme, mobile menu, and reveal behavior.
- `app/javascript/controllers/booking_controller.js`: appointment request flow.
- `app/javascript/controllers/gallery_controller.js`: gallery filtering, uploads, and lightbox behavior.
- `test/`: Minitest suite for models, services, and critical integration flows.

## Commands

```bash
bundle install --path vendor/bundle
bundle exec rails routes
bundle exec rails test
bundle exec rails server
```

`rs` is available through the oh-my-zsh Rails plugin and maps to `rails server`.

## Memory Update Rule

Whenever an internal feature or meaningful modification is created, update this file with the relevant new context. If the change affects project preferences, constraints, or operating rules, update `PROJECT_PREFERENCES.md` too.
