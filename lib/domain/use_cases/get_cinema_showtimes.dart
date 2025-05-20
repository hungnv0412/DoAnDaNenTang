import '../entities/showtime.dart';
import '../repositories/cinema_repository.dart';

class GetCinemaShowtimes {
  final CinemaRepository repository;

  GetCinemaShowtimes(this.repository);

  Future<List<Showtime>> execute(String cinemaId) {
    return repository.getCinemaShowtimes(cinemaId);
  }
}
