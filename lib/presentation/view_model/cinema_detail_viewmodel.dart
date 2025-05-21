import 'package:flutter/material.dart';
import 'package:my_app/domain/use_cases/get_cinema_detail.dart';

class CinemaDetailViewModel extends ChangeNotifier {
  final String cinemaId;
  final GetCinemaDetailUseCase useCase;

  bool isLoading = true;
  List<String> availableDates = [];
  String selectedDate = "";
  List<String> showtimeHours = [];
  String selectedHour = "";
  List<CinemaMovieInfo> moviesList = [];
  String cinemaName = "đang tải...";

  CinemaDetailViewModel(this.cinemaId, this.useCase) {
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading = true;
      notifyListeners();

      final (name, movieInfos) = await useCase.execute(cinemaId);
      cinemaName = name;
      moviesList = movieInfos;

      availableDates = movieInfos.map((e) => e.date).toSet().toList()..sort();
      selectedDate = availableDates.isNotEmpty ? availableDates.first : "";

      updateShowtimes();
    } catch (e) {
      print("Lỗi: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateShowtimes() {
    showtimeHours = moviesList
        .where((e) => e.date == selectedDate)
        .map((e) => e.time)
        .toSet()
        .toList()
      ..sort();

    selectedHour = showtimeHours.isNotEmpty ? showtimeHours.first : "";
    notifyListeners();
  }

  void selectDate(String date) {
    selectedDate = date;
    updateShowtimes();
  }

  void selectHour(String hour) {
    selectedHour = hour;
    notifyListeners();
  }
}
