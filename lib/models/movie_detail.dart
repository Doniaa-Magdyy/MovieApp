import 'package:movieverse/models/genre.dart';
import 'package:movieverse/models/cast.dart';
import 'package:movieverse/models/crew.dart';
import 'package:movieverse/models/video.dart';

class MovieDetail {
  final int id;
  final String title;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final String overview;
  final int runtime;
  final List<Genre> genres;
  final List<Cast> cast;
  final List<Crew> crew;
  final List<Video> videos;

  MovieDetail({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.overview,
    required this.runtime,
    required this.genres,
    required this.cast,
    required this.crew,
    required this.videos,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    var castList = <Cast>[];
    if (json['credits'] != null && json['credits']['cast'] != null) {
      castList = (json['credits']['cast'] as List)
          .map((c) => Cast.fromJson(c))
          .toList();
    }

    var crewList = <Crew>[];
    if (json['credits'] != null && json['credits']['crew'] != null) {
      crewList = (json['credits']['crew'] as List)
          .map((c) => Crew.fromJson(c))
          .toList();
    }

    var videoList = <Video>[];
    if (json['videos'] != null && json['videos']['results'] != null) {
      videoList = (json['videos']['results'] as List)
          .map((v) => Video.fromJson(v))
          .toList();
    }

    var genreList = <Genre>[];
    if (json['genres'] != null) {
      genreList = (json['genres'] as List)
          .map((g) => Genre.fromJson(g))
          .toList();
    }

    return MovieDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      overview: json['overview'] ?? '',
      runtime: json['runtime'] ?? 0,
      genres: genreList,
      cast: castList,
      crew: crewList,
      videos: videoList,
    );
  }
}