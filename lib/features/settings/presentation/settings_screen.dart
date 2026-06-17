import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/aurora_background.dart';
import '../../../core/widgets/aurora_page.dart';
import '../../../core/widgets/aurora_tokens.dart';
import '../../../core/widgets/compact_layout.dart';
import '../../../core/widgets/profile_avatar_button.dart';
import '../../../data/models/app_settings.dart';
import '../../../data/repositories/puzzle_providers.dart';
import '../../../data/repositories/settings_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../contact/presentation/contact_screen.dart';

/// Lets the user adjust sound, vibration, theme, language, privacy and history.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key, this.onMenu, this.onProfile});

  /// Opens the app drawer when hosted in the shell.
  final VoidCallback? onMenu;
  final VoidCallback? onProfile;

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
    final tokens = AuroraTokens.of(context);

    return AuroraPage(
      title: l.settingsTitle,
      padding: CompactLayout.of(context)
          ? const EdgeInsets.fromLTRB(12, 4, 12, 12)
          : const EdgeInsets.fromLTRB(16, 8, 16, 24),
      leading: onMenu == null
          ? null
          : IconButton(
              icon: const Icon(Icons.menu),
              tooltip: l.menu,
              onPressed: onMenu,
            ),
      actions: onProfile == null
          ? null
          : [ProfileAvatarButton(onTap: onProfile!)],
      child: settingsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: AppColors.or)),
        error: (e, _) => Center(
          child: Text(
            l.errorPrefix('$e'),
            style: TextStyle(color: AuroraTokens.of(context).onGlass),
          ),
        ),
        data: (settings) => ListView(
          padding: EdgeInsets.only(
            bottom: CompactLayout.bottomNavClearance(context),
          ),
          children: [
            _GlassSection(
              title: l.settingsSectionGame,
              child: Column(
                children: [
                  _SettingsSwitchRow(
                    icon: Icons.volume_up_outlined,
                    label: l.settingsSound,
                    value: settings.soundEnabled,
                    onChanged: controller.setSoundEnabled,
                  ),
                  const Divider(height: 1, color: AppColors.cremeBordure),
                  _SettingsSwitchRow(
                    icon: Icons.vibration,
                    label: l.settingsVibration,
                    value: settings.vibrationEnabled,
                    onChanged: controller.setVibrationEnabled,
                  ),
                ],
              ),
            ),
            _GlassSection(
              title: l.settingsSectionAppearance,
              child: _ChipSelector<ThemeMode>(
                value: settings.themeMode,
                onChanged: controller.setThemeMode,
                options: [
                  (ThemeMode.light, l.themeLight),
                  (ThemeMode.dark, l.themeDark),
                  (ThemeMode.system, l.themeSystem),
                ],
              ),
            ),
            _GlassSection(
              title: l.settingsLanguage,
              child: _ChipSelector<AppLanguage>(
                value: settings.language,
                onChanged: controller.setLanguage,
                options: [
                  (AppLanguage.system, l.languageSystem),
                  (AppLanguage.french, l.languageFrench),
                  (AppLanguage.english, l.languageEnglish),
                ],
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
                      style: TextStyle(
                        color: tokens.onGlassMuted,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              borderRadius: 18,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ContactScreen()),
              ),
              child: Row(
                children: [
                  Icon(Icons.support_agent_outlined, color: tokens.onGlass),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      l.contactTitle,
                      style: TextStyle(
                        color: tokens.onGlass,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: tokens.onGlassSubtle),
                ],
              ),
            ),
            const SizedBox(height: 14),
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              borderRadius: 18,
              tint: AppColors.rouge,
              onTap: () => _clearHistory(context, ref),
              child: Row(
                children: [
                  const Icon(Icons.delete_outline, color: Colors.white),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      l.settingsClearHistory,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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

/// A titled frosted-glass settings section.
class _GlassSection extends StatelessWidget {
  const _GlassSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: CompactLayout.of(context) ? 10 : 14),
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

class _SettingsSwitchRow extends StatelessWidget {
  const _SettingsSwitchRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: tokens.onGlass, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: tokens.onGlass),
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: value,
              activeColor: AppColors.or,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

typedef _ChipOption<T> = (T value, String label);

/// Wrap-based selector that avoids [SegmentedButton] overflow on narrow widths.
class _ChipSelector<T> extends StatelessWidget {
  const _ChipSelector({
    required this.value,
    required this.onChanged,
    required this.options,
  });

  final T value;
  final ValueChanged<T> onChanged;
  final List<_ChipOption<T>> options;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in options)
          FilterChip(
            label: Text(option.$2),
            selected: value == option.$1,
            showCheckmark: false,
            selectedColor: AppColors.or.withValues(alpha: 0.35),
            checkmarkColor: AppColors.encre,
            labelStyle: TextStyle(
              color: value == option.$1 ? AppColors.encre : tokens.onGlass,
              fontWeight:
                  value == option.$1 ? FontWeight.w700 : FontWeight.w500,
            ),
            side: BorderSide(
              color: value == option.$1 ? AppColors.or : tokens.divider,
            ),
            onSelected: (_) => onChanged(option.$1),
          ),
      ],
    );
  }
}
