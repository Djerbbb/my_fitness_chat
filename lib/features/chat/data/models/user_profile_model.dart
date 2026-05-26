class UserProfileModel {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isTrainer;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.isTrainer = false,
  });

  UserProfileModel copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    bool? isTrainer,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isTrainer: isTrainer ?? this.isTrainer,
    );
  }
}