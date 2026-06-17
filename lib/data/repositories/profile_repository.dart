import 'dart:io';

import 'package:uuid/uuid.dart';

import '../../core/services/file_storage_service.dart';
import '../local/app_database.dart';
import '../local/profile_dao.dart';
import '../local/puzzle_result_dao.dart';
import '../local/puzzle_session_dao.dart';
import '../local/settings_dao.dart';
import '../models/user_profile.dart';

class ProfileDeleteException implements Exception {
  const ProfileDeleteException(this.message);

  final String message;

  static const lastProfile = ProfileDeleteException('last_profile');
}

class ProfileState {
  const ProfileState({
    required this.profiles,
    required this.activeProfileId,
  });

  final List<UserProfile> profiles;
  final String activeProfileId;

  UserProfile get activeProfile =>
      profiles.firstWhere((p) => p.id == activeProfileId);
}

class ProfileRepository {
  ProfileRepository({
    required AppDatabase database,
    required FileStorageService storage,
  })  : _profiles = ProfileDao(database),
        _sessions = PuzzleSessionDao(database),
        _results = PuzzleResultDao(database),
        _settings = SettingsDao(database),
        _storage = storage;

  final ProfileDao _profiles;
  final PuzzleSessionDao _sessions;
  final PuzzleResultDao _results;
  final SettingsDao _settings;
  final FileStorageService _storage;
  final Uuid _uuid = const Uuid();

  static const String _kActiveProfile = 'active_profile_id';

  Future<ProfileState> load() async {
    var profiles = await _profiles.getAll();
    if (profiles.isEmpty) {
      final defaultProfile = UserProfile(
        id: ProfileIds.legacyDefault,
        name: 'Joueur',
        createdAt: DateTime.now(),
      );
      await _profiles.insert(defaultProfile);
      await _settings.set(_kActiveProfile, defaultProfile.id);
      profiles = [defaultProfile];
    }

    final settingsMap = await _settings.getAll();
    final activeId = settingsMap[_kActiveProfile];
    final resolved = activeId != null && profiles.any((p) => p.id == activeId)
        ? activeId
        : profiles.first.id;
    if (resolved != activeId) {
      await _settings.set(_kActiveProfile, resolved);
    }

    return ProfileState(profiles: profiles, activeProfileId: resolved);
  }

  Future<UserProfile> create({
    required String name,
    File? avatarSource,
  }) async {
    final id = _uuid.v4();
    String? avatarPath;
    if (avatarSource != null) {
      avatarPath = await _storage.saveProfileAvatar(id, avatarSource);
    }
    final profile = UserProfile(
      id: id,
      name: name.trim(),
      createdAt: DateTime.now(),
      avatarPath: avatarPath,
    );
    await _profiles.insert(profile);
    return profile;
  }

  Future<void> setActiveProfile(String profileId) async {
    await _settings.set(_kActiveProfile, profileId);
  }

  Future<UserProfile> updateAvatar(UserProfile profile, File source) async {
    if (profile.avatarPath != null) {
      await _storage.deleteFile(profile.avatarPath);
    }
    final path = await _storage.saveProfileAvatar(profile.id, source);
    final updated = profile.copyWith(avatarPath: path);
    await _profiles.update(updated);
    return updated;
  }

  Future<UserProfile> updateProfile({
    required UserProfile profile,
    required String name,
    File? avatarSource,
  }) async {
    var updated = profile.copyWith(name: name.trim());
    if (avatarSource != null) {
      if (profile.avatarPath != null) {
        await _storage.deleteFile(profile.avatarPath);
      }
      final path = await _storage.saveProfileAvatar(profile.id, avatarSource);
      updated = updated.copyWith(avatarPath: path);
    }
    await _profiles.update(updated);
    return updated;
  }

  /// Deletes a profile and all its data. Returns the new active profile id when
  /// the deleted profile was active, otherwise null.
  Future<String?> deleteProfile(String profileId) async {
    if (await _profiles.count() <= 1) {
      throw ProfileDeleteException.lastProfile;
    }

    final sessions = await _sessions.getAll(profileId);
    for (final session in sessions) {
      await _storage.deleteFile(session.imagePath);
      await _storage.deleteFile(session.thumbnailPath);
    }
    await _sessions.deleteAllForProfile(profileId);
    await _results.deleteAllForProfile(profileId);

    final profile = await _profiles.getById(profileId);
    if (profile?.avatarPath != null) {
      await _storage.deleteFile(profile!.avatarPath);
    }
    await _profiles.delete(profileId);

    final settingsMap = await _settings.getAll();
    final activeId = settingsMap[_kActiveProfile];
    if (activeId != profileId) return null;

    final remaining = await _profiles.getAll();
    final newActive = remaining.first.id;
    await _settings.set(_kActiveProfile, newActive);
    return newActive;
  }
}
