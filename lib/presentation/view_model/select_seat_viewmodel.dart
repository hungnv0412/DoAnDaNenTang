
import 'package:flutter/material.dart';
import 'package:my_app/domain/use_cases/book_seat_usecase.dart';
import 'package:my_app/domain/use_cases/get_seat_usecase.dart';

import '../../domain/entities/seat.dart';

class SelectSeatViewmodel extends ChangeNotifier {
  final GetSeatUsecase getSeatUsecase;
  final BookSeatUsecase bookSeatUsecase;

  SelectSeatViewmodel({
    required this.getSeatUsecase,
    required this.bookSeatUsecase,
  });
  bool isLoading = true;
  List<Seat> seats = [];
  Set<Seat> selectedSeats = {};
  double totalPrice = 0.0;

  Future<void> loadSeats(String showtimeId) async {
    try {
      isLoading = true;
      notifyListeners();
      seats = await getSeatUsecase.call(showtimeId);
      seats.sort((a, b) {
      var rowA = a.seatNumber[0];
      var rowB = b.seatNumber[0];
      var numA = int.parse(a.seatNumber.substring(1));
      var numB = int.parse(b.seatNumber.substring(1));
      return rowA == rowB ? numA.compareTo(numB) : rowA.compareTo(rowB);
    });

    isLoading = false;
    notifyListeners();
    } catch (e) {
      print("Error loading seats: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  void toggleSeatSelection(Seat seat) {
    if (selectedSeats.contains(seat)) {
      selectedSeats.remove(seat.id);
      totalPrice -= seat.price;
    } else {
      selectedSeats.add(seat);
      totalPrice += seat.price;
    }
    notifyListeners();
  }
  Future<void> confirmBooking({
    required Map<String, dynamic> bookingInfo,
  }) async {
    if (selectedSeats.isEmpty) return;
    isLoading = true;
    notifyListeners();

    try {
      final selectedSeatsList =
          seats.where((seat) => selectedSeats.contains(seat)).toList();
      await bookSeatUsecase.bookSeat(selectedSeatsList, bookingInfo);
      selectedSeats.clear();
      totalPrice = 0;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}