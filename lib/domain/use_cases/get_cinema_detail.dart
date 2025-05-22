import 'package:my_app/domain/repositories/cinema_repository.dart';
import 'package:my_app/domain/repositories/movie_repository.dart';

class CinemaMovieInfo {
  final String showtimeId;
  final String time;
  final String date;
  final String movieId;
  final String movieName;
  final String posterUrl;

  CinemaMovieInfo({
    required this.showtimeId,
    required this.time,
    required this.date,
    required this.movieId,
    required this.movieName,
    required this.posterUrl,
  });
}

class GetCinemaDetailUseCase {
  final CinemaRepository cinemaRepository;
  final MovieRepository movieRepository;

  GetCinemaDetailUseCase(this.cinemaRepository,this.movieRepository);

  Future<(String cinemaName, List<CinemaMovieInfo> movieInfos)> execute(String cinemaId) async {
    final cinemaName = await cinemaRepository.getCinemaName(cinemaId);
    final showtimes = await cinemaRepository.getShowtimesByCinema(cinemaId);

    List<CinemaMovieInfo> movieInfos = [];

    for (var showtime in showtimes) {
      final movie = await movieRepository.getMovieById(showtime.movieId);
      
      if (movie == null) continue;

      movieInfos.add(CinemaMovieInfo(
        showtimeId: showtime.id,
        time: showtime.time,
        date: showtime.date,
        movieId: movie.id,
        movieName: movie.name,
        posterUrl: movie.imageUrl,
      ));
    }

    return (cinemaName, movieInfos);
  }
}
