import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/presentation/home_screen.dart';
import '../../memories/presentation/memories_screen.dart';
import '../../settings/presentation/settings_screen.dart';

/// Hosts the main tabs (Home / Memories / Settings) with a shared hamburger
/// drawer and bottom navigation. The in-progress puzzle is pushed on top of
/// this shell, so it has neither the drawer nor the bottom bar.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _index = 0;

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  void _go(int index) {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: _AppDrawer(currentIndex: _index, onSelect: _go),
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onMenu: _openDrawer, onOpenMemories: () => _go(1)),
          MemoriesScreen(onMenu: _openDrawer),
          SettingsScreen(onMenu: _openDrawer),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _go,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.photo_library_outlined),
            selectedIcon: const Icon(Icons.photo_library),
            label: l.homeMyMemories,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l.settingsTitle,
          ),
        ],
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer({required this.currentIndex, required this.onSelect});

  final int currentIndex;
  final void Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.bleuNuit, AppColors.bleuSecondaire],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/logo-souvenirpuzzle.png',
                  height: 64,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.extension_outlined,
                    size: 56,
                    color: AppColors.or,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l.appName,
                  style: const TextStyle(
                    color: AppColors.or,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  l.splashTagline,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          _DrawerItem(
            icon: Icons.home_outlined,
            label: l.navHome,
            selected: currentIndex == 0,
            onTap: () => onSelect(0),
          ),
          _DrawerItem(
            icon: Icons.photo_library_outlined,
            label: l.homeMyMemories,
            selected: currentIndex == 1,
            onTap: () => onSelect(1),
          ),
          _DrawerItem(
            icon: Icons.settings_outlined,
            label: l.settingsTitle,
            selected: currentIndex == 2,
            onTap: () => onSelect(2),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${l.appName} · v1.1.0',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        icon,
        color: selected ? theme.colorScheme.primary : null,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: selected ? theme.colorScheme.primary : null,
          fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
        ),
      ),
      selected: selected,
      onTap: onTap,
    );
  }
}
