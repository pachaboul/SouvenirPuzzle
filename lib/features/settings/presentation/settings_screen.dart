import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/puzzle_providers.dart';
import '../../../data/repositories/settings_providers.dart';

/// Lets the user adjust sound, vibration, theme, privacy and clear history.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _clearHistory(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer tous les souvenirs ?'),
        content: const Text(
          'Tous vos puzzles et leurs miniatures seront supprimés. '
          'Vos photos d\'origine ne sont pas touchées.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(puzzleRepositoryProvider).clearAllSessions();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Souvenirs effacés.')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: SafeArea(
        child: settingsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Erreur : $e')),
          data: (settings) => ListView(
            children: [
              const _SectionTitle('Jeu'),
              SwitchListTile(
                secondary: const Icon(Icons.volume_up_outlined),
                title: const Text('Son'),
                value: settings.soundEnabled,
                onChanged: controller.setSoundEnabled,
              ),
              SwitchListTile(
                secondary: const Icon(Icons.vibration),
                title: const Text('Vibration'),
                value: settings.vibrationEnabled,
                onChanged: controller.setVibrationEnabled,
              ),
              const Divider(height: 32),
              const _SectionTitle('Apparence'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.light,
                      icon: Icon(Icons.light_mode_outlined),
                      label: Text('Clair'),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      icon: Icon(Icons.dark_mode_outlined),
                      label: Text('Sombre'),
                    ),
                    ButtonSegment(
                      value: ThemeMode.system,
                      icon: Icon(Icons.brightness_auto_outlined),
                      label: Text('Système'),
                    ),
                  ],
                  selected: {settings.themeMode},
                  onSelectionChanged: (selection) =>
                      controller.setThemeMode(selection.first),
                ),
              ),
              const Divider(height: 32),
              const _SectionTitle('Confidentialité'),
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
                            'Votre vie privée compte. Souvenir Puzzle ne '
                            'téléverse pas vos photos : tout reste sur votre '
                            'téléphone.',
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
                  'Effacer tous les souvenirs',
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
