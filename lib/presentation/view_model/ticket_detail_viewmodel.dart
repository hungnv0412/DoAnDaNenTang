
import 'package:flutter/material.dart';
import 'package:my_app/domain/entities/booking.dart';
import 'package:my_app/domain/use_cases/get_booking_by_id_usecase.dart';

class TicketDetailViewmodel extends ChangeNotifier {
  final GetBookingByIdUsecase getBookingByIdUsecase;
  TicketDetailViewmodel({required this.getBookingByIdUsecase});
  
  Booking? _booking;
  String? _errorMessage;
  String _isLoading = "false";

  Booking? get booking => _booking;
  String? get errorMessage => _errorMessage;
  String get isLoading => _isLoading;

  Future<void> getBookingById(String bookingId) async {
    _isLoading = "true";
    notifyListeners();
    _errorMessage = null;
    try {
      _booking = await getBookingByIdUsecase(bookingId);
      if (_booking == null) {
        _errorMessage = "Không tìm thấy thông tin đặt vé";
      }
    } catch (e) {
      _errorMessage = "Lỗi khi lấy thông tin đặt vé";
    } finally {
      _isLoading = "false";
      notifyListeners();
    }
  }
}