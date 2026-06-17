import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'aurora_background.dart';
import 'aurora_tokens.dart';

/// Uppercase gold section heading used on support/about pages.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.or,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

/// Tappable glass row for email, Orange Money, PayPal, etc.
class SupportTile extends StatelessWidget {
  const SupportTile({
    super.key,
    required this.icon,
    required this.accent,
    required this.label,
    required this.value,
    required this.onTap,
    this.onCopy,
    this.trailing,
  });

  final IconData icon;
  final Color accent;
  final String label;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onCopy;
  final IconData? trailing;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      borderRadius: 18,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: tokens.onGlassMuted, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: tokens.onGlass,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              trailing ?? Icons.copy,
              color: tokens.onGlassMuted,
              size: 20,
            ),
            onPressed: onCopy ?? onTap,
          ),
        ],
      ),
    );
  }
}

/// Compact bullet row for feature/value lists on the About page.
class AboutBullet extends StatelessWidget {
  const AboutBullet({
    super.key,
    required this.icon,
    required this.text,
    this.accent = AppColors.or,
  });

  final IconData icon;
  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accent, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: tokens.onGlass,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
