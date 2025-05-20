import '../entities/movie.dart';
import '../repositories/booking_repository.dart';

class ShowtimeResult {
  final Movie movie;
  final List<Map<String, dynamic>> showtimes;

  ShowtimeResult({required this.movie, required this.showtimes});
}

class GetMovieShowtimes {
  final BookingRepository repository;

  GetMovieShowtimes(this.repository);

  Future<ShowtimeResult> execute(String movieId) async {
    final movie = await repository.getMovie(movieId);
    final showtimes = await repository.getMovieShowtimes(movieId);
    return ShowtimeResult(movie: movie, showtimes: showtimes);
  }
}