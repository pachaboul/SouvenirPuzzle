import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme.dart';
import '../../../core/support/support_links.dart';
import '../../../core/widgets/aurora_page.dart';
import '../../../core/widgets/aurora_tokens.dart';
import '../../../core/widgets/support_tile.dart';
import '../../../l10n/app_localizations.dart';

/// Contact & support page (aurora/glass): email + "buy me a coffee" options.
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

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
    final tokens = AuroraTokens.of(context);
    return AuroraPage(
      title: l.contactTitle,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: ListView(
        children: [
          Text(
            l.contactIntro,
            style: TextStyle(
              color: tokens.onGlassMuted,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          SectionLabel(l.contactSectionContact),
          SupportTile(
            icon: Icons.mail_outline,
            accent: const Color(0xFF3FA9F5),
            label: l.contactEmailLabel,
            value: SupportLinks.email,
            onTap: () => _launch(
              context,
              Uri(scheme: 'mailto', path: SupportLinks.email),
            ),
            onCopy: () => _copy(context, SupportLinks.email),
          ),
          const SizedBox(height: 20),
          SectionLabel(l.contactSectionCoffee),
          SupportTile(
            icon: Icons.local_cafe_outlined,
            accent: AppColors.or,
            label: l.contactOrangeMoney,
            value: SupportLinks.orangeMoney,
            onTap: () => _copy(context, SupportLinks.orangeMoney),
            onCopy: () => _copy(context, SupportLinks.orangeMoney),
          ),
          const SizedBox(height: 12),
          SupportTile(
            icon: Icons.account_balance_wallet_outlined,
            accent: AppColors.violet,
            label: l.contactPaypal,
            value: '@${SupportLinks.paypalUser}',
            trailing: Icons.open_in_new,
            onTap: () => _launch(context, Uri.parse(SupportLinks.paypalUrl)),
          ),
        ],
      ),
    );
  }
}
