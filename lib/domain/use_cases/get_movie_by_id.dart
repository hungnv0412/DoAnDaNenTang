
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovieById {
  final MovieRepository repository;
  GetMovieById(this.repository);
  Future<Movie> call(String id) async {
    return await repository.getMovieById(id);
  }

}