import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../puzzle/presentation/play_random.dart';
import '../../photo_picker/presentation/photo_picker_screen.dart';

/// Home tab: a premium hero header plus the two primary actions
/// (create a puzzle / play a random memory).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, this.onMenu, this.onOpenMemories});

  /// Opens the app drawer (null when not hosted in the shell).
  final VoidCallback? onMenu;

  /// Called when the user wants to play but has no memories yet.
  final VoidCallback? onOpenMemories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: onMenu == null
            ? null
            : IconButton(
                icon: const Icon(Icons.menu),
                tooltip: l.menu,
                onPressed: onMenu,
              ),
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          _Hero(appName: l.appName, tagline: l.homeTagline),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _ActionCard(
                            label: l.homeCreatePuzzle,
                            icon: Icons.add_photo_alternate_outlined,
                            background: AppColors.bleuNuit,
                            foreground: Colors.white,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PhotoPickerScreen(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ActionCard(
                            label: l.homePlay,
                            icon: Icons.shuffle,
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [AppColors.orClair, AppColors.or],
                            ),
                            foreground: AppColors.encre,
                            onTap: () => playRandomMemory(
                              context,
                              ref,
                              onEmpty: onOpenMemories,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.appName, required this.tagline});

  final String appName;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.bleuNuit, AppColors.bleuSecondaire],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: Stack(
        children: [
          // Decorative puzzle pieces.
          Positioned(
            top: 24,
            right: -10,
            child: Icon(
              Icons.extension,
              size: 120,
              color: AppColors.or.withValues(alpha: 0.10),
            ),
          ),
          Positioned(
            bottom: 8,
            left: -16,
            child: Icon(
              Icons.extension,
              size: 90,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 36),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo-souvenirpuzzle.png',
                    height: 120,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.extension_outlined,
                      size: 96,
                      color: AppColors.or,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    appName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.or,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tagline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.label,
    required this.icon,
    required this.foreground,
    required this.onTap,
    this.background,
    this.gradient,
  });

  final String label;
  final IconData icon;
  final Color foreground;
  final VoidCallback onTap;
  final Color? background;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            color: background,
            gradient: gradient,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: (background ?? AppColors.or).withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: foreground.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: foreground, size: 28),
                ),
                const SizedBox(height: 28),
                Text(
                  label,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
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
