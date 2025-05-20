import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/domain/repositories/movie_repository.dart';

class GetMovieById {
  final MovieRepository repository;
  GetMovieById(this.repository);
  Future<Movie> call(String id) async {
    return await repository.getMovieById(id);
  }

}