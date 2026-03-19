<!-- nx configuration start-->
<!-- Leave the start & end comments to automatically receive updates. -->

# General Guidelines for working with Nx

- For navigating/exploring the workspace, invoke the `nx-workspace` skill first - it has patterns for querying projects, targets, and dependencies
- When running tasks (for example build, lint, test, e2e, etc.), always prefer running the task through `nx` (i.e. `nx run`, `nx run-many`, `nx affected`) instead of using the underlying tooling directly
- Prefix nx commands with the workspace's package manager (e.g., `pnpm nx build`, `npm exec nx test`) - avoids using globally installed CLI
- You have access to the Nx MCP server and its tools, use them to help the user
- For Nx plugin best practices, check `node_modules/@nx/<plugin>/PLUGIN.md`. Not all plugins have this file - proceed without it if unavailable.
- NEVER guess CLI flags - always check nx_docs or `--help` first when unsure

## Scaffolding & Generators

- For scaffolding tasks (creating apps, libs, project structure, setup), ALWAYS invoke the `nx-generate` skill FIRST before exploring or calling MCP tools

## When to use nx_docs

- USE for: advanced config options, unfamiliar flags, migration guides, plugin configuration, edge cases
- DON'T USE for: basic generator syntax (`nx g @nx/react:app`), standard commands, things you already know
- The `nx-generate` skill handles generator discovery internally - don't call nx_docs just to look up generator syntax

<!-- nx configuration end-->

Project Overview:
I am building a "Pre-emptive Strike" MVP application for an upcoming technical interview with Anketa tomorrow. The goal is to demonstrate my ability to build a full-stack application with a specific focus on Optimistic UI state management on the frontend.

Tech Stack:

Workspace: Nx Monorepo running inside a Docker DevContainer.
Backend: NestJS API with Prisma ORM (using v7 Early Access config syntax) and a local PostgreSQL database.
Frontend: Flutter mobile app using flutter_bloc (modern on<Event> syntax) for strict, clean state management.
Networking: The backend connects to Postgres via localhost:5432 (host networking), and Flutter connects to the local NestJS API.
Current State & Accomplishments:

DevContainer Setup: Completely configured with host networking and USB passthrough for Android physical device debugging.
Database & Backend:
PostgreSQL is running and the database is synced (db push applied).
The database is seeded with a dummy Poll and Option tables (e.g., "React Native vs Flutter?").
The NestJS API is up and running.
Crucial Detail: I intentionally injected a setTimeout (2-second artificial delay) into the NestJS POST /vote endpoint. This is specifically to prove to the interviewers that the Flutter UI updates optimistically before the network request actually completes.
Next Steps (Where I need your help):
We are now moving entirely to the Flutter frontend (apps/mobile). I need to:

Set up the Flutter BLoC architecture to consume the NestJS REST API.
Build a simple, clean UI to display the polling data.
Implement the Optimistic UI pattern in BLoC: When a user taps a poll option, the UI must update instantly. Behind the scenes, the app should fire the API request. If the request fails, it should roll back the state; if it succeeds (after the 2-second delay), it should seamlessly confirm the state.
Please acknowledge this context and provide a quick outline of how we should structure the BLoC events and state for this Optimistic UI implementation.Project Overview:
I am building a "Pre-emptive Strike" MVP application for an upcoming technical interview with Anketa tomorrow. The goal is to demonstrate my ability to build a full-stack application with a specific focus on Optimistic UI state management on the frontend.

Tech Stack:

Workspace: Nx Monorepo running inside a Docker DevContainer.
Backend: NestJS API with Prisma ORM (using v7 Early Access config syntax) and a local PostgreSQL database.
Frontend: Flutter mobile app using flutter_bloc (modern on<Event> syntax) for strict, clean state management.
Networking: The backend connects to Postgres via localhost:5432 (host networking), and Flutter connects to the local NestJS API.
Current State & Accomplishments:

DevContainer Setup: Completely configured with host networking and USB passthrough for Android physical device debugging.
Database & Backend:
PostgreSQL is running and the database is synced (db push applied).
The database is seeded with a dummy Poll and Option tables (e.g., "React Native vs Flutter?").
The NestJS API is up and running.
Crucial Detail: I intentionally injected a setTimeout (2-second artificial delay) into the NestJS POST /vote endpoint. This is specifically to prove to the interviewers that the Flutter UI updates optimistically before the network request actually completes.
Next Steps (Where I need your help):
We are now moving entirely to the Flutter frontend (apps/mobile). I need to:

Set up the Flutter BLoC architecture to consume the NestJS REST API.
Build a simple, clean UI to display the polling data.
Implement the Optimistic UI pattern in BLoC: When a user taps a poll option, the UI must update instantly. Behind the scenes, the app should fire the API request. If the request fails, it should roll back the state; if it succeeds (after the 2-second delay), it should seamlessly confirm the state.
Please acknowledge this context and provide a quick outline of how we should structure the BLoC events and state for this Optimistic UI implementation.
