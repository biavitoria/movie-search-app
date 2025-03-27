import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey = '3cad1c9824fc5b69bfa1108823e4e649';
  static const String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<dynamic>> searchMovies(String query) async {
    final url = '$baseUrl/search/movie?api_key=$apiKey&query=$query&language=pt-BR';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Map<String, dynamic>> getMovieDetails(int id) async {
    final url = '$baseUrl/movie/$id?api_key=$apiKey&language=pt-BR';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}
