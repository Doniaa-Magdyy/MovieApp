import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movieverse/services/api_service.dart';
import 'package:movieverse/models/movie.dart';
import 'package:movieverse/screens/movie_detail_screen.dart';
import 'package:movieverse/widgets/movie_card.dart';
import 'package:movieverse/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text(
          'Movie App',
          style: TextStyle(
            color: Colors.orangeAccent,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.orangeAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            buildSection('Trending Movies', apiService.getTrending()),
            buildSection('Now Playing', apiService.getNowPlaying()),
            buildSection('Top Rated', apiService.getTopRated()),
            buildSection('Upcoming', apiService.getUpcoming()),
          ],
        ),
      ),
    );
  }

  Widget buildSection(String title, Future<List<Movie>> future) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 200,
            child: FutureBuilder<List<Movie>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orangeAccent,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No movies found',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final movie = snapshot.data![index];
                      return MovieCard(
                        movie: movie,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MovieDetailScreen(movieId: movie.id),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
