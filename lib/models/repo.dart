class Repo {
  final int id;
  final String name;
  final String? description;
  final String? language;
  final int stars;
  final int forks;

  Repo({
    required this.id,
    required this.name,
    this.description,
    this.language,
    required this.stars,
    required this.forks,
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      language: json['language'] as String?,
      stars: json['stargazers_count'] as int? ?? 0,
      forks: json['forks_count'] as int? ?? 0,
    );
  }
}
