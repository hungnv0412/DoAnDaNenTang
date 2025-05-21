import 'package:flutter/material.dart';
import '../../domain/entities/cinema.dart';
import '../../domain/entities/user.dart';
import '../../domain/use_cases/get_cinemas.dart';
import '../../domain/use_cases/get_movies.dart';
import '../../domain/entities/movie.dart';

class HomeViewModel extends ChangeNotifier {
  final GetMovies getMovies;
  final GetCinemas getCinemas;

  bool _isLoading = false;
  String? _errorMessage;
  List<Cinema> _cinemas = [];
  List<Movie> _movies = [];
  User? _currentUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Cinema> get cinemas => _cinemas;
  List<Movie> get movies => _movies;
  User? get currentUser => _currentUser;

  HomeViewModel({required this.getMovies, required this.getCinemas});

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchMovies() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _movies = await getMovies();
    } catch (e) {
      _errorMessage = "Đã xảy ra lỗi khi tải phim!";
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchCinemas() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _cinemas = await getCinemas();
    } catch (e) {
      _errorMessage = "Đã xảy ra lỗi khi tải danh sách rạp chiếu phim!";
    } finally {
      _setLoading(false);
    }
  }
}