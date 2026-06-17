import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/aurora_background.dart';
import '../../../l10n/app_localizations.dart';
import '../../photo_picker/presentation/photo_picker_screen.dart';
import '../../puzzle/presentation/play_random.dart';

/// Home tab — aurora backdrop with glassmorphism content: a logo/title header
/// and the two primary actions (create a puzzle / play a random memory).
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
      extendBodyBehindAppBar: true,
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
      body: AuroraBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              children: [
                const Spacer(flex: 2),
                Image.asset(
                  'assets/images/logo-souvenirpuzzle.png',
                  height: 132,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.extension_outlined,
                    size: 104,
                    color: AppColors.or,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l.appName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l.homeTagline,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const Spacer(flex: 3),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _GlassAction(
                          label: l.homeCreatePuzzle,
                          icon: Icons.add_photo_alternate_outlined,
                          accent: const Color(0xFF3FA9F5),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const PhotoPickerScreen(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _GlassAction(
                          label: l.homePlay,
                          icon: Icons.shuffle,
                          accent: AppColors.or,
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
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassAction extends StatelessWidget {
  const _GlassAction({
    required this.label,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.5),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 28),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
