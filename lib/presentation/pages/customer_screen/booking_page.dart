import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/presentation/pages/customer_screen/selected_seat.dart';
import 'package:my_app/presentation/view_model/booking_viewmodel.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatefulWidget {
  final String movieId;
  const BookingScreen({required this.movieId});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {

  @override
  void initState() {
    super.initState();
    // Load danh sách ngày chiếu khi vào trang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingViewModel>(context, listen: false)
          .loadAvailableDates(widget.movieId);
      Provider.of<BookingViewModel>(context, listen: false).clear();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BookingViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Đặt vé")),
      body: vm.isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Chọn ngày:", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: vm.availableDates.map((dateStr) {
                      final date = DateFormat("d/M/yyyy").parse(dateStr);
                      return ChoiceChip(
                        label: Text(DateFormat('dd/MM').format(date)),
                        selected: vm.selectedDate == date,
                        onSelected: (_) async {
                          if (vm.selectedDate != date) {
                            // Clear cinema & showtimes khi chọn ngày mới
                            vm.selectedCinema = null;
                            vm.showtimes = [];
                            await vm.selectDate(widget.movieId, date);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24),
                  if (vm.selectedDate != null) ...[
                    Text("Chọn rạp:", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    ...vm.availableCinemas.map((cinema) {
                      final isSelected = vm.selectedCinema?.id == cinema.id;
                      return Card(
                        child: ListTile(
                          title: Text(cinema.name),
                          subtitle: Text(cinema.location),
                          selected: isSelected,
                          onTap: () async {
                            if (!isSelected) {
                              // Clear showtimes khi chọn rạp mới
                              vm.showtimes = [];
                              await vm.selectCinema(widget.movieId, cinema);
                            }
                          },
                          trailing: isSelected
                              ? Icon(Icons.keyboard_arrow_down)
                              : Icon(Icons.keyboard_arrow_right),
                        ),
                      );
                    }),
                  ],
                  SizedBox(height: 24),
                  if (vm.selectedCinema != null) ...[
                    Text("Chọn giờ chiếu:", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    vm.showtimes.isEmpty
                        ? Text("Không có suất chiếu.")
                        : Wrap(
                            spacing: 8,
                            children: vm.showtimes.map((showtime) => 
                              GestureDetector(
                                onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SeatSelectionScreen(
                                      movieId: widget.movieId,
                                      cinemaId: vm.selectedCinema!.id,
                                      screenId: showtime.screenId,
                                      showtimeId: showtime.id,
                                    ),
                                  ),
                                ),
                                child: Chip(label: Text(showtime.time)),
                              )
                            ).toList(),
                          ),
                  ], 
                ],
              ),
            ),
    );
  }
}