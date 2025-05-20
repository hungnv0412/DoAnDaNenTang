import 'package:flutter/material.dart';
import 'package:my_app/domain/entities/cinema.dart';
import 'package:my_app/domain/entities/user.dart';
import 'package:my_app/domain/use_cases/get_cinemas.dart';
import '../../domain/use_cases/get_movies.dart';
import '../../domain/entities/movie.dart';

class HomeViewModel extends ChangeNotifier {
  final GetMovies getMovies;
  final GetCinemas getCinemas;

  List<Cinema> _cinemas = [];
  List<Movie> _movies = [];
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;

  HomeViewModel({required this.getMovies, required this.getCinemas}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setCurrentUser(_currentUser!); // Replace with actual User object
      fetchMovies();
      fetchCinemas();
    });
  }

  // Getters
  List<Cinema> get cinemas => _cinemas;
  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  // Cập nhật người dùng hiện tại
  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  // Cập nhật trạng thái loading
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Fetch danh sách phim từ Use Case
  Future<void> fetchMovies() async {
    _setLoading(true);
    _errorMessage = null; // Reset error

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
    _errorMessage = null; // Reset error

    try {
      _cinemas= await getCinemas();
    } catch (e) {
      _errorMessage = "Đã xảy ra lỗi khi tải danh sách rạp chiếu phim!";
    } finally {
      _setLoading(false);
    }
  }
}
