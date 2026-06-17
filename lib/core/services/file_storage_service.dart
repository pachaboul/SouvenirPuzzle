import 'dart:io';
import 'dart:ui' as ui;

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Stores a local optimized copy + thumbnail for each puzzle, so memories stay
/// replayable even if the original photo is removed from the gallery.
///
/// Everything stays on-device under `app_documents/souvenir_puzzle/`.
class FileStorageService {
  static const String _root = 'souvenir_puzzle';
  static const int _thumbnailWidth = 320;

  Future<Directory> _subDir(String name) async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, _root, name));
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir;
  }

  /// Copies the source photo into the app's local images folder.
  Future<String> saveOptimizedImage(String sessionId, File source) async {
    final dir = await _subDir('images');
    final ext = p.extension(source.path).isEmpty
        ? '.jpg'
        : p.extension(source.path);
    final dest = p.join(dir.path, '$sessionId$ext');
    await source.copy(dest);
    return dest;
  }

  /// Generates a small PNG thumbnail for the history list. Returns null on
  /// failure (the UI falls back to a placeholder).
  Future<String?> saveThumbnail(String sessionId, File source) async {
    try {
      final bytes = await source.readAsBytes();
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: _thumbnailWidth,
      );
      final frame = await codec.getNextFrame();
      final data = await frame.image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      frame.image.dispose();
      if (data == null) return null;

      final dir = await _subDir('thumbnails');
      final dest = p.join(dir.path, '$sessionId.png');
      await File(dest).writeAsBytes(data.buffer.asUint8List());
      return dest;
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteFile(String? path) async {
    if (path == null) return;
    final file = File(path);
    if (await file.exists()) await file.delete();
  }

  /// Saves a square avatar for a local profile.
  Future<String> saveProfileAvatar(String profileId, File source) async {
    final dir = await _subDir('avatars');
    final ext = p.extension(source.path).isEmpty
        ? '.jpg'
        : p.extension(source.path);
    final dest = p.join(dir.path, '$profileId$ext');
    await source.copy(dest);
    return dest;
  }
}
