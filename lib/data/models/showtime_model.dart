
import '../../domain/entities/showtime.dart';

class ShowtimeModel extends Showtime {
  ShowtimeModel({
    required super.id,
    required super.movieId,
    required super.cinemaId,
    required super.screenId,
    required super.date,
    required super.time,
  });

  factory ShowtimeModel.fromJson(Map<String, dynamic> json) {
    return ShowtimeModel(
      id: json['id'] as String,
      movieId: json['movieId'] as String,
      cinemaId: json['cinemaId'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      screenId: json['screenId'] as String,
    );
  }
  Showtime toJson() {
    return Showtime(
      id: id,
      movieId: movieId,
      cinemaId: cinemaId,
      date: date,
      time: time,
      screenId: screenId,
    );
  }
}
