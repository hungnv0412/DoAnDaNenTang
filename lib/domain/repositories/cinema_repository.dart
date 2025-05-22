
import '../entities/cinema.dart';
import '../entities/showtime.dart';

abstract class CinemaRepository {
  Future<List<Cinema>> getCinemas();
  Future<String> getCinemaName(String cinemaId);
  Future<List<Showtime>> getShowtimesByCinema(String cinemaId);
}
