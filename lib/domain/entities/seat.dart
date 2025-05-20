class Seat {
  final String id;
  final String showtimeId;
  final String screenId;
  final String cinemaId;
  final String seatNumber;
  final bool isBooked;
  final double price;

  Seat({
    required this.id,
    required this.showtimeId,
    required this.screenId,
    required this.cinemaId,
    required this.seatNumber,
    required this.isBooked,
    required this.price,
  });
}
