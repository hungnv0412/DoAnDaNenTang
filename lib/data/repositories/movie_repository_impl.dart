import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final FirebaseFirestore firestore;

  MovieRepositoryImpl(this.firestore);

  @override
  Future<List<Movie>> getMovies() async {
    final snapshot = await firestore.collection('movies').get();
    return snapshot.docs.map((doc) {
      return Movie(
        id: doc.id,
        name: doc['name'],
        releaseDate: doc['releaseDate'],
        genre: doc['genre'],
        imageUrl: doc['imageUrl'],
        fullDescription: doc['fullDescription'],
        duration: doc['duration'],
      );
    }).toList();
  }
  @override
  Future<Movie> getMovieById(String id) async {
    final doc = await firestore.collection('movies').doc(id).get();
    if (doc.exists) {
      return Movie(
        id: doc.id,
        name: doc['name'],
        releaseDate: doc['releaseDate'],
        genre: doc['genre'],
        imageUrl: doc['imageUrl'],
        fullDescription: doc['fullDescription'],
        duration: doc['duration'],
      );
    } else {
      throw Exception('Movie not found');
    }
  }
}
