class User {
  final String login;
  final int id;
  final String? avatarUrl;
  final String? name;
  final String? bio;
  final int? followers;
  final int? following;
  final int? publicRepos;

  User({
    required this.login,
    required this.id,
    this.avatarUrl,
    this.name,
    this.bio,
    this.followers,
    this.following,
    this.publicRepos,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      login: json['login'] as String,
      id: json['id'] as int,
      avatarUrl: json['avatar_url'] as String?,
      name: json['name'] as String?,
      bio: json['bio'] as String?,
      followers: json['followers'] as int?,
      following: json['following'] as int?,
      publicRepos: json['public_repos'] as int?,
    );
  }
}
