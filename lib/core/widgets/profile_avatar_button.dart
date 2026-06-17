import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/profile_providers.dart';

/// Profile photo / initial shown in the app header (top-right).
class ProfileAvatarButton extends ConsumerWidget {
  const ProfileAvatarButton({
    super.key,
    required this.onTap,
    this.size = 36,
  });

  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider).value?.activeProfile;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: _ProfileAvatar(profile: profile, size: size),
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.profile, required this.size});

  final UserProfile? profile;
  final double size;

  @override
  Widget build(BuildContext context) {
    final name = profile?.name ?? '?';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final path = profile?.avatarPath;
    final hasPhoto = path != null && File(path).existsSync();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.or, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.or.withValues(alpha: 0.35),
            blurRadius: 8,
          ),
        ],
        image: hasPhoto
            ? DecorationImage(
                image: FileImage(File(path)),
                fit: BoxFit.cover,
              )
            : null,
        color: hasPhoto ? null : AppColors.bleuSecondaire,
      ),
      alignment: Alignment.center,
      child: hasPhoto
          ? null
          : Text(
              initial,
              style: const TextStyle(
                color: AppColors.or,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
    );
  }
}

/// Compact avatar for lists (drawer, switcher).
class ProfileAvatarChip extends StatelessWidget {
  const ProfileAvatarChip({
    super.key,
    required this.profile,
    this.size = 40,
    this.selected = false,
  });

  final UserProfile profile;
  final double size;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.or : Colors.transparent,
          width: 2,
        ),
      ),
      child: _ProfileAvatar(profile: profile, size: size),
    );
  }
}
