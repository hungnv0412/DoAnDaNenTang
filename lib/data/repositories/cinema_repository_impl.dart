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
      return Cinema(
        id: doc.id,
        name: doc['name'],
        location: doc['location'],
        imageUrl: doc['imageUrl'],
      );
    }).toList();
  }

  @override
  Future<Cinema> getCinemaById(String id) async {
    final doc = await firestore.collection('cinemas').doc(id).get();
    if (!doc.exists) throw Exception('Cinema not found');
    return CinemaModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  @override
  Future<List<Showtime>> getCinemaShowtimes(String cinemaId) async {
    final snapshot = await firestore
        .collection('showtimes')
        .where('cinemaId', isEqualTo: cinemaId)
        .get();
    
    return snapshot.docs
        .map((doc) => ShowtimeModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }
}
