import '../entities/seat.dart';
import '../repositories/seat_repository.dart';

class GetSeatUsecase {
  final SeatRepository _seatRepository;

  GetSeatUsecase(this._seatRepository);

  Future<List<Seat>> call(String id) async {
    return await _seatRepository.getSeatsByShowtime(id);
  }
}