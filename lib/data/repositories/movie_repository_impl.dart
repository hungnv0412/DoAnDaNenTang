import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final FirebaseFirestore firestore;

  MovieRepositoryImpl(this.firestore);

  @override
  Future<List<Movie>> getMovies() async {
    final snapshot = await firestore.collection('movies').get();
    return snapshot.docs.map((doc) {
      return MovieModel.fromJson({
        ...doc.data(),
        'id': doc.id,
      });
    }).toList();
  }
  @override
  Future<Movie> getMovieById(String id) async {
    final doc = await firestore.collection('movies').doc(id).get();
    print("Movie ID: $id");
    print("Document Data: ${doc.data()}");
    if (doc.exists) {
      return MovieModel.fromJson({
        ...doc.data()!,
        'id': doc.id,
      });
    } else {
      throw Exception('Movie not found');
    }
  }
}
