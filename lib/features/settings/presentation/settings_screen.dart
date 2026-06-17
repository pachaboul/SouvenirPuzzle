import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/app_settings.dart';
import '../../../data/repositories/puzzle_providers.dart';
import '../../../data/repositories/settings_providers.dart';
import '../../../l10n/app_localizations.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.settingsCleared)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final settingsAsync = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: onMenu == null
            ? null
            : IconButton(
                icon: const Icon(Icons.menu),
                tooltip: l.menu,
                onPressed: onMenu,
              ),
        title: Text(l.settingsTitle),
      ),
      body: SafeArea(
        child: settingsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(l.errorPrefix('$e'))),
          data: (settings) => ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              _SectionTitle(l.settingsSectionGame),
              SwitchListTile(
                secondary: const Icon(Icons.volume_up_outlined),
                title: Text(l.settingsSound),
                value: settings.soundEnabled,
                onChanged: controller.setSoundEnabled,
              ),
              SwitchListTile(
                secondary: const Icon(Icons.vibration),
                title: Text(l.settingsVibration),
                value: settings.vibrationEnabled,
                onChanged: controller.setVibrationEnabled,
              ),
              const Divider(height: 32),
              _SectionTitle(l.settingsSectionAppearance),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<ThemeMode>(
                  segments: [
                    ButtonSegment(
                      value: ThemeMode.light,
                      icon: const Icon(Icons.light_mode_outlined),
                      label: Text(l.themeLight),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      icon: const Icon(Icons.dark_mode_outlined),
                      label: Text(l.themeDark),
                    ),
                    ButtonSegment(
                      value: ThemeMode.system,
                      icon: const Icon(Icons.brightness_auto_outlined),
                      label: Text(l.themeSystem),
                    ),
                  ],
                  selected: {settings.themeMode},
                  onSelectionChanged: (selection) =>
                      controller.setThemeMode(selection.first),
                ),
              ),
              const SizedBox(height: 16),
              _SectionTitle(l.settingsLanguage),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<AppLanguage>(
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
                  onSelectionChanged: (selection) =>
                      controller.setLanguage(selection.first),
                ),
              ),
              const Divider(height: 32),
              _SectionTitle(l.settingsSectionPrivacy),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.shield_outlined,
                            color: theme.colorScheme.primary),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            l.settingsPrivacyText,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(height: 32),
              ListTile(
                leading: Icon(Icons.delete_outline,
                    color: theme.colorScheme.error),
                title: Text(
                  l.settingsClearHistory,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
                onTap: () => _clearHistory(context, ref),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
