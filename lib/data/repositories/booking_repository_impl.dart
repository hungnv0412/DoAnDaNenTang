import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/entities/movie.dart';
import '../models/movie_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final FirebaseFirestore _firestore;

  BookingRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Movie> getMovie(String movieId) async {
    final doc = await _firestore.collection('movies').doc(movieId).get();
    return MovieModel.fromJson({'id': doc.id, ...doc.data()!});
  }

  @override
  Future<List<Map<String, dynamic>>> getMovieShowtimes(String movieId) async {
    // Get showtimes
    final showtimeSnapshot = await _firestore
        .collection("showtimes")
        .where("movieId", isEqualTo: movieId)
        .get();

    final showtimeDocs = showtimeSnapshot.docs;
    if (showtimeDocs.isEmpty) return [];

    // Get screens
    final screenIds = showtimeDocs.map((doc) => doc["screenId"] as String).toSet();
    final screenSnapshot = await _firestore
        .collection("screens")
        .where(FieldPath.documentId, whereIn: screenIds.toList())
        .get();
    final screenDataMap = {
      for (var doc in screenSnapshot.docs) doc.id: doc.data()
    };

    // Get cinemas
    final cinemaIds = screenDataMap.values.map((e) => e["cinemaId"] as String).toSet();
    final cinemaSnapshot = await _firestore
        .collection("cinemas")
        .where(FieldPath.documentId, whereIn: cinemaIds.toList())
        .get();
    final cinemaDataMap = {
      for (var doc in cinemaSnapshot.docs) doc.id: doc.data()
    };

    // Process data
    List<Map<String, dynamic>> result = [];
    for (var showtime in showtimeDocs) {
      final data = showtime.data();
      final screenId = data["screenId"];
      final cinemaId = screenDataMap[screenId]?["cinemaId"];
      final cinemaData = cinemaDataMap[cinemaId];
      
      if (cinemaData == null) continue;

      result.add({
        "date": data["date"],
        "time": data["time"],
        "screenId": screenId,
        "cinemaId": cinemaId,
        "cinemaName": cinemaData["name"],
        "location": cinemaData["location"],
        "showtimeId": showtime.id,
      });
    }

    return result;
  }
}