import '../entities/cinema.dart';
import '../repositories/cinema_repository.dart';

class GetCinemas {
  final CinemaRepository repository;

  GetCinemas(this.repository);

  Future<List<Cinema>> call() async {
    return await repository.getCinemas();
  }
}
