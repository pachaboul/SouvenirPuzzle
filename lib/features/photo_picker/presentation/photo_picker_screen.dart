import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/app_constants.dart';
import '../../difficulty/presentation/difficulty_screen.dart';

/// Lets the user pick a photo from the gallery and preview it before continuing.
class PhotoPickerScreen extends StatefulWidget {
  const PhotoPickerScreen({super.key});

  @override
  State<PhotoPickerScreen> createState() => _PhotoPickerScreenState();
}

class _PhotoPickerScreenState extends State<PhotoPickerScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _picking = false;

  Future<void> _pick() async {
    setState(() => _picking = true);
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null && mounted) {
        setState(() => _image = File(picked.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible d\'ouvrir la galerie : $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  void _continue() {
    final image = _image;
    if (image == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DifficultyScreen(image: image)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final image = _image;
    return Scaffold(
      appBar: AppBar(title: const Text('Choisir une photo')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: image == null
                    ? _PhotoPlaceholder(onTap: _picking ? null : _pick)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox.expand(
                          child: Image.file(image, fit: BoxFit.contain),
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.lock_outline,
                      size: 16, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      AppConstants.privacyNote,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _picking ? null : _pick,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(
                  image == null ? 'Choisir une photo' : 'Changer de photo',
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: image == null ? null : _continue,
                child: const Text('Continuer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.outlineVariant, width: 2),
        ),
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined,
                size: 72, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Touchez pour choisir une photo',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
