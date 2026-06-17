import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/profile_avatar_button.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/profile_providers.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../l10n/app_localizations.dart';

Future<void> showProfileSwitcherSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    builder: (context) => const _ProfileSwitcherSheet(),
  );
}

Future<void> showCreateProfileDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => const _ProfileEditorDialog(),
  );
}

Future<void> showEditProfileDialog(
  BuildContext context,
  UserProfile profile,
) {
  return showDialog<void>(
    context: context,
    builder: (context) => _ProfileEditorDialog(profile: profile),
  );
}

class _ProfileSwitcherSheet extends ConsumerWidget {
  const _ProfileSwitcherSheet();

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
    bool isLastProfile,
  ) async {
    final l = AppLocalizations.of(context);
    if (isLastProfile) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.profilesDeleteLast)),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.profilesDeleteTitle),
        content: Text(l.profilesDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
            ),
            child: Text(l.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(profileControllerProvider.notifier).deleteProfile(profile.id);
      if (context.mounted) Navigator.of(context).pop();
    } on ProfileDeleteException {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.profilesDeleteLast)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final state = ref.watch(profileControllerProvider).value;
    if (state == null) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator(color: AppColors.or)),
      );
    }

    final isLastProfile = state.profiles.length <= 1;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l.profilesTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            for (final profile in state.profiles)
              _ProfileTile(
                profile: profile,
                selected: profile.id == state.activeProfileId,
                onTap: () async {
                  await ref
                      .read(profileControllerProvider.notifier)
                      .switchProfile(profile.id);
                  if (context.mounted) Navigator.of(context).pop();
                },
                onEdit: () => showEditProfileDialog(context, profile),
                onDelete: () => _confirmDelete(
                  context,
                  ref,
                  profile,
                  isLastProfile,
                ),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                showCreateProfileDialog(context);
              },
              icon: const Icon(Icons.person_add_alt_1_outlined),
              label: Text(l.profilesAdd),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.profile,
    required this.selected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final UserProfile profile;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ProfileAvatarChip(profile: profile, selected: selected),
      title: Text(
        profile.name,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      subtitle: selected ? Text(l.profilesActive) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selected)
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.check_circle, color: AppColors.or, size: 22),
            ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            tooltip: l.profilesEdit,
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            tooltip: l.profilesDelete,
            onPressed: onDelete,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

class _ProfileEditorDialog extends ConsumerStatefulWidget {
  const _ProfileEditorDialog({this.profile});

  final UserProfile? profile;

  bool get isEditing => profile != null;

  @override
  ConsumerState<_ProfileEditorDialog> createState() =>
      _ProfileEditorDialogState();
}

class _ProfileEditorDialogState extends ConsumerState<_ProfileEditorDialog> {
  late final TextEditingController _nameController =
      TextEditingController(text: widget.profile?.name ?? '');
  final _picker = ImagePicker();
  File? _avatar;
  bool _busy = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String? get _existingAvatarPath => widget.profile?.avatarPath;

  Future<void> _pickAvatar() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (image == null) return;
    setState(() => _avatar = File(image.path));
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || _busy) return;
    setState(() => _busy = true);
    try {
      final controller = ref.read(profileControllerProvider.notifier);
      if (widget.isEditing) {
        await controller.updateProfile(
          profileId: widget.profile!.id,
          name: name,
          avatarSource: _avatar,
        );
      } else {
        await controller.createProfile(name: name, avatarSource: _avatar);
      }
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final displayName = _nameController.text.isEmpty
        ? '?'
        : _nameController.text;

    return AlertDialog(
      title: Text(
        widget.isEditing ? l.profilesEditTitle : l.profilesCreate,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _busy ? null : _pickAvatar,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ProfileAvatarChip(
                  profile: UserProfile(
                    id: widget.profile?.id ?? 'temp',
                    name: displayName,
                    createdAt: widget.profile?.createdAt ?? DateTime.now(),
                    avatarPath: _avatar?.path ?? _existingAvatarPath,
                  ),
                  size: 72,
                ),
                const Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.or,
                    child: Icon(
                      Icons.camera_alt,
                      size: 14,
                      color: AppColors.encre,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.profilesChooseAvatar,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l.profilesNameHint,
              border: const OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
            enabled: !_busy,
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: Text(l.commonCancel),
        ),
        FilledButton(
          onPressed: _busy || _nameController.text.trim().isEmpty
              ? null
              : _submit,
          child: _busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  widget.isEditing ? l.profilesSave : l.profilesCreate,
                ),
        ),
      ],
    );
  }
}
