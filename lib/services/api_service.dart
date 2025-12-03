import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movieverse/models/movie.dart';
import 'package:movieverse/models/movie_detail.dart';

class ApiService extends ChangeNotifier {
static const String apiKey = '74a0275b65e044200d9d22cef1b6eb89'; 
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String imageBaseUrlBackdrop = 'https://image.tmdb.org/t/p/w1280';
  static const String language = 'en-US'; // Optional: Set language to English

  Map<int, String> _genres = {};

  Future<void> fetchGenres() async {
    if (_genres.isNotEmpty) return;
    final response = await http.get(Uri.parse('$baseUrl/genre/movie/list?api_key=$apiKey&language=$language'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> genreList = data['genres'];
      _genres = {for (var g in genreList) g['id']: g['name']};
      notifyListeners();
    } else {
      throw Exception('Failed to load genres: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<Movie>> getTrending() async {
    final response = await http.get(Uri.parse('$baseUrl/trending/movie/day?api_key=$apiKey&language=$language'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((m) => Movie.fromJson(m)).toList();
    } else {
      throw Exception('Failed to load trending movies: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<Movie>> getNowPlaying() async {
    final response = await http.get(Uri.parse('$baseUrl/movie/now_playing?api_key=$apiKey&language=$language'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((m) => Movie.fromJson(m)).toList();
    } else {
      throw Exception('Failed to load now playing movies: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<Movie>> getTopRated() async {
    final response = await http.get(Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey&language=$language'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((m) => Movie.fromJson(m)).toList();
    } else {
      throw Exception('Failed to load top rated movies: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<Movie>> getUpcoming() async {
    final response = await http.get(Uri.parse('$baseUrl/movie/upcoming?api_key=$apiKey&language=$language'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((m) => Movie.fromJson(m)).toList();
    } else {
      throw Exception('Failed to load upcoming movies: ${response.statusCode} - ${response.body}');
    }
  }

  Future<MovieDetail> getMovieDetails(int movieId) async {
    final response = await http.get(Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey&language=$language&append_to_response=credits,videos'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MovieDetail.fromJson(data);
    } else {
      throw Exception('Failed to load movie details: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search/movie?api_key=$apiKey&language=$language&query=${Uri.encodeQueryComponent(query)}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((m) => Movie.fromJson(m)).toList();
    } else {
      throw Exception('Failed to search movies: ${response.statusCode} - ${response.body}');
    }
  }
}