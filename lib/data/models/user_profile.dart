/// A local player profile (memories and stats are scoped per profile).
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.createdAt,
    this.avatarPath,
  });

  final String id;
  final String name;
  final DateTime createdAt;
  final String? avatarPath;

  UserProfile copyWith({
    String? name,
    String? avatarPath,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      createdAt: createdAt,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar_path': avatarPath,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, Object?> map) {
    return UserProfile(
      id: map['id'] as String,
      name: map['name'] as String,
      avatarPath: map['avatar_path'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}

/// Id used when migrating pre-profile installs.
abstract final class ProfileIds {
  static const String legacyDefault = 'profile-default';
}
