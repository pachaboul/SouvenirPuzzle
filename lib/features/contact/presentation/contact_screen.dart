import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/aurora_background.dart';
import '../../../core/widgets/aurora_page.dart';
import '../../../l10n/app_localizations.dart';

/// Contact & support page (aurora/glass): email + "buy me a coffee" options.
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  static const String email = 'pachaboul@gmail.com';
  static const String orangeMoney = '+223 77 01 08 08';
  static const String paypalUser = 'caboulhassane';
  static const String paypalUrl = 'https://paypal.me/caboulhassane';

  Future<void> _launch(BuildContext context, Uri uri) async {
    final l = AppLocalizations.of(context);
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) throw Exception('launch failed');
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.contactCouldNotOpen)),
        );
      }
    }
  }

  Future<void> _copy(BuildContext context, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).contactCopied)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AuroraPage(
      title: l.contactTitle,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: ListView(
        children: [
          Text(
            l.contactIntro,
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 20),
          _SectionLabel(l.contactSectionContact),
          _ContactTile(
            icon: Icons.mail_outline,
            accent: const Color(0xFF3FA9F5),
            label: l.contactEmailLabel,
            value: email,
            onTap: () => _launch(context, Uri(scheme: 'mailto', path: email)),
            onCopy: () => _copy(context, email),
          ),
          const SizedBox(height: 20),
          _SectionLabel(l.contactSectionCoffee),
          _ContactTile(
            icon: Icons.local_cafe_outlined,
            accent: AppColors.or,
            label: l.contactOrangeMoney,
            value: orangeMoney,
            onTap: () => _copy(context, orangeMoney),
            onCopy: () => _copy(context, orangeMoney),
          ),
          const SizedBox(height: 12),
          _ContactTile(
            icon: Icons.account_balance_wallet_outlined,
            accent: AppColors.violet,
            label: l.contactPaypal,
            value: '@$paypalUser',
            trailing: Icons.open_in_new,
            onTap: () => _launch(context, Uri.parse(paypalUrl)),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.title);

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

class _ContactTile extends StatelessWidget {
  const _ContactTile({
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
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(trailing ?? Icons.copy, color: Colors.white70, size: 20),
            onPressed: onCopy ?? onTap,
          ),
        ],
      ),
    );
  }
}
