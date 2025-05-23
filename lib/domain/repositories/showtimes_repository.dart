
import '../entities/cinema.dart';
import '../entities/showtime.dart';


abstract class ShowtimesRepository {
  Future<List<String>> getAvailableDates(String movieId);
  Future<List<Cinema>> getCinemasShowtimes(String movieId, DateTime date);
  Future<List<Showtime>> getShowtimes(String movieId,String cinemaId ,DateTime date);
}