import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movieverse/services/api_service.dart';
import 'package:movieverse/models/movie.dart';
import 'package:movieverse/screens/movie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<Movie> _searchResults = [];

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isNotEmpty) {
        final results = await Provider.of<ApiService>(context, listen: false)
            .searchMovies(query);
        setState(() {
          _searchResults = results;
        });
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: const TextStyle(color: Colors.orange),
          decoration: const InputDecoration(
            hintText: 'Search by movie title',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
          onChanged: _onSearchChanged,
        ),
      ),
      body: _searchResults.isEmpty
          ? const Center(
              child: Text('Search for movies',
                  style: TextStyle(color: Colors.orange)))
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final movie = _searchResults[index];
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: '${ApiService.imageBaseUrl}${movie.posterPath}',
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(movie.title,
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text(movie.releaseDate,
                      style: const TextStyle(color: Colors.grey)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MovieDetailScreen(movieId: movie.id),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
