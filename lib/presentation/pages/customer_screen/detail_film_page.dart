import 'package:flutter/material.dart';
import 'package:my_app/presentation/pages/customer_screen/booking_page.dart';
import 'package:provider/provider.dart';
import '../../view_model/detail_film_view_model.dart';

class DetailFilmPage extends StatefulWidget {
  final String movieId;

  const DetailFilmPage({Key? key, required this.movieId}) : super(key: key);

  @override
  _DetailFilmPageState createState() => _DetailFilmPageState();
}

class _DetailFilmPageState extends State<DetailFilmPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DetailFilmViewModel>(context, listen: false)
          .fetchMovieDetails(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DetailFilmViewModel>(context);

    return viewModel.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.black,
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      viewModel.movieDetails!.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          viewModel.movieDetails!.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Thể loại: ${viewModel.movieDetails!.genre}',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Thời lượng: ${viewModel.movieDetails!.duration}',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Ngày phát hành: ${viewModel.movieDetails!.releaseDate}',
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Mô tả:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          viewModel.movieDetails!.fullDescription,
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookingScreen(movieId: widget.movieId))),
                          child: Text('Đặt vé'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
