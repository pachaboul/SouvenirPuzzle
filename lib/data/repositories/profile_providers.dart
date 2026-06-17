import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';
import 'app_providers.dart';
import 'profile_repository.dart';

export 'profile_repository.dart' show ProfileState;

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(
    database: ref.watch(appDatabaseProvider),
    storage: ref.watch(fileStorageServiceProvider),
  );
});

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, ProfileState>(
  ProfileController.new,
);

class ProfileController extends AsyncNotifier<ProfileState> {
  @override
  Future<ProfileState> build() =>
      ref.watch(profileRepositoryProvider).load();

  ProfileRepository get _repo => ref.read(profileRepositoryProvider);

  Future<void> switchProfile(String profileId) async {
    final current = state.requireValue;
    if (current.activeProfileId == profileId) return;
    await _repo.setActiveProfile(profileId);
    state = AsyncData(
      ProfileState(profiles: current.profiles, activeProfileId: profileId),
    );
  }

  Future<UserProfile> createProfile({
    required String name,
    File? avatarSource,
    bool activate = true,
  }) async {
    final profile = await _repo.create(name: name, avatarSource: avatarSource);
    final current = state.requireValue;
    final profiles = [...current.profiles, profile];
    if (activate) {
      await _repo.setActiveProfile(profile.id);
    }
    state = AsyncData(
      ProfileState(
        profiles: profiles,
        activeProfileId: activate ? profile.id : current.activeProfileId,
      ),
    );
    return profile;
  }

  Future<void> updateAvatar(String profileId, File source) async {
    final current = state.requireValue;
    final index = current.profiles.indexWhere((p) => p.id == profileId);
    if (index < 0) return;
    final updated = await _repo.updateAvatar(current.profiles[index], source);
    final profiles = [...current.profiles]..[index] = updated;
    state = AsyncData(
      ProfileState(
        profiles: profiles,
        activeProfileId: current.activeProfileId,
      ),
    );
  }

  Future<void> updateProfile({
    required String profileId,
    required String name,
    File? avatarSource,
  }) async {
    final current = state.requireValue;
    final index = current.profiles.indexWhere((p) => p.id == profileId);
    if (index < 0) return;
    final updated = await _repo.updateProfile(
      profile: current.profiles[index],
      name: name,
      avatarSource: avatarSource,
    );
    final profiles = [...current.profiles]..[index] = updated;
    state = AsyncData(
      ProfileState(
        profiles: profiles,
        activeProfileId: current.activeProfileId,
      ),
    );
  }

  Future<void> deleteProfile(String profileId) async {
    final current = state.requireValue;
    final newActiveId = await _repo.deleteProfile(profileId);
    final profiles =
        current.profiles.where((p) => p.id != profileId).toList();
    state = AsyncData(
      ProfileState(
        profiles: profiles,
        activeProfileId: newActiveId ?? current.activeProfileId,
      ),
    );
  }
}
