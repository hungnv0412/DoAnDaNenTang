import 'package:my_app/domain/entities/seat.dart';
import 'package:my_app/domain/repositories/seat_repository.dart';

class BookSeatUsecase {
  final SeatRepository _bookSeatRepository;

  BookSeatUsecase(this._bookSeatRepository);

  Future<void> bookSeat(List<Seat> seats,Map<String,dynamic> booking_infor) async {
    try {
      await _bookSeatRepository.bookSeats(seats, booking_infor);
    } catch (e) {
      rethrow;
    }
  }
}