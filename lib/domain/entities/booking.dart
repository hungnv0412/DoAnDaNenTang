class Booking {
  final String id;
  final String userId;
  final String cinemaName;
  final String screenName;
  final String movieName;
  final String paymentStatus;
  final String showtime;
  final String showDate;
  final List<String> seats;
  final double totalPrice;
  final DateTime bookingTime;

  Booking({
    required this.id,
    required this.userId,
    required this.cinemaName,
    required this.screenName,
    required this.movieName,
    required this.paymentStatus,
    required this.showtime,
    required this.showDate,
    required this.seats,
    required this.totalPrice,
    required this.bookingTime,
  });
}