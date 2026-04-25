# Elixir Thor Platform

Monorepo for an AI platform with:

- Elixir umbrella backend services (Phoenix API + AI domain apps)
- Next.js frontend applications (web-client, admin-panel, system-control)

## Tech Stack

- Elixir 1.15+
- Phoenix 1.8 (in `apps/ai_api`)
- Next.js 16 + React 19 (in `frontend/*`)
- PNPM workspaces for frontend package management

## Repository Structure

~~~text
.
├── apps/
│   └── ai_api/         # Phoenix API app
├── config/             # Umbrella config
├── frontend/
│   ├── web-client/     # Next.js app
│   ├── admin-panel/    # Next.js app
│   └── system-control/ # Next.js app
└── mix.exs             # Umbrella mix project
~~~

## Prerequisites

- Elixir and Erlang/OTP installed
- Node.js 20+ recommended
- PNPM installed globally
- Docker (for infrastructure)

~~~bash
npm install -g pnpm
~~~

## Environment Configuration

Create `.env` from `.env.example` before using the root scripts:

~~~bash
cp .env.example .env
~~~

Update `.env` for your environment. Root helper scripts load it automatically.

## Elixir Backend (Umbrella)

From the repository root:

~~~bash
bash scripts/dev-all.sh get
~~~

Run the Phoenix API app:

~~~bash
bash scripts/dev-all.sh infra-up
bash scripts/dev-all.sh setup
cd apps/ai_api && mix phx.server
~~~

Phoenix API is available at http://localhost:4000.

### Backend Quality Checks

From the repository root:

~~~bash
bash scripts/dev-all.sh check
bash scripts/dev-all.sh format
bash scripts/dev-all.sh test
bash scripts/dev-all.sh precommit
bash scripts/setup-git-hooks.sh
~~~

Or run directly from `apps/ai_api`:

~~~bash
mix format
mix compile --warnings-as-errors
MIX_ENV=test mix test
mix precommit
~~~

If the test database does not exist yet:

~~~bash
cd apps/ai_api
MIX_ENV=test mix ecto.create --repo AiApi.Repo
~~~

To enable commit-time checks:

~~~bash
bash scripts/setup-git-hooks.sh
~~~

- `bash scripts/review-staged.sh`
- `bash scripts/dev-all.sh precommit`

### LiveDashboard OS Data

