class Video {
  final String key;
  final String type;
  final String site;

  Video({
    required this.key,
    required this.type,
    required this.site,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      key: json['key'] ?? '',
      type: json['type'] ?? '',
      site: json['site'] ?? '',
    );
  }
}
