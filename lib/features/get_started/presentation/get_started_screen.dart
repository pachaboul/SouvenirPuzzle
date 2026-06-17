import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/aurora_background.dart';
import '../../../core/widgets/aurora_page.dart';
import '../../../core/widgets/aurora_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../photo_picker/presentation/photo_picker_screen.dart';

/// Onboarding guide: how to play, with shortcuts to create a puzzle or open memories.
class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key, this.onOpenMemories});

  /// Switches to the memories tab in [MainShell] after popping this page.
  final VoidCallback? onOpenMemories;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tokens = AuroraTokens.of(context);
    return AuroraPage(
      title: l.getStartedTitle,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                Text(
                  l.getStartedIntro,
                  style: TextStyle(
                    color: tokens.onGlassMuted,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                _StepCard(
                  number: 1,
                  icon: Icons.add_photo_alternate_outlined,
                  accent: const Color(0xFF3FA9F5),
                  title: l.getStartedStep1Title,
                  body: l.getStartedStep1Body,
                ),
                _StepCard(
                  number: 2,
                  icon: Icons.grid_view_rounded,
                  accent: AppColors.or,
                  title: l.getStartedStep2Title,
                  body: l.getStartedStep2Body,
                ),
                _StepCard(
                  number: 3,
                  icon: Icons.swap_horiz,
                  accent: AppColors.vert,
                  title: l.getStartedStep3Title,
                  body: l.getStartedStep3Body,
                ),
                _StepCard(
                  number: 4,
                  icon: Icons.emoji_events_outlined,
                  accent: AppColors.violet,
                  title: l.getStartedStep4Title,
                  body: l.getStartedStep4Body,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PhotoPickerScreen()),
            ),
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: Text(l.getStartedCreatePuzzle),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              onOpenMemories?.call();
            },
            icon: const Icon(Icons.photo_library_outlined),
            label: Text(l.getStartedOpenMemories),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.icon,
    required this.accent,
    required this.title,
    required this.body,
  });

  final int number;
  final IconData icon;
  final Color accent;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        borderRadius: 18,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: accent, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: tokens.onGlass,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    body,
                    style: TextStyle(
                      color: tokens.onGlassMuted,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
