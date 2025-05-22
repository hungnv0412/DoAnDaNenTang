import 'package:flutter/material.dart';
import 'package:my_app/domain/use_cases/get_booking_by_userId.dart';

import '../../domain/entities/booking.dart';

class TicketViewmodel extends ChangeNotifier {
  final GetBookingByUserid getBookingByUserid;
  TicketViewmodel({
    required this.getBookingByUserid,
  });
  List<Booking> bookings = [];
  bool isLoading = true;

  Future<void> loadTickets(String userId) async {
    try {
      isLoading = true;
      notifyListeners();
      bookings = await getBookingByUserid.call(userId);
    } catch (e) {
      print("Lỗi khi tải vé: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}