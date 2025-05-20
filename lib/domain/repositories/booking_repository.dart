import '../entities/movie.dart';

abstract class BookingRepository {
  Future<Movie> getMovie(String movieId);
  Future<List<Map<String, dynamic>>> getMovieShowtimes(String movieId);
}