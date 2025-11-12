class User {
  final String login;
  final int id;
  final String? avatarUrl;
  final String? name;
  final String? bio;

  User({
    required this.login,
    required this.id,
    this.avatarUrl,
    this.name,
    this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      login: json['login'] as String,
      id: json['id'] as int,
      avatarUrl: json['avatar_url'] as String?,
      name: json['name'] as String?,
      bio: json['bio'] as String?,
    );
  }
}
