import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class GetBookingByIdUsecase {
  final BookingRepository bookingRepository;

  GetBookingByIdUsecase(this.bookingRepository);

  Future<Booking?> call(String id) async {
    return await bookingRepository.getBookingById(id);
  }
}