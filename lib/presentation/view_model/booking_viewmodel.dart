import 'package:flutter/material.dart';
import 'package:my_app/domain/use_cases/get_movie_by_id.dart';
import '../../domain/entities/cinema.dart';
import '../../domain/entities/showtime.dart';
import '../../domain/use_cases/get_booking_data.dart';

class BookingViewModel extends ChangeNotifier {
  final GetAvailableDatesUseCase getDatesUseCase;
  final GetCinemasByMovieAndDateUseCase getCinemasUseCase;
  final GetShowtimesUseCase getShowtimesUseCase;
  final GetMovieById getMovieByIdUseCase;

  String _movieName = "";
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _selectedDate;
  Cinema? _selectedCinema;
  List<String> _availableDates = [];
  List<Cinema> _availableCinemas = [];
  List<Showtime> _showtimes = [];

  String get movieName => _movieName;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get selectedDate => _selectedDate;
  Cinema? get selectedCinema => _selectedCinema;
  List<String> get availableDates => _availableDates;
  List<Cinema> get availableCinemas => _availableCinemas;
  List<Showtime> get showtimes => _showtimes;

  BookingViewModel({
    required this.getDatesUseCase,
    required this.getCinemasUseCase,
    required this.getShowtimesUseCase,
    required this.getMovieByIdUseCase,
  });
  Future<void> loadAvailableDates(String movieId) async {
    _isLoading = true;
    _errorMessage = null;
    try {
      _availableDates = await getDatesUseCase(movieId);
    } catch (e) {
      _errorMessage = "Lỗi khi tải ngày chiếu";
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> loadMovieName(String movieId) async {
    _errorMessage = null;
    try {
      final movie = await getMovieByIdUseCase(movieId);
      _movieName = movie.name;
    } catch (e) {
      _errorMessage = "Lỗi khi tải tên phim";
    }
  }
  Future<void> selectDate(String movieId, DateTime date) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedDate = date;
    _errorMessage = null;
    try {
      _availableCinemas = await getCinemasUseCase(movieId, date);
    } catch (e) {
      _errorMessage = "Lỗi khi tải rạp";
    } 
    finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectCinema(String movieId, Cinema cinema) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedCinema = cinema;
    if (_selectedDate != null) {
      _errorMessage = null;
      try {
        _showtimes = await getShowtimesUseCase(movieId, cinema.id, _selectedDate!);
      } catch (e) {
        _errorMessage = "Lỗi khi tải suất chiếu";
      } 
      finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  } 

  void clear() {
    _selectedDate = null;
    _selectedCinema = null;
    _availableDates = [];
    _availableCinemas = [];
    _showtimes = [];
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
  set selectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }
  set showtimes(List<Showtime> showtimes) {
    _showtimes = showtimes;
    notifyListeners();
  }
  
}