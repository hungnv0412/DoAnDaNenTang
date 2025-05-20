import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data/models/showtime_model.dart';
import 'package:my_app/domain/entities/cinema.dart';
import 'package:my_app/domain/entities/showtime.dart';
import 'package:my_app/domain/repositories/showtimes_repository.dart';

class ShowtimesRepositoryImpl implements ShowtimesRepository {
  final FirebaseFirestore firestore;
  ShowtimesRepositoryImpl(this.firestore);
  @override
  Future<List<String>> getAvailableDates(String movieId) async {
    try {
      final snapshot = await firestore
          .collection("showtimes").where("movieId", isEqualTo: movieId).get();
      if (snapshot.docs.isEmpty) {
        throw Exception('No available dates found for this movie.');
      }
      final dates = snapshot.docs.map((doc)=>doc["date"] as String).toSet().toList();
      return dates;
    } catch (e) {
      throw Exception('Failed to fetch available dates: $e');
    }
  }
  @override
  Future<List<Cinema>> getCinemasShowtimes(String movieId,DateTime date) async{
    final fomattedDate = DateFormat('d/M/yyyy').format(date);
    try {
      final snapshot = await firestore
          .collection("showtimes")
          .where("movieId", isEqualTo: movieId)
          .where("date", isEqualTo: fomattedDate)
          .get();
      if (snapshot.docs.isEmpty) {
        throw Exception('No available cinemas found for this movie.');
      }
      final cinemaId = snapshot.docs.map((doc) => doc["cinemaId"] as String).toSet().toList();
      final cinemas = await Future.wait(cinemaId.map((id) async {
      final doc = await firestore.collection("cinemas").doc(id).get();
      final data = doc.data()!;
      return Cinema(
        id: doc.id,
        name: data['name'],
        location: data['location'],
        imageUrl: "",
      );
    }));

    return cinemas;
    } catch (e) {
      throw Exception('Failed to fetch available cinemas: $e');
    }
  }
  @override
  Future<List<Showtime>> getShowtimes(String movieId, String cinemaId,DateTime date) async{
    final formattedDate = DateFormat('d/M/yyyy').format(date);
    final snapshot = await firestore
        .collection("showtimes")
        .where("movieId", isEqualTo: movieId)
        .where("cinemaId", isEqualTo: cinemaId)
        .where("date", isEqualTo: formattedDate)
        .get();
    if (snapshot.docs.isEmpty) {
      throw Exception('No showtimes found for this movie.');
    }
    return snapshot.docs
        .map((doc) => ShowtimeModel.fromJson(doc.data()).toJson())
        .toList();
  }
}