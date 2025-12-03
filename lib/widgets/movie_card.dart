import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movieverse/models/movie.dart';
import 'package:movieverse/services/api_service.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: '${ApiService.imageBaseUrl}${movie.posterPath}',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                        color: Colors.grey.shade900,
                        child: const Center(
                            child: CircularProgressIndicator(
                                color: Colors.orangeAccent, strokeWidth: 2))),
                    errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade800,
                        child: const Center(
                            child: Icon(Icons.movie_filter,
                                color: Colors.white54, size: 40))),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              movie.title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  movie.voteAverage.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
