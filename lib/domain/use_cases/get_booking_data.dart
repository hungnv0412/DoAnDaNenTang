import 'package:my_app/domain/entities/cinema.dart';
import 'package:my_app/domain/entities/showtime.dart';
import 'package:my_app/domain/repositories/showtimes_repository.dart';

class GetAvailableDatesUseCase {
  final ShowtimesRepository repository;

  GetAvailableDatesUseCase(this.repository);

  Future<List<String>> call(String movieId) => repository.getAvailableDates(movieId);
}

class GetCinemasByMovieAndDateUseCase {
  final ShowtimesRepository repository;

  GetCinemasByMovieAndDateUseCase(this.repository);

  Future<List<Cinema>> call(String movieId, DateTime date) =>
      repository.getCinemasShowtimes(movieId, date);
}

class GetShowtimesUseCase {
  final ShowtimesRepository repository;

  GetShowtimesUseCase(this.repository);

  Future<List<Showtime>> call(String movieId, String cinemaId, DateTime date) =>
      repository.getShowtimes(movieId, cinemaId, date);
}
