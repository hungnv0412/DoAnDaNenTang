import 'package:my_app/domain/entities/seat.dart';

abstract class SeatRepository {
  Future<List<Seat>> getSeatsByShowtime(String showtimeId);
  Future<void> bookSeats(List<Seat> seats,Map<String, dynamic> paymentInfo);
}