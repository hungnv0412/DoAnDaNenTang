import 'package:flutter/material.dart';
import 'package:my_app/domain/use_cases/get_movie_by_id.dart';
import '../../domain/entities/movie.dart';

class DetailFilmViewModel extends ChangeNotifier {
  final GetMovieById getMovieById;
  Movie? movieDetails;
  bool _isLoading = false;
  String? _errorMessage;

  DetailFilmViewModel({
    required this.getMovieById,
  });
  Movie? get movie => movieDetails;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  // Cập nhật trạng thái loading
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  Future<void> fetchMovieDetails(String id) async {
    _setLoading(true);
    _errorMessage = null; // Reset error

    try {
      movieDetails = await getMovieById(id);
    } catch (e) {
      _errorMessage = "Đã xảy ra lỗi khi tải thông tin phim!";
    } finally {
      _setLoading(false);
    }
  }
}

