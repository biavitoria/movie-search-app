import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'services/api_service.dart';
import 'movie_detail_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filmes APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MovieSearchScreen(),
    );
  }
}

class MovieSearchScreen extends StatefulWidget {
  @override
  _MovieSearchScreenState createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _movies = [];
  bool _isLoading = false;

  void _searchMovies() async {
    setState(() {
      _isLoading = true;
    });

    final movies = await apiService.searchMovies(_controller.text);

    setState(() {
      _movies = movies;
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
        title: Text('Pesquisar Filme'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 159, 248, 241),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(5),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Pesquisar',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchMovies,
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? Center(child: SpinKitFadingCircle(color: Colors.blue))
                  : ListView.builder(
                      itemCount: _movies.length,
                      itemBuilder: (context, index) {
                        final movie = _movies[index];
                        return Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: movie['poster_path'] != null
                                  ? Image.network(
                                      'https://image.tmdb.org/t/p/w92${movie['poster_path']}',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
                            ),
                            title: Text(movie['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                'Data de lançamento: ${_formatDate(movie['release_date'] ?? 'Sem data')}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailScreen(movieId: movie['id']),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
