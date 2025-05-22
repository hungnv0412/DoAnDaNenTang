import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../view_model/ticket_viewmodel.dart';
import '../../../domain/entities/booking.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});
  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    // Gọi loadTickets khi vào trang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TicketViewmodel>(context, listen: false).loadTickets(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TicketViewmodel>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Danh sách vé", style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.bookings.isEmpty
              ? const Center(
                  child: Text(
                    "Bạn chưa đặt vé nào",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: vm.bookings.length,
                  itemBuilder: (context, index) {
                    final Booking booking = vm.bookings[index];
                    return Card(
                      color: Colors.blueGrey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.movieName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.event_seat, color: Colors.white54),
                                const SizedBox(width: 5),
                                Text(
                                  "Ghế: ${booking.seats.join(', ')}",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.attach_money, color: Colors.white54),
                                const SizedBox(width: 5),
                                Text(
                                  "Số tiền: ${booking.totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} VND",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.access_time, color: Colors.white54),
                                const SizedBox(width: 5),
                                Text(
                                  "Thời gian: ${booking.showtime} ${booking.showDate}",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  booking.paymentStatus,
                                  style: TextStyle(
                                    color: booking.paymentStatus == "Chưa thanh toán"
                                        ? Colors.red
                                        : Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                booking.paymentStatus == "Chưa thanh toán"
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          foregroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          // Xử lý thanh toán ở đây nếu cần
                                        },
                                        child: const Text("Thanh toán"),
                                      )
                                    : const Icon(Icons.check_circle,
                                        color: Colors.green, size: 28),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}