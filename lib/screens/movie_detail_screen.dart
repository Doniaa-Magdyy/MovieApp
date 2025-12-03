import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movieverse/services/api_service.dart';
import 'package:movieverse/models/movie_detail.dart';
import 'package:movieverse/models/video.dart';


class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<MovieDetail> _movieFuture;
  YoutubePlayerController? _youtubeController;
  String? _trailerKey;

  @override
  void initState() {
    super.initState();
    _movieFuture = Provider.of<ApiService>(context, listen: false)
        .getMovieDetails(widget.movieId)
        .then((movie) {
      final trailer = movie.videos.firstWhere(
        (v) => v.type == 'Trailer' && v.site == 'YouTube',
        orElse: () => Video(key: '', type: '', site: ''),
      );
      if (trailer.key.isNotEmpty) {
        _trailerKey = trailer.key;
        _youtubeController = YoutubePlayerController(
          initialVideoId: _trailerKey!,
          flags: const YoutubePlayerFlags(autoPlay: false),
        );
      }
      return movie;
    });
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<MovieDetail>(
        future: _movieFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.red));
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData) {
            return const Center(
                child: Text('No movie details found',
                    style: TextStyle(color: Colors.white)));
          } else {
            final movie = snapshot.data!;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  backgroundColor: Colors.black,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      movie.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    centerTitle: true,
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              '${ApiService.imageBaseUrlBackdrop}${movie.backdropPath}',
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              Container(color: Colors.grey.shade900),
                        ),
                        
                        // Enhanced Gradient Overlay
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Colors.black54,
                                Colors.black,
                                Colors.black,
                              ], 
                              stops: [0.0, 0.7, 1.0], // Darker transition at the bottom
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        // Movie Poster and Primary Info
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${ApiService.imageBaseUrl}${movie.posterPath}',
                                width: 120,
                                height: 180,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Container(color: Colors.grey),
                                errorWidget: (context, url, error) =>
                                    Container(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
                                  // Rating and Runtime
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.amber, size: 20),
                                      const SizedBox(width: 6),
                                      Text(
                                        movie.voteAverage.toStringAsFixed(1),
                                        style: const TextStyle(
                                            color: Colors.white, 
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 16),
                                      const Icon(Icons.access_time,
                                          color: Colors.grey, size: 20),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${movie.runtime} min',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Release Date
                                  Text(
                                    'Release: ${movie.releaseDate}',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),

                                  // Genres
                                  Text(
                                    'Genres: ${movie.genres.map((g) => g.name).join(', ')}',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const Divider(color: Colors.grey, height: 32),

                        // Overview
                        _buildSectionHeader('Overview'),
                        Text(
                          movie.overview,
                          style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
                        ),

                        const Divider(color: Colors.grey, height: 32),

                        // Trailer
                        if (_youtubeController != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader('Trailer'),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: YoutubePlayer(
                                  controller: _youtubeController!,
                                  showVideoProgressIndicator: true,
                                  progressIndicatorColor: Colors.red,
                                ),
                              ),
                              const Divider(color: Colors.grey, height: 32),
                            ],
                          ),

                        // Cast
                        _buildSectionHeader('Cast'),
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: movie.cast.length,
                            itemBuilder: (context, index) {
                              final actor = movie.cast[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: SizedBox(
                                  width: 70,
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(35.0),
                                        child: CachedNetworkImage(
                                          imageUrl: actor.profilePath != null &&
                                                  actor.profilePath!.isNotEmpty
                                              ? '${ApiService.imageBaseUrl}${actor.profilePath}'
                                              : 'https://via.placeholder.com/70',
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(color: Colors.grey, width: 70, height: 70),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        actor.name,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        actor.character,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const Divider(color: Colors.grey, height: 32),

                        // Crew
                        _buildSectionHeader('Crew'),
                        ...movie.crew.take(5).map((c) => Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text('${c.job}: ${c.name}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.white70)),
                            )),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}