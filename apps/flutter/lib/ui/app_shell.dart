import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shell scaffold that owns the bottom navigation bar.
/// go_router's StatefulShellRoute renders each tab's navigator into [navigationShell].
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF1A1A2E),
        indicatorColor: Colors.purpleAccent.withOpacity(0.3),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          // Return to original location of the branch if already selected
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.poll_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.poll, color: Colors.purpleAccent),
            label: 'Poll',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline, color: Colors.white54),
            selectedIcon: Icon(Icons.info, color: Colors.purpleAccent),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
