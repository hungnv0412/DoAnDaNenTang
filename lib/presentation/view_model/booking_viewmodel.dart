import 'package:flutter/material.dart';
import 'package:my_app/domain/entities/cinema.dart';
import 'package:my_app/domain/entities/showtime.dart';
import 'package:my_app/domain/use_cases/get_booking_data.dart';

class BookingViewModel extends ChangeNotifier {
  final GetAvailableDatesUseCase getDatesUseCase;
  final GetCinemasByMovieAndDateUseCase getCinemasUseCase;
  final GetShowtimesUseCase getShowtimesUseCase;
  

  DateTime? selectedDate;
  Cinema? selectedCinema;
  List<String> availableDates = [];
  List<Cinema> availableCinemas = [];
  List<Showtime> showtimes = [];

  BookingViewModel(this.getDatesUseCase, this.getCinemasUseCase, this.getShowtimesUseCase);
  bool isLoading = false;

  Future<void> loadAvailableDates(String movieId) async {
    isLoading = true;
    notifyListeners();
    try {
      availableDates = await getDatesUseCase(movieId);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectDate(String movieId, DateTime date) async {
    selectedDate = date;
    isLoading = true;
    notifyListeners();
    try {
      availableCinemas = await getCinemasUseCase(movieId, date);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectCinema(String movieId, Cinema cinema) async {
    selectedCinema = cinema;
    if (selectedDate != null) {
      isLoading = true;
      notifyListeners();
      try {
        showtimes = await getShowtimesUseCase(movieId, cinema.id, selectedDate!);
        print(showtimes.map((showtimes) => showtimes.screenId));
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }
  void clear() {
    selectedDate = null;
    selectedCinema = null;
    availableDates = [];
    availableCinemas = [];
    showtimes = [];
    isLoading = false;
    notifyListeners();
  }
}