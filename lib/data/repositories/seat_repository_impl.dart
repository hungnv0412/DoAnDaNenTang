
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/data/models/seat_model.dart';
import 'package:my_app/domain/repositories/seat_repository.dart';

import '../../domain/entities/seat.dart';

class SeatRepositoryImpl implements SeatRepository{
  final FirebaseFirestore firestore;
  SeatRepositoryImpl(this.firestore);
  @override
  Future<List<Seat>> getSeatsByShowtime(String showtimeId) async {
    try {
      final snapshot = await firestore
          .collection('seats').where('showtimeId', isEqualTo: showtimeId).get();
      if (snapshot.docs.isEmpty) {
        throw Exception('No available seats found for this showtime.');
      }
      final seats = snapshot.docs.map((doc) {
        return SeatModel.fromJson({
          ...doc.data(),
          'id': doc.id,
        });
      }).toList();
      return seats;
    } catch (e) {
      throw Exception('Failed to fetch available seats: $e');
    }
  }
  @override
  Future<void> bookSeats(List<Seat> seats, Map<String, dynamic> paymentInfo) async {
    try{
      final firestore = this.firestore;
      final cinemaDoc = await firestore.collection("cinemas").doc(paymentInfo["cinemaId"]).get();
      final screenDoc = await firestore.collection("screens").doc(paymentInfo["screenId"]).get();
      final showtimeDoc = await firestore.collection("showtimes").doc(paymentInfo["showtimeId"]).get();
      final movieDoc = await firestore.collection("movies").doc(paymentInfo["movieId"]).get();
      final seatNumbers = seats.map((e) => e.seatNumber).toList();
      if (!cinemaDoc.exists || !screenDoc.exists || !showtimeDoc.exists || !movieDoc.exists) {
        throw Exception('Invalid booking information.');
      }
      WriteBatch batch = firestore.batch();
      for(var seat in seats){
        var seatRef = firestore
            .collection("seats")
            .doc(seat.id);
        batch.update(seatRef, {"isBooked": true});
      }
      var bookingRef = firestore.collection('bookings').doc();
      batch.set(bookingRef, {
        "seats": seatNumbers,
        "totalPrice": paymentInfo["totalPrice"],
        "paymentStatus": "Chưa thanh toán",
        "userId": paymentInfo["userId"],
        "bookingTime": DateTime.now(),
        "cinemaName": cinemaDoc["name"],
        "screenName": screenDoc["name"],
        "showtime": showtimeDoc["time"],
        "movieName": movieDoc["name"],
        "totalPrice": paymentInfo["totalPrice"],
        "showDate": showtimeDoc["date"],
      });
      await batch.commit();
    }
    catch(e){
      throw Exception('Failed to book seats: $e');
    }
  }
}