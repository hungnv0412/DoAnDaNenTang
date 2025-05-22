import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/data/models/booking_model.dart';
import 'package:my_app/domain/entities/booking.dart';
import 'package:my_app/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository{
  final FirebaseFirestore firestore;
  BookingRepositoryImpl(this.firestore);
  @override
  Future<List<Booking>> getBookingsByUserId(String userId) async {
    final snapshot = await firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) {
      return BookingModel.fromJson({
        ...doc.data(),
        'id': doc.id,
      });
    }).toList();
  }
  @override
  Future<Booking> getBookingById(String bookingId) async {
    final doc = await firestore.collection('bookings').doc(bookingId).get();
    if (doc.exists) {
      return BookingModel.fromJson({
        ...doc.data()!,
        'id': doc.id,
      });
    } else {
      throw Exception('Booking not found');
    }
  }
}