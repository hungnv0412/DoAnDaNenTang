import 'package:flutter/material.dart';
import 'package:my_app/domain/use_cases/get_booking_data.dart';
import '../../domain/entities/movie.dart';
import 'package:intl/intl.dart';

class BookingViewModel extends ChangeNotifier {
  final GetMovieShowtimes getMovieShowtimes;
  final String movieId;

  Movie? _movie;
  bool _isLoading = true;
  String? _selectedDate;
  List<String> _availableDates = [];
  Map<String, List<Map<String, dynamic>>> _cinemaShowtimes = {};
  String? _errorMessage;

  BookingViewModel({
    required this.getMovieShowtimes,
    required this.movieId,
  }) {
    _loadData();
  }

  // Getters
  Movie? get movie => _movie;
  bool get isLoading => _isLoading;
  String? get selectedDate => _selectedDate;
  List<String> get availableDates => _availableDates;
  Map<String, List<Map<String, dynamic>>> get cinemaShowtimes => _cinemaShowtimes;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> _loadData() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final result = await getMovieShowtimes.execute(movieId);
      _movie = result.movie;
      _processShowtimes(result.showtimes);
    } catch (e) {
      _errorMessage = "Đã xảy ra lỗi khi tải dữ liệu!";
    } finally {
      _setLoading(false);
    }
  }

  void _processShowtimes(List<Map<String, dynamic>> showtimes) {
    Set<String> dates = {};
    Map<String, List<Map<String, dynamic>>> showtimeMap = {};

    for (var showtime in showtimes) {
      final dateStr = showtime["date"];
      try {
        final parsedDate = DateFormat("d/M/yyyy").parse(dateStr);
        final today = DateTime.now();
        final todayDateOnly = DateTime(today.year, today.month, today.day);

        // if (parsedDate.isBefore(todayDateOnly)) continue;

        dates.add(dateStr);
        showtimeMap.putIfAbsent(dateStr, () => []);
        showtimeMap[dateStr]!.add(showtime);
      } catch (e) {
        print("Error parsing date: $e");
      }
    }

    _availableDates = dates.toList()..sort();
    _cinemaShowtimes = showtimeMap;
    if (_availableDates.isNotEmpty) {
      _selectedDate = _availableDates.first;
    }
    notifyListeners();
  }

  void selectDate(String date) {
    _selectedDate = date;
    notifyListeners();
  }
}