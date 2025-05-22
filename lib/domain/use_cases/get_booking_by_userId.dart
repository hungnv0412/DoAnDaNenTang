import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class GetBookingByUserid {
  final BookingRepository bookingRepository;

  GetBookingByUserid(this.bookingRepository);

  Future<List<Booking>> call(String userId) async {
    return await bookingRepository.getBookingsByUserId(userId);
  }
}