OS metrics are enabled through [apps/ai_api/mix.exs](apps/ai_api/mix.exs#L24). LiveDashboard is available in development at [apps/ai_api/lib/ai_api_web/router.ex](apps/ai_api/lib/ai_api_web/router.ex#L42).

Start the API:

~~~bash
cd apps/ai_api
mix phx.server
~~~

Open:

~~~text
http://localhost:4000/dev/dashboard
~~~

If OS Data is missing, restart the app and confirm `:dev_routes` is enabled.

Security note:

- Keep LiveDashboard in `dev` only, or protect it with auth and HTTPS.
- Dashboard auth uses `DASHBOARD_BASIC_AUTH_USER` and `DASHBOARD_BASIC_AUTH_PASS`.
- In local dev, if both vars are unset, dashboard access is allowed.

Recommended hardening for production:

- Gate this route behind role-based auth in your app (not only BasicAuth).
- Restrict access by IP/network at ingress or reverse proxy level.
- Serve only over HTTPS and do not expose it publicly.
- Set strong, rotated credentials in environment variables.

### SonarQube Scan

From the repository root, start SonarQube:

~~~bash
docker compose up -d sonarqube
~~~

Run a scan:

~~~bash
export SONAR_HOST="http://localhost:9000"
export SONAR_TOKEN="<your_token>"
bash scripts/dev-all.sh sonar
~~~

If `sonar-scanner` is not installed, use the Docker image instead:

~~~bash
docker run --rm \
  --network host \
  -e SONAR_HOST_URL="http://localhost:9000" \
  -e SONAR_TOKEN="<your_token>" \
  -v "$PWD:/usr/src" \
  sonarsource/sonar-scanner-cli
~~~

Open results at:

~~~text
http://localhost:9000/dashboard?id=elixir-thor-platform
~~~

Security note: never commit Sonar tokens to source files.

## Next.js Frontends

From `frontend`:

~~~bash
cd frontend
pnpm install
~~~

Run an app:

~~~bash
pnpm --filter web-client dev
pnpm --filter admin-panel dev
pnpm --filter system-control dev
~~~

If you run multiple apps at once, set unique ports:

~~~bash
pnpm --filter web-client dev -p 3000
pnpm --filter admin-panel dev -p 3001
pnpm --filter system-control dev -p 3002
~~~

Build and run one app:

~~~bash
pnpm --filter web-client build
pnpm --filter web-client start
~~~

Lint an app:

~~~bash
pnpm --filter web-client lint
~~~

## Typical Development Flow

1. `bash scripts/dev-all.sh infra-up`
2. `bash scripts/dev-all.sh setup`
3. `bash scripts/dev-all.sh dev`
4. Open the API at `http://localhost:4000`

## Root Script Modes

From the repository root:

~~~bash
bash scripts/dev-all.sh
~~~

Available modes:

~~~bash
# Start backend and all frontend apps in development
bash scripts/dev-all.sh dev

# Start backend and all frontend apps in production mode
bash scripts/dev-all.sh prod

# Build the Phoenix release and all frontend apps
bash scripts/dev-all.sh release-build

# Run the Phoenix release and frontend apps in production mode
bash scripts/dev-all.sh prod-release

# Install dependencies and create/migrate the database
bash scripts/dev-all.sh setup

# Drop, recreate, migrate, and seed the backend database
bash scripts/dev-all.sh reset-db

# Start local PostgreSQL and Redis services
bash scripts/dev-all.sh infra-up

# Stop local PostgreSQL and Redis services
bash scripts/dev-all.sh infra-down

# Install backend and frontend dependencies
bash scripts/dev-all.sh get

# Compile backend and build all frontend apps
bash scripts/dev-all.sh build

# Clean backend artifacts and frontend .next outputs
bash scripts/dev-all.sh clean

# Check format, warnings, and unused dependencies
bash scripts/dev-all.sh check

# Format Elixir code
bash scripts/dev-all.sh format

# Run backend tests; extra mix test args are supported
bash scripts/dev-all.sh test

# Run the full validation suite
bash scripts/dev-all.sh precommit
~~~

### Database and Caching Setup

Start infra:

~~~bash
bash scripts/dev-all.sh infra-up
~~~

Run setup:

~~~bash
bash scripts/dev-all.sh setup
~~~

Reset the backend database:

~~~bash
bash scripts/dev-all.sh reset-db
~~~

Start development:

~~~bash
bash scripts/dev-all.sh dev
~~~

Local defaults:

- PostgreSQL: `postgres://postgres:postgres@127.0.0.1:5432/ai_api_dev`
- Redis: `redis://127.0.0.1:6379/0`
- pgAdmin: `http://localhost:5050`
- RedisInsight: `http://localhost:5540`
- Nginx proxy: `http://api.localhost`

Production env:

- `DATABASE_URL`
- `DATABASE_READ_URL`
- `REDIS_URL`
- `REDIS_READ_URL`
- `SECRET_KEY_BASE`
- `DB_ENCRYPTION_KEY`

### API Endpoints

Health check:

~~~bash
curl http://localhost:4000/v1/health
~~~

Gateway endpoints:

~~~bash
curl http://localhost:4000/v1/admin/home
curl http://localhost:4000/v1/system/home
curl http://localhost:4000/v1/web/home
~~~

Dev tools:

~~~text
http://localhost:4000/dev/swaggerui
http://localhost:4000/dev/dashboard
~~~

### Local Service Endpoints

**PostgreSQL**
- Primary: `postgres://127.0.0.1:5432`
- Replica: `postgres://127.0.0.1:5433`

**Redis**
- Primary: `redis://127.0.0.1:6379`
- Replica: `redis://127.0.0.1:6380`

**Local tools**
- pgAdmin: `http://localhost:5050`
- RedisInsight: `http://localhost:5540`
- SonarQube: `http://localhost:9000`
- Nginx proxy for API routes: `http://api.localhost`

Defined in `docker-compose.yaml`.

### Production Deployment

Create production `.env`:

~~~bash
cp .env.example .env
# - MIX_ENV=prod
# - SECRET_KEY_BASE=<generated secret>
# - DATABASE_URL=<prod db>
# - DATABASE_READ_URL=<prod read replica db>
# - REDIS_URL=<prod redis>
# - REDIS_READ_URL=<prod read replica redis>
# - DB_ENCRYPTION_KEY=<base64 32-byte key>
# - PORT, PHX_HOST, etc.
~~~

Build and run:

~~~bash
bash scripts/dev-all.sh get
bash scripts/dev-all.sh release-build
bash scripts/dev-all.sh prod-release
~~~

Services:
- Phoenix API: `http://localhost:${PORT}` (default 4000)
- web-client: `http://localhost:3000`
- admin-panel: `http://localhost:3001`
- system-control: `http://localhost:3002`

## Notes

- The root `mix.exs` defines shared umbrella dependencies.
- Frontend apps are independent Next.js projects in a PNPM workspace.
