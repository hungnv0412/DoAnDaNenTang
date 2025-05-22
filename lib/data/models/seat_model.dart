import 'package:my_app/domain/entities/seat.dart';

class SeatModel extends Seat{
  SeatModel({
    required super.id,
    required super.showtimeId,
    required super.screenId,
    required super.cinemaId,
    required super.seatNumber,
    required super.isBooked,
    required super.price,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      id: json['id'] as String,
      showtimeId: json['showtimeId'] as String,
      screenId: json['screenId'] as String,
      cinemaId: json['cinemaId'] as String,
      seatNumber: json['seatNumber'] as String,
      isBooked: json['isBooked'] as bool,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'showtimeId': showtimeId,
      'screenId': screenId,
      'cinemaId': cinemaId,
      'seatNumber': seatNumber,
      'isBooked': isBooked,
      'price': price,
    };
  }
}