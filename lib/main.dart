import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart';
import 'api/Movie.dart';

// void main() => runApp(MyApp());
void main() async {
  List<Movie> movies = await _fetchMovies();
  runApp(MoviePickerApp(movies: movies));
}

Future<List<Movie>> _fetchMovies() async {
  String rawData = await rootBundle.loadString('data/movies.json');
  var parsedData = json.decode(rawData);
  final List<Movie> movies = (parsedData['movies'] as List)
      .map<Movie>((movie) => Movie.fromJson(movie))
      .toList();
  return movies;
}

class MoviePickerApp extends StatelessWidget {
  final List<Movie> movies;
  MoviePickerApp({this.movies});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MoviePage(
        movies: movies,
      ),
    );
  }
}

enum ViewType { allMovies, favorites }

class MoviePage extends StatefulWidget {
  final List<Movie> movies;
  MoviePage({this.movies});

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  ViewType _viewType = ViewType.allMovies;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              _viewType == ViewType.allMovies ? 'Movie Picker' : 'Favorite'),
        ),
        body: MovieList(
          movies: widget.movies,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _viewType == ViewType.allMovies ? 0 : 1,
          onTap: (int index) {
            setState(() {
              _viewType = index == 0 ? ViewType.allMovies : ViewType.favorites;
            });
          },
          items: [
            BottomNavigationBarItem(
              title: Text('All Movies'),
              icon: Icon(Icons.local_movies),
            ),
            BottomNavigationBarItem(
              title: Text('Favorite Movies'),
              icon: Icon(Icons.favorite),
            ),
          ],
        ));
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList({this.movies});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      padding: const EdgeInsets.all(4.0),
      itemBuilder: (BuildContext context, int index) {
        return Column(children: [
          ListTile(
            contentPadding: EdgeInsets.all(5.0),
            leading: FadeInImage.memoryNetwork(
              width: 100.0,
              height: 100.0,
              placeholder: kTransparentImage,
              image: "https://image.tmdb.org/t/p/w500/" + movies[index].poster,
              fit: BoxFit.scaleDown,
            ),
            title: Text(
              movies[index].title,
              style: TextStyle(color: Colors.black87, fontSize: 16),
            ),
          ),
          Divider(),
        ]);
      },
    );
  }
}
