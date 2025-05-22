import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/select_seat_viewmodel.dart';
import '../../../domain/entities/seat.dart';

class SeatSelectionScreen extends StatefulWidget {
  final String cinemaId;
  final String screenId;
  final String showtimeId;
  final String movieId;
  const SeatSelectionScreen({
    super.key,
    required this.cinemaId,
    required this.screenId,
    required this.showtimeId,
    required this.movieId,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Load seats khi vào màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SelectSeatViewmodel>(context, listen: false)
          .loadSeats(widget.showtimeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SelectSeatViewmodel>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      appBar: AppBar(
        title: const Text("Chọn ghế", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "MÀN HÌNH",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(top: 150, left: 5, right: 5),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: vm.seats.length,
                    itemBuilder: (context, index) {
                      final seat = vm.seats[index];
                      final isBooked = seat.isBooked;
                      final isSelected = vm.selectedSeats.contains(seat);

                      return GestureDetector(
                        onTap: isBooked
                            ? null
                            : () => vm.toggleSeatSelection(seat),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isBooked
                                ? const Color.fromARGB(255, 175, 8, 8)
                                : (isSelected
                                    ? Colors.green
                                    : const Color.fromARGB(255, 56, 60, 62)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            seat.seatNumber,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Tổng tiền:",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      Text(
                        "${vm.totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} VND",
                        style: const TextStyle(
                            color: Colors.orangeAccent, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: (vm.selectedSeats.isEmpty || vm.isLoading)
                      ? null
                      : () async {
                          final bookingInfo = {
                            "movieId": widget.movieId,
                            "cinemaId": widget.cinemaId,
                            "screenId": widget.screenId,
                            "showtimeId": widget.showtimeId,
                            "totalPrice": vm.totalPrice,
                            "userId": FirebaseAuth.instance.currentUser?.uid,
                          };
                          try {
                            await vm.confirmBooking(bookingInfo: bookingInfo);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Đặt vé thành công!")),
                              );
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Đặt vé thất bại: $e")),
                              );
                            }
                          }
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey;
                        }
                        return Colors.green;
                      },
                    ),
                  ),
                  child: vm.isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Xác nhận đặt vé",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
              ],
            ),
    );
  }
}