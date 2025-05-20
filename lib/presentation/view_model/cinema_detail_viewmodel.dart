import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CinemaDetailViewModel extends ChangeNotifier {
  bool isLoading = true;
  List<String> availableDates = [];
  String selectedDate = "";
  List<String> showtimeHours = [];
  String selectedHour = "";
  List<Map<String, dynamic>> moviesList = [];
  String cinemaName = "đang tải...";

  final String cinemaId;
  final _firestore = FirebaseFirestore.instance;

  CinemaDetailViewModel(this.cinemaId) {
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading = true;
      notifyListeners();

      final cinemaFuture = _firestore.collection('cinemas').doc(cinemaId).get();
      final showtimesFuture = _firestore
          .collection('showtimes')
          .where('cinemaId', isEqualTo: cinemaId)
          .get();

      final results = await Future.wait([cinemaFuture, showtimesFuture]);

      final cinemaDoc = results[0] as DocumentSnapshot;
      if (cinemaDoc.exists) {
        cinemaName = cinemaDoc["name"];
      }

      final showtimesSnapshot = results[1] as QuerySnapshot;
      Set<String> dates = {};
      List<Map<String, dynamic>> tempMovies = [];

      for (var showtime in showtimesSnapshot.docs) {
        var data = showtime.data() as Map<String, dynamic>;
        var date = data['date'] ?? '';
        var hour = data['time'] ?? '';
        var movieId = data['movieId'] ?? '';

        if (date.isEmpty || hour.isEmpty || movieId.isEmpty|| date.isBefore(DateTime.now())) continue;

        dates.add(date);

        var movieDoc = await _firestore.collection('movies').doc(movieId).get();

        if (movieDoc.exists) {
          var movieData = movieDoc.data() ?? {};
          tempMovies.add({
            'showtimeId': showtime.id,
            'time': hour,
            'date': date,
            'movieId': movieId,
            'movieName': movieData['name'] ?? 'Không rõ',
            'posterUrl': movieData['imageUrl'] ?? '',
          });
        }
      }

      availableDates = dates.toList()..sort();
      selectedDate = availableDates.isNotEmpty ? availableDates.first : "";
      moviesList = tempMovies;
      isLoading = false;
      
      updateShowtimes();
      notifyListeners();
    } catch (e) {
      print("Lỗi khi tải dữ liệu: $e");
      isLoading = false;
      notifyListeners();
    }
  }

  void updateShowtimes() {
    showtimeHours = moviesList
        .where((movie) => movie['date'] == selectedDate)
        .map((movie) => movie['time'] as String)
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
