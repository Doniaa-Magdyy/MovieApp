class Movie {
  final int id;
  final String title;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;
  final String overview;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      overview: json['overview'] ?? '',
    );
  }
}