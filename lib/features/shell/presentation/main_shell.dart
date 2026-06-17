import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_constants.dart';
import '../../../app/theme.dart';
import '../../../core/widgets/aurora_tokens.dart';
import '../../../core/widgets/profile_avatar_button.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/profile_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../about/presentation/about_screen.dart';
import '../../contact/presentation/contact_screen.dart';
import '../../get_started/presentation/get_started_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../memories/presentation/memories_screen.dart';
import '../../profile/presentation/profile_switcher_sheet.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../stats/presentation/stats_screen.dart';

class _NavDestination {
  const _NavDestination(this.icon, this.selectedIcon, this.label);
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// Hosts the main tabs (Home / Memories / Stats / Settings) with a shared
/// hamburger drawer and a floating bottom navigation bar.
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _index = 0;

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  void _openProfileSwitcher() {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
    showProfileSwitcherSheet(context, ref);
  }

  void _createProfile() {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
    showCreateProfileDialog(context);
  }

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
    final profileAsync = ref.watch(profileControllerProvider);

    return profileAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.or)),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (profileState) {
        final profileId = profileState.activeProfileId;
        final destinations = [
          _NavDestination(Icons.home_outlined, Icons.home, l.navHome),
          _NavDestination(
            Icons.photo_library_outlined,
            Icons.photo_library,
            l.homeMyMemories,
          ),
          _NavDestination(
            Icons.bar_chart_outlined,
            Icons.bar_chart,
            l.statsTitle,
          ),
          _NavDestination(
            Icons.settings_outlined,
            Icons.settings,
            l.settingsTitle,
          ),
        ];

        return Scaffold(
          key: _scaffoldKey,
          extendBody: true,
          drawer: _AppDrawer(
            currentIndex: _index,
            profileState: profileState,
            onSelect: _go,
            onSwitchProfile: _openProfileSwitcher,
            onCreateProfile: _createProfile,
            onProfileSelected: (id) async {
              await ref
                  .read(profileControllerProvider.notifier)
                  .switchProfile(id);
              if (mounted) setState(() {});
            },
            onGetStarted: () => _openPage(
              GetStartedScreen(onOpenMemories: () => _go(1)),
            ),
            onContact: () => _openPage(const ContactScreen()),
            onAbout: () => _openPage(const AboutScreen()),
          ),
          body: IndexedStack(
            index: _index,
            children: [
              HomeScreen(
                key: ValueKey('home-$profileId'),
                onMenu: _openDrawer,
                onProfile: _openProfileSwitcher,
                onOpenMemories: () => _go(1),
              ),
              MemoriesScreen(
                key: ValueKey('memories-$profileId'),
                onMenu: _openDrawer,
                onProfile: _openProfileSwitcher,
              ),
              StatsScreen(
                key: ValueKey('stats-$profileId'),
                onMenu: _openDrawer,
                onProfile: _openProfileSwitcher,
              ),
              SettingsScreen(
                key: ValueKey('settings-$profileId'),
                onMenu: _openDrawer,
                onProfile: _openProfileSwitcher,
              ),
            ],
          ),
          bottomNavigationBar: _FuturisticNavBar(
            index: _index,
            destinations: destinations,
            onSelect: _go,
          ),
        );
      },
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
    final tokens = AuroraTokens.of(context);
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: tokens.shellNavGradient),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: tokens.shellNavShadow,
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: AppColors.or.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            for (var i = 0; i < destinations.length; i++)
              Expanded(
                child: _NavItem(
                  destination: destinations[i],
                  selected: i == index,
                  onTap: () => onSelect(i),
                ),
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
    return Tooltip(
      message: destination.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 10),
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
          child: Center(
            child: Icon(
              selected ? destination.selectedIcon : destination.icon,
              color: selected ? AppColors.encre : AuroraTokens.of(context).shellNavIcon,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

/// Dark, premium drawer with gold "pill" navigation items.
class _AppDrawer extends StatelessWidget {
  const _AppDrawer({
    required this.currentIndex,
    required this.profileState,
    required this.onSelect,
    required this.onSwitchProfile,
    required this.onCreateProfile,
    required this.onProfileSelected,
    required this.onGetStarted,
    required this.onContact,
    required this.onAbout,
  });

  final int currentIndex;
  final ProfileState? profileState;
  final void Function(int) onSelect;
  final VoidCallback onSwitchProfile;
  final VoidCallback onCreateProfile;
  final void Function(String profileId) onProfileSelected;
  final VoidCallback onGetStarted;
  final VoidCallback onContact;
  final VoidCallback onAbout;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tokens = AuroraTokens.of(context);
    return Drawer(
      backgroundColor: tokens.drawerGradient.last,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: tokens.drawerGradient,
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
                      style: TextStyle(
                        color: tokens.drawerMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (profileState != null) ...[
                _DrawerSectionTitle(l.profilesSwitch),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: SizedBox(
                    height: 76,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: profileState!.profiles.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        if (index == profileState!.profiles.length) {
                          return _AddProfileChip(onTap: onCreateProfile);
                        }
                        final profile = profileState!.profiles[index];
                        final selected =
                            profile.id == profileState!.activeProfileId;
                        return _DrawerProfileChip(
                          profile: profile,
                          selected: selected,
                          onTap: () => onProfileSelected(profile.id),
                        );
                      },
                    ),
                  ),
                ),
                const _DrawerDivider(),
              ],
              // —— Jouer (actions les plus fréquentes) ——
              _DrawerSectionTitle(l.menuSectionPlay),
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
                icon: Icons.play_circle_outline,
                label: l.getStartedTitle,
                selected: false,
                onTap: onGetStarted,
              ),
              const _DrawerDivider(),
              // —— Progression & réglages ——
              _DrawerSectionTitle(l.menuSectionProgress),
              _DrawerItem(
                icon: Icons.bar_chart_outlined,
                label: l.statsTitle,
                selected: currentIndex == 2,
                onTap: () => onSelect(2),
              ),
              _DrawerItem(
                icon: Icons.settings_outlined,
                label: l.settingsTitle,
                selected: currentIndex == 3,
                onTap: () => onSelect(3),
              ),
              const _DrawerDivider(),
              // —— Informations & support ——
              _DrawerSectionTitle(l.menuSectionInfo),
              _DrawerItem(
                icon: Icons.info_outline,
                label: l.aboutTitle,
                selected: false,
                onTap: onAbout,
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
                  '${l.appName} · v${AppConstants.version}',
                  style: TextStyle(color: tokens.drawerFooter, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerProfileChip extends StatelessWidget {
  const _DrawerProfileChip({
    required this.profile,
    required this.selected,
    required this.onTap,
  });

  final UserProfile profile;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          children: [
            ProfileAvatarChip(profile: profile, selected: selected, size: 44),
            const SizedBox(height: 4),
            Text(
              profile.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? AppColors.or : tokens.drawerItemText,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddProfileChip extends StatelessWidget {
  const _AddProfileChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.or.withValues(alpha: 0.5)),
                color: AuroraTokens.of(context).surfaceSubtle,
              ),
              child: const Icon(Icons.add, color: AppColors.or, size: 22),
            ),
            const SizedBox(height: 4),
            Text(
              '+',
              style: TextStyle(
                color: AuroraTokens.of(context).drawerItemText,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerSectionTitle extends StatelessWidget {
  const _DrawerSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: tokens.drawerSection,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _DrawerDivider extends StatelessWidget {
  const _DrawerDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Divider(height: 1, color: AuroraTokens.of(context).divider),
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
    final tokens = AuroraTokens.of(context);
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
                  color: selected ? AppColors.encre : tokens.drawerItemIcon,
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? AppColors.encre : tokens.drawerItemText,
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
