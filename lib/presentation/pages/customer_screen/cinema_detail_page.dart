import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/presentation/view_model/cinema_detail_viewmodel.dart';
import 'package:my_app/presentation/pages/customer_screen/detail_film_page.dart';
import '../../../domain/use_cases/get_cinema_detail.dart';

class CinemaDetailPage extends StatefulWidget {
  final String cinemaId;

  const CinemaDetailPage({
    super.key,
    required this.cinemaId,
  });
  @override
  State<CinemaDetailPage> createState() => _CinemaDetailPageState();
}

class _CinemaDetailPageState extends State<CinemaDetailPage>  {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CinemaDetailViewModel>().fetchData(widget.cinemaId);
    });
  }
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CinemaDetailViewModel>();

    // Lọc danh sách phim theo ngày và giờ đã chọn
    final filteredMovies = viewModel.moviesList.where((movie) {
      final matchDate = movie.date == viewModel.selectedDate;
      final matchHour = viewModel.selectedHour.isEmpty || movie.time == viewModel.selectedHour;
      return matchDate && matchHour;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(viewModel.cinemaName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Danh sách ngày
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
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: viewModel.selectedDate == date
                                ? Colors.blueAccent
                                : Colors.grey[850],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              date,
                              style: const TextStyle(
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

                const SizedBox(height: 10),

                // Danh sách giờ chiếu
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
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: viewModel.selectedHour == hour
                                ? Colors.redAccent
                                : Colors.grey[850],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              hour,
                              style: const TextStyle(
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

                const SizedBox(height: 10),

                // Danh sách phim
                Expanded(
                  child: filteredMovies.isEmpty
                      ? const Center(
                          child: Text(
                            "Không có phim nào cho thời gian này!",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredMovies.length,
                          itemBuilder: (context, index) =>
                              _buildMovieCard(context, filteredMovies[index]),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildMovieCard(BuildContext context, CinemaMovieInfo movie) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Image.network(
          movie.posterUrl,
          width: 50,
          height: 75,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          },
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
          },
        ),
        title: Text(
          movie.movieName,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          "Giờ: ${movie.time} - Ngày: ${movie.date}",
          style: TextStyle(color: Colors.grey[400]),
        ),
        trailing: const Icon(Icons.arrow_forward, color: Colors.white),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailFilmPage(movieId: movie.movieId),
            ),
          );
        },
      ),
    );
  }
}