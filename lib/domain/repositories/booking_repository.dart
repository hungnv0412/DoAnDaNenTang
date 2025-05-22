import 'package:my_app/domain/entities/booking.dart';

abstract class BookingRepository {
  Future<List<Booking>> getBookingsByUserId(String userId);
  Future<Booking> getBookingById(String bookingId);
}