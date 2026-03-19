import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'bloc/poll_bloc.dart';
import 'bloc/poll_event.dart';
import 'data/repositories/poll_repository_impl.dart';
import 'ui/about_page.dart';
import 'ui/app_shell.dart';
import 'ui/poll_page.dart';

GoRouter buildRouter({required String apiBaseUrl}) {
  return GoRouter(
    initialLocation: '/poll',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          // ── Tab 1: Poll ────────────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/poll',
                builder: (context, state) => BlocProvider(
                  create: (_) => PollBloc(
                    repository: PollRepositoryImpl(baseUrl: apiBaseUrl),
                  )..add(const PollsLoadRequested()),
                  child: const PollPage(),
                ),
              ),
            ],
          ),
          // ── Tab 2: About ───────────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/about',
                builder: (context, state) => const AboutPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
