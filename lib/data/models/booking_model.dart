import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/domain/entities/booking.dart';

class BookingModel extends Booking{
  BookingModel({
    required super.id,
    required super.showtime,
    required super.seats,
    required super.totalPrice,
    required super.userId,
    required super.bookingTime,
    required super.cinemaName,
    required super.screenName,
    required super.movieName,
    required super.paymentStatus,
    required super.showDate,
    
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
  DateTime parseBookingTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    // Firestore Timestamp
    if (value is Timestamp) return value.toDate();
    return DateTime.now();
  }

  return BookingModel(
    id: json['id'] as String? ?? '',
    showtime: json['showtime'] as String? ?? '',
    seats: (json['seats'] as List?)?.map((e) => e.toString()).toList() ?? [],
    totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0,
    userId: json['userId'] as String? ?? '',
    bookingTime: parseBookingTime(json['bookingTime'] ?? json['timestamp']),
    cinemaName: json['cinemaName'] as String? ?? '',
    screenName: json['screenName'] as String? ?? '',
    movieName: json['movieName'] as String? ?? '',
    paymentStatus: json['paymentStatus'] as String? ?? '',
    showDate: json['showDate'] as String? ?? '',
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'showtime': showtime,
      'seats': seats,
      'totalPrice': totalPrice,
      'userId': userId,
      'bookingTime': bookingTime.toIso8601String(),
      'cinemaName': cinemaName,
      'screenName': screenName,
      'movieName': movieName,
      'paymentStatus': paymentStatus,
      'showDate': showDate,
    };
  }
}