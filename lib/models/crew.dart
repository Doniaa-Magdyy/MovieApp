class Crew {
  final String name;
  final String job;

  Crew({
    required this.name,
    required this.job,
  });

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      name: json['name'] ?? '',
      job: json['job'] ?? '',
    );
  }
}