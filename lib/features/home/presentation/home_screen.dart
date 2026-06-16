import 'package:flutter/material.dart';

import '../../../app/app_constants.dart';
import '../../memories/presentation/memories_screen.dart';
import '../../photo_picker/presentation/photo_picker_screen.dart';
import '../../settings/presentation/settings_screen.dart';

/// Entry screen: logo, tagline, and the main calls to action.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),
                      Image.asset(
                        'assets/images/logo-souvenirpuzzle.png',
                        height: 160,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.extension_outlined,
                          size: 120,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        AppConstants.appName,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppConstants.tagline,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PhotoPickerScreen(),
                          ),
                        ),
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                        label: const Text('Créer un puzzle'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const MemoriesScreen(),
                          ),
                        ),
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('Mes souvenirs'),
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        ),
                        icon: const Icon(Icons.settings_outlined),
                        label: const Text('Paramètres'),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
