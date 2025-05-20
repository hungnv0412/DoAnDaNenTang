import '../entities/cinema.dart';
import '../entities/showtime.dart';

abstract class CinemaRepository {
  Future<List<Cinema>> getCinemas();
  Future<Cinema> getCinemaById(String id);
  Future<List<Showtime>> getCinemaShowtimes(String cinemaId);
}
