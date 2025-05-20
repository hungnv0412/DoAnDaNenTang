// data/models/showtime_model.dart
import '../../domain/entities/showtime.dart';

class ShowtimeModel extends Showtime {
  ShowtimeModel({
    required String id,
    required String movieId,
    required String cinemaId,
    required String screenId,
    required String date,
    required String time,
  }) : super(
          id: id,
          movieId: movieId,
          cinemaId: cinemaId,
          date: date,
          time: time,
          screenId: screenId,
        );

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
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movieId': movieId,
      'cinemaId': cinemaId,
      'screenId': screenId,
      'date': date,
      'time': time,
    };
  }
}
