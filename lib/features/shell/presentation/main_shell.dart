import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../contact/presentation/contact_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../memories/presentation/memories_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../stats/presentation/stats_screen.dart';

class _NavDestination {
  const _NavDestination(this.icon, this.selectedIcon, this.label);
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// Hosts the main tabs (Home / Memories / Settings) with a shared hamburger
/// drawer and a floating bottom navigation bar. The in-progress puzzle is
/// pushed on top of this shell, so it has neither the drawer nor the bottom bar.
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

  void _openPage(Widget page) {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final destinations = [
      _NavDestination(Icons.home_outlined, Icons.home, l.navHome),
      _NavDestination(
        Icons.photo_library_outlined,
        Icons.photo_library,
        l.homeMyMemories,
      ),
      _NavDestination(Icons.settings_outlined, Icons.settings, l.settingsTitle),
    ];

    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      drawer: _AppDrawer(
        currentIndex: _index,
        onSelect: _go,
        onStats: () => _openPage(const StatsScreen()),
        onContact: () => _openPage(const ContactScreen()),
      ),
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onMenu: _openDrawer, onOpenMemories: () => _go(1)),
          MemoriesScreen(onMenu: _openDrawer),
          SettingsScreen(onMenu: _openDrawer),
        ],
      ),
      bottomNavigationBar: _FuturisticNavBar(
        index: _index,
        destinations: destinations,
        onSelect: _go,
      ),
    );
  }
}

/// Floating pill-style navigation bar with an animated gold indicator.
class _FuturisticNavBar extends StatelessWidget {
  const _FuturisticNavBar({
    required this.index,
    required this.destinations,
    required this.onSelect,
  });

  final int index;
  final List<_NavDestination> destinations;
  final void Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        height: 66,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.bleuNuit, AppColors.bleuSecondaire],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.bleuNuit.withValues(alpha: 0.45),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: AppColors.or.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var i = 0; i < destinations.length; i++)
              _NavItem(
                destination: destinations[i],
                selected: i == index,
                onTap: () => onSelect(i),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: selected ? 18 : 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [AppColors.orClair, AppColors.or],
                )
              : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.or.withValues(alpha: 0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              selected ? destination.selectedIcon : destination.icon,
              color: selected ? AppColors.encre : Colors.white70,
              size: 24,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              child: selected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        destination.label,
                        style: const TextStyle(
                          color: AppColors.encre,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dark, premium drawer with gold "pill" navigation items.
class _AppDrawer extends StatelessWidget {
  const _AppDrawer({
    required this.currentIndex,
    required this.onSelect,
    required this.onStats,
    required this.onContact,
  });

  final int currentIndex;
  final void Function(int) onSelect;
  final VoidCallback onStats;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Drawer(
      backgroundColor: AppColors.bleuNuit,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bleuSecondaire, AppColors.bleuNuit],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
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
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
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
              const SizedBox(height: 4),
              _DrawerItem(
                icon: Icons.bar_chart_outlined,
                label: l.statsTitle,
                selected: false,
                onTap: onStats,
              ),
              _DrawerItem(
                icon: Icons.support_agent_outlined,
                label: l.contactTitle,
                selected: false,
                onTap: onContact,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  '${l.appName} · v1.1.0',
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: selected
                  ? const LinearGradient(
                      colors: [AppColors.orClair, AppColors.or],
                    )
                  : null,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selected ? AppColors.encre : Colors.white70,
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? AppColors.encre : Colors.white,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
