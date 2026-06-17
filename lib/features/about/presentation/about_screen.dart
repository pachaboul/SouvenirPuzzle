import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/app_constants.dart';
import '../../../app/theme.dart';
import '../../../core/support/support_links.dart';
import '../../../core/widgets/aurora_background.dart';
import '../../../core/widgets/aurora_page.dart';
import '../../../core/widgets/aurora_tokens.dart';
import '../../../core/widgets/support_tile.dart';
import '../../../l10n/app_localizations.dart';
import '../../contact/presentation/contact_screen.dart';

/// App information: vision, values, privacy, and optional financial support.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
      title: l.aboutTitle,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: ListView(
        children: [
          Center(
            child: GlassCard(
              borderRadius: 28,
              padding: const EdgeInsets.all(24),
              child: Image.asset(
                'assets/images/logo-souvenirpuzzle.png',
                height: 100,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.extension_outlined,
                  size: 80,
                  color: AppColors.or,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l.appName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.or,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.splashTagline,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tokens.onGlass,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.homeTagline,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tokens.onGlassMuted,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          SectionLabel(l.aboutVision),
          GlassCard(
            borderRadius: 18,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.aboutIntro,
                  style: TextStyle(
                    color: tokens.onGlass,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l.aboutMission,
                  style: TextStyle(
                    color: tokens.onGlassMuted,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SectionLabel(l.aboutHowItWorks),
          GlassCard(
            borderRadius: 18,
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
            child: Column(
              children: [
                AboutBullet(
                  icon: Icons.add_photo_alternate_outlined,
                  accent: const Color(0xFF3FA9F5),
                  text: l.aboutFeature1,
                ),
                AboutBullet(
                  icon: Icons.grid_view_rounded,
                  accent: AppColors.or,
                  text: l.aboutFeature2,
                ),
                AboutBullet(
                  icon: Icons.swap_horiz,
                  accent: AppColors.vert,
                  text: l.aboutFeature3,
                ),
                AboutBullet(
                  icon: Icons.lock_outline,
                  accent: AppColors.violet,
                  text: l.aboutFeature4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SectionLabel(l.aboutStudio),
          GlassCard(
            borderRadius: 18,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.or.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite_outline, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.aboutStudioName,
                            style: TextStyle(
                              color: tokens.onGlass,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l.aboutStudioTagline,
                            style: TextStyle(
                              color: tokens.onGlassMuted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  l.aboutStudioBody,
                  style: TextStyle(
                    color: tokens.onGlassMuted,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SectionLabel(l.aboutPrivacyTitle),
          GlassCard(
            borderRadius: 18,
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.shield_outlined, color: AppColors.or, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l.aboutPrivacyBody,
                    style: TextStyle(
                      color: tokens.onGlass,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SectionLabel(l.aboutSupportTitle),
          GlassCard(
            borderRadius: 20,
            padding: const EdgeInsets.all(18),
            tint: AppColors.or,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColors.or,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_cafe_rounded,
                        color: AppColors.encre,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        l.aboutSupportHeadline,
                        style: TextStyle(
                          color: tokens.onTintedCard,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  l.aboutSupportIntro,
                  style: TextStyle(
                    color: tokens.onTintedCard,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l.aboutSupportWhy,
                  style: TextStyle(
                    color: tokens.onTintedCard.withValues(alpha: 0.75),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SupportTile(
            icon: Icons.local_cafe_outlined,
            accent: AppColors.or,
            label: l.contactOrangeMoney,
            value: SupportLinks.orangeMoney,
            onTap: () => _copy(context, SupportLinks.orangeMoney),
            onCopy: () => _copy(context, SupportLinks.orangeMoney),
          ),
          const SizedBox(height: 10),
          SupportTile(
            icon: Icons.account_balance_wallet_outlined,
            accent: AppColors.violet,
            label: l.contactPaypal,
            value: '@${SupportLinks.paypalUser}',
            trailing: Icons.open_in_new,
            onTap: () => _launch(context, Uri.parse(SupportLinks.paypalUrl)),
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 14),
          Text(
            l.aboutSupportThanks,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tokens.onGlassMuted,
              fontSize: 13,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ContactScreen()),
            ),
            icon: const Icon(Icons.support_agent_outlined),
            label: Text(l.aboutContactCta),
          ),
          const SizedBox(height: 24),
          Text(
            l.aboutVersion(AppConstants.version),
            textAlign: TextAlign.center,
            style: TextStyle(color: tokens.onGlassSubtle, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
