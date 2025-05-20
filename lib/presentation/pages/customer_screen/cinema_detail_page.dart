import 'package:flutter/material.dart';
import 'package:my_app/presentation/view_model/cinema_detail_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:my_app/presentation/pages/customer_screen/detail_film_page.dart';


class CinemaDetailPage extends StatelessWidget {
  final String cinemaId;

  const CinemaDetailPage({
    Key? key,
    required this.cinemaId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CinemaDetailViewModel(cinemaId),
      child: const _CinemaDetailView(),
    );
  }
}

class _CinemaDetailView extends StatelessWidget {
  const _CinemaDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CinemaDetailViewModel>();

    List<Map<String, dynamic>> filteredMovies = viewModel.moviesList
        .where((movie) =>
            movie['date'] == viewModel.selectedDate &&
            movie['time'] == viewModel.selectedHour)
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(viewModel.cinemaName, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: viewModel.isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: viewModel.availableDates.length,
                    itemBuilder: (context, index) {
                      String date = viewModel.availableDates[index];
                      return GestureDetector(
                        onTap: () => viewModel.selectDate(date),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: viewModel.selectedDate == date
                                ? Colors.blueAccent
                                : Colors.grey[850],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              date,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 10),

                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: viewModel.showtimeHours.length,
                    itemBuilder: (context, index) {
                      String hour = viewModel.showtimeHours[index];
                      return GestureDetector(
                        onTap: () => viewModel.selectHour(hour),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: viewModel.selectedHour == hour
                                ? Colors.redAccent
                                : Colors.grey[850],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              hour,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 10),

                Expanded(
                  child: filteredMovies.isEmpty
                      ? Center(
                          child: Text(
                            "Không có phim nào cho thời gian này!",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredMovies.length,
                          itemBuilder: (context, index) => _buildMovieCard(context, filteredMovies[index]),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildMovieCard(BuildContext context, Map<String, dynamic> movie) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Image.network(
          movie['posterUrl'],
          width: 50,
          height: 75,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(child: CircularProgressIndicator(color: Colors.white));
          },
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.broken_image, size: 50, color: Colors.grey);
          },
        ),
        title: Text(
          movie['movieName'],
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          "Giờ: ${movie['time']} - Ngày: ${movie['date']}",
          style: TextStyle(color: Colors.grey[400]),
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.white),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailFilmPage(movieId: movie['movieId']),
            ),
          );
        },
      ),
    );
  }
}
