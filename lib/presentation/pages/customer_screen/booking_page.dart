import 'package:flutter/material.dart';
import 'package:my_app/domain/use_cases/get_booking_data.dart';
import 'package:my_app/presentation/view_model/booking_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/booking_repository_impl.dart';

class BookingScreen extends StatelessWidget {
  final String movieId;

  const BookingScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingViewModel(
        movieId: movieId,
        getMovieShowtimes: GetMovieShowtimes(
          BookingRepositoryImpl(),
        ),
      ),
      child: Consumer<BookingViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text(
                viewModel.movie?.name ?? "Đang tải...",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.grey[900],
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: viewModel.isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.white))
                : viewModel.availableDates.isEmpty
                    ? Center(
                        child: Text(
                          "Không có suất chiếu nào",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDateList(viewModel),
                          if (viewModel.selectedDate != null)
                            _buildCinemaList(viewModel),
                        ],
                      ),
          );
        },
      ),
    );
  }

  Widget _buildDateList(BookingViewModel viewModel) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.availableDates.length,
        itemBuilder: (context, index) {
          String date = viewModel.availableDates[index];
          return GestureDetector(
            onTap: () => viewModel.selectDate(date),
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: viewModel.selectedDate == date
                    ? Colors.blueAccent
                    : Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                date,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCinemaList(BookingViewModel viewModel) {
    return Expanded(
      child: ListView(
        children: viewModel.cinemaShowtimes[viewModel.selectedDate]!
            .map((cinema) => Card(
                  color: Colors.grey[850],
                  margin: EdgeInsets.all(8),
                  child: ExpansionTile(
                    title: Text(
                      cinema["cinemaName"],
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      cinema["location"],
                      style: TextStyle(color: Colors.white70),
                    ),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    children: [
                      _buildShowtimeList(viewModel, cinema),
                      SizedBox(height: 10),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildShowtimeList(BookingViewModel viewModel, Map<String, dynamic> cinema) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: viewModel.cinemaShowtimes[viewModel.selectedDate]!
          .where((item) => item["cinemaId"] == cinema["cinemaId"])
          .map((showtime) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onPressed: () {
                  // Navigate to seat selection
                },
                child: Text(
                  showtime["time"],
                  style: TextStyle(color: Colors.white),
                ),
              ))
          .toList(),
    );
  }
}