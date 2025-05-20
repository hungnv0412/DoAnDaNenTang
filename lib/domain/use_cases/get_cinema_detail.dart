import '../entities/cinema.dart';
import '../repositories/cinema_repository.dart';

class GetCinemaDetail {
  final CinemaRepository repository;

  GetCinemaDetail(this.repository);

  Future<Cinema> execute(String cinemaId) {
    return repository.getCinemaById(cinemaId);
  }
}
