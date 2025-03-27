import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'services/api_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  MovieDetailScreen({required this.movieId});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? _movieDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMovieDetails();
  }

  void _fetchMovieDetails() async {
    final movieDetails = await apiService.getMovieDetails(widget.movieId);

    setState(() {
      _movieDetails = movieDetails;
      _isLoading = false;
    });
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      final formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Filme'),
      ),
      body: _isLoading
          ? Center(child: SpinKitFadingCircle(color: Colors.blue))
          : _movieDetails == null
              ? Center(child: Text('Falha ao carregar detalhes do filme'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _movieDetails!['poster_path'] != null
                            ? Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/w500${_movieDetails!['poster_path']}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                        SizedBox(height: 16),
                        Text(
                          _movieDetails!['title'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Data de lançamento: ${_formatDate(_movieDetails!['release_date'])}',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Sinopse:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _movieDetails!['overview'],
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        if (_movieDetails!['vote_average'] != null)
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber),
                              SizedBox(width: 4),
                              Text(
                                '${_movieDetails!['vote_average']}/10',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        SizedBox(height: 16),
                        if (_movieDetails!['genres'] != null)
                          Wrap(
                            spacing: 8.0,
                            children: List<Widget>.generate(
                              _movieDetails!['genres'].length,
                              (int index) {
                                return Chip(
                                  label: Text(_movieDetails!['genres'][index]['name']),
                                );
                              },
                            ).toList(),
                          ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
