import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/cinema.dart';
import '../../domain/entities/showtime.dart';
import '../../domain/repositories/cinema_repository.dart';
import '../models/cinema_model.dart';
import '../models/showtime_model.dart';

class CinemaRepositoryImpl implements CinemaRepository {
  final FirebaseFirestore firestore;

  CinemaRepositoryImpl(this.firestore);

  @override
  Future<List<Cinema>> getCinemas() async {
    final snapshot = await firestore.collection('cinemas').get();
    return snapshot.docs.map((doc) {
      return CinemaModel.fromJson({
        ...doc.data(),
        'id': doc.id,
      });
    }).toList();
  }
  @override
  Future<String> getCinemaName(String cinemaId) async {
    final doc = await firestore.collection('cinemas').doc(cinemaId).get();
    return doc.exists ? doc['name'] ?? 'Không rõ' : 'Không tìm thấy';
  }

  @override
  Future<List<Showtime>> getShowtimesByCinema(String cinemaId) async {
    final snapshot = await firestore
        .collection('showtimes')
        .where('cinemaId', isEqualTo: cinemaId)
        .get();

    return snapshot.docs.map((doc) {
      return ShowtimeModel.fromJson({
        ...doc.data(),
        'id': doc.id,
      });
    }).toList();
  }
  

}
