import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/ticket_detail_viewmodel.dart';

class TicketDetailScreen extends StatefulWidget {
  final String bookingId;
  const TicketDetailScreen({super.key, required this.bookingId});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TicketDetailViewmodel>(context, listen: false)
          .getBookingById(widget.bookingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TicketDetailViewmodel>(context);

    if (vm.isLoading == "true") {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Chi tiết vé', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.grey[900],
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Chi tiết vé', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.grey[900],
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Text(
            vm.errorMessage!,
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    final booking = vm.booking;
    if (booking == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Chi tiết vé', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.grey[900],
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Text(
            "Không tìm thấy thông tin đặt vé",
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    final double totalPrice = booking.totalPrice ?? 0.0;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Chi tiết vé', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          booking.movieName ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Divider(color: Colors.grey),
                      _buildInfoRow('Rạp:', booking.cinemaName ?? "", Icons.movie),
                      _buildInfoRow('Phòng:', booking.screenName ?? "", Icons.meeting_room),
                      _buildInfoRow('Ngày chiếu:', booking.showDate ?? "", Icons.calendar_today),
                      _buildInfoRow('Giờ chiếu:', booking.showtime ?? "", Icons.access_time),
                      _buildInfoRow('Ghế:', (booking.seats ?? []).join(', '), Icons.event_seat),
                      Divider(color: Colors.grey),
                      _buildInfoRow(
                        'Tổng tiền:',
                        '${totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} VND',
                        Icons.attach_money,
                        valueColor: Colors.greenAccent,
                      ),
                      _buildInfoRow(
                        'Trạng thái:',
                        booking.paymentStatus ?? "",
                        Icons.payment,
                        valueColor: booking.paymentStatus == 'Đã thanh toán'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (booking.paymentStatus == 'Chưa thanh toán')
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    '/payment',
                    arguments: {
                      'bookingId': widget.bookingId,
                      'totalPrice': totalPrice,
                    },
                  ),
                  child: Text(
                    'Thanh toán ngay',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          SizedBox(width: 8),
          Text('$label ', style: TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}