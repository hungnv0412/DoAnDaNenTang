import '../../domain/entities/movie.dart';

class MovieModel extends Movie {

  MovieModel({
    required String id,
    required String releaseDate,
    required String name,
    required String genre,
    required int duration,
    required String imageUrl,
    required String fullDescription,
  }) : super(
          id: id,
          releaseDate: releaseDate,
          name: name,
          genre: genre,
          duration: duration.toString(),
          imageUrl: imageUrl,
          fullDescription: fullDescription,
        );

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as String,
      releaseDate: json['releaseDate'] as String,
      name: json['name'] as String,
      genre: json['genre'] as String,
      duration: json['duration'] as int,
      imageUrl: json['imageUrl'] as String,
      fullDescription: json['fullDescription'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fullDescription': fullDescription,
      'releaseDate': releaseDate,
      'genre': genre,
      'duration': duration,
      'imageUrl': imageUrl,
    };
  }
}
