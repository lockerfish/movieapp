class Movie {
  String title;
  String poster;

  Movie({this.title, this.poster});

  Movie.data([this.title, this.poster]);

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      poster: json['poster_path'],
    );
  }
}
