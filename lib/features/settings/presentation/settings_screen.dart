import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/aurora_background.dart';
import '../../../core/widgets/aurora_page.dart';
import '../../../data/models/app_settings.dart';
import '../../../data/repositories/puzzle_providers.dart';
import '../../../data/repositories/settings_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../contact/presentation/contact_screen.dart';

/// Lets the user adjust sound, vibration, theme, language, privacy and history.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key, this.onMenu});

  /// Opens the app drawer when hosted in the shell.
  final VoidCallback? onMenu;

  Future<void> _clearHistory(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.settingsClearTitle),
        content: Text(l.settingsClearBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.commonErase),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(puzzleRepositoryProvider).clearAllSessions();
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l.settingsCleared)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final settingsAsync = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return AuroraPage(
      title: l.settingsTitle,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      leading: onMenu == null
          ? null
          : IconButton(
              icon: const Icon(Icons.menu),
              tooltip: l.menu,
              onPressed: onMenu,
            ),
      child: settingsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: AppColors.or)),
        error: (e, _) => Center(
          child: Text(
            l.errorPrefix('$e'),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        data: (settings) => ListView(
          padding: const EdgeInsets.only(bottom: 96),
          children: [
            _GlassSection(
              title: l.settingsSectionGame,
              child: Column(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(
                      Icons.volume_up_outlined,
                      color: Colors.white,
                    ),
                    title: Text(
                      l.settingsSound,
                      style: const TextStyle(color: Colors.white),
                    ),
                    value: settings.soundEnabled,
                    activeColor: AppColors.or,
                    onChanged: controller.setSoundEnabled,
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.vibration, color: Colors.white),
                    title: Text(
                      l.settingsVibration,
                      style: const TextStyle(color: Colors.white),
                    ),
                    value: settings.vibrationEnabled,
                    activeColor: AppColors.or,
                    onChanged: controller.setVibrationEnabled,
                  ),
                ],
              ),
            ),
            _GlassSection(
              title: l.settingsSectionAppearance,
              child: SegmentedButton<ThemeMode>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text(l.themeLight),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text(l.themeDark),
                  ),
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text(l.themeSystem),
                  ),
                ],
                selected: {settings.themeMode},
                onSelectionChanged: (s) => controller.setThemeMode(s.first),
              ),
            ),
            _GlassSection(
              title: l.settingsLanguage,
              child: SegmentedButton<AppLanguage>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: AppLanguage.system,
                    label: Text(l.languageSystem),
                  ),
                  ButtonSegment(
                    value: AppLanguage.french,
                    label: Text(l.languageFrench),
                  ),
                  ButtonSegment(
                    value: AppLanguage.english,
                    label: Text(l.languageEnglish),
                  ),
                ],
                selected: {settings.language},
                onSelectionChanged: (s) => controller.setLanguage(s.first),
              ),
            ),
            _GlassSection(
              title: l.settingsSectionPrivacy,
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.or),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l.settingsPrivacyText,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GlassCard(
              padding: EdgeInsets.zero,
              borderRadius: 18,
              child: ListTile(
                leading: const Icon(Icons.support_agent_outlined,
                    color: Colors.white),
                title: Text(
                  l.contactTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing:
                    const Icon(Icons.chevron_right, color: Colors.white54),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ContactScreen()),
                ),
              ),
            ),
            const SizedBox(height: 14),
            GlassCard(
              padding: EdgeInsets.zero,
              tint: AppColors.rouge,
              child: ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.white),
                title: Text(
                  l.settingsClearHistory,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => _clearHistory(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A titled frosted-glass settings section.
class _GlassSection extends StatelessWidget {
  const _GlassSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
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
          ),
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            borderRadius: 18,
            child: child,
          ),
        ],
      ),
    );
  }
}
