# Cruz Auto

Cruz Auto is a Ruby on Rails appointment app for an auto repair shop in Oak Cliff, Dallas. The current product focuses on customer booking, availability, confirmation links, calendar invites, notifications, and optional payments.

The app is intentionally not an admin dashboard. Customers can request an appointment and choose either advance payment or payment after service. Payment never blocks appointment creation.

## Stack

- Ruby 3.3.11
- Rails 7.2
- SQLite for development and test
- Bootstrap plus minimal plain CSS
- ERB views with `simple_form`
- Stimulus for JavaScript behavior
- Hotwire Turbo for booking updates
- Solid Queue for jobs
- Solid Cache for caching
- Pagy for future pagination

## Core Flows

- Customer selects service, date, time, payment preference, and vehicle details.
- Availability blocks Sundays, reduced Saturday hours, existing appointments, service duration, and buffer time.
- Appointment requests create customer, vehicle, appointment, calendar event, payment record, and notifications.
- Customer response links are signed and expiring links for confirm, cancel, and reschedule.
- Calendar support starts with internal `.ics` files.
- Stripe support starts with a checkout placeholder and webhook processing; live Checkout API calls are not connected yet.

## Payments

Payment states:

- `optional_pending`
- `paid_advance`
- `paid_after_service`
- `failed`
- `refunded`

`pay_after_service` creates a manual `optional_pending` payment and keeps the appointment flow moving.

`pay_now` creates a Stripe-intended `optional_pending` payment with a signed checkout URL. The Stripe webhook endpoint marks a payment as `paid_advance` when a valid `checkout.session.completed` event is received.

## Security

- Rails CSRF protection is enabled for real application forms.
- Stripe webhook skips CSRF because Stripe cannot provide an authenticity token, and verifies `Stripe-Signature` when a webhook secret is configured.
- Controllers use strong parameters.
- Public appointment and payment links use signed IDs with explicit purposes and expirations.
- Views use Rails escaping helpers; avoid `raw`, `html_safe`, and unsafe redirects.
- Domain rules live in models and form objects.

## Run Locally

```bash
bundle install --path vendor/bundle
bundle exec rails db:prepare
bundle exec rails server
```

The `rs` shell alias can also run the Rails server when the oh-my-zsh Rails plugin is available.

## Test

```bash
bundle exec rails test
```

The test suite covers model validations, availability, payment preparation, calendar events, Stripe webhook processing, and critical booking/confirmation flows.

## Project Memory

Project preferences live in `PROJECT_PREFERENCES.md`.

Working context for future agent sessions lives in `CLAUDE.md`; update it whenever an internal feature or meaningful modification is completed.

## Legacy Static Prototype

The original single-file static prototype has been archived at:

```text
docs/archive/legacy-index.html
```

Do not build new features in the archived file.
