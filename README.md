# Hrefs - Link Redirection and Analytics

Server-rendered Rails app for creating short links, redirecting visitors, and tracking analytics.

## Implemented v1 scope

- Admin authentication using the Rails built-in `authentication` generator.
- Link CRUD with slug and destination URL validations.
- Public short-link route `/:slug` that:
	- checks missing/inactive/expired states,
	- records a `Visit`,
	- increments `clicks_count`,
	- redirects to destination URL.
- Dashboard analytics:
	- total links,
	- total visits,
	- visits in last 24h and 7d,
	- top links by clicks,
	- recent visits.
- Visits index with read-only analytics browsing, filters, and pagination.
- Link detail analytics with recent visits and QR display.

## Gem choices

- `bcrypt`: required by Rails built-in authentication for password hashing.
- `pagy`: lightweight pagination for links and visits tables.
- `user_agent`: enriches visit records with browser, OS, and device hints.
- `rqrcode`: QR code generation in admin UI for each short URL.

Geolocation (`country`/`city`) remains optional/nullable in v1 to keep setup simple.

## Local setup

1. Install dependencies:

```bash
bundle install
```

2. Ensure PostgreSQL is running and configured (see `config/database.yml`).

3. Create and migrate database:

```bash
bin/rails db:prepare
```

4. (Optional) Create an admin user in Rails console:

```bash
bin/rails console
User.create!(email_address: "admin@example.com", password: "password", password_confirmation: "password")
```

5. Start development server:

```bash
bin/dev
```

## Test suite

Run all tests:

```bash
bin/rails test
```

Run focused tests:

```bash
bin/rails test test/controllers/redirects_controller_test.rb
bin/rails test test/controllers/authentication_boundary_test.rb
bin/rails test test/models/link_test.rb test/models/visit_test.rb
```

## Notes

- Admin pages require authentication by default.
- Public redirect endpoint stays unauthenticated by design.
- Visit records are read-only in admin UI to preserve analytics integrity.
