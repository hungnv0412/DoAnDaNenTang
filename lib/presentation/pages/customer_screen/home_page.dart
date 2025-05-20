import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:my_app/presentation/pages/customer_screen/cinema_detail_page.dart';
import 'package:my_app/presentation/pages/customer_screen/detail_film_page.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:my_app/presentation/view_model/home_view_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeViewModel>(context, listen: false).fetchMovies();
      Provider.of<HomeViewModel>(context, listen: false).fetchCinemas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.waving_hand, color: Colors.orangeAccent),
            const SizedBox(width: 5),
            const Text("Hello  ",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            Text(homeViewModel.currentUser?.name ?? "Guest",
                style:
                    const TextStyle(color: Colors.orangeAccent, fontSize: 18)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text("Welcome To,", style: TextStyle(color: Colors.white70)),
            const Text(
              "H Cinemas",
              style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Danh sách phim",
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ToggleButtons(
                isSelected: [selectedIndex == 0, selectedIndex == 1],
                borderRadius: BorderRadius.circular(10),
                color: Colors.white70,
                selectedColor: Colors.white,
                fillColor: Colors.grey[800],
                onPressed: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Đang Chiếu", style: TextStyle(fontSize: 16)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Sắp Chiếu", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            homeViewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: homeViewModel.movies.isEmpty
                        ? const Center(
                            child: Text("Không có phim nào",
                                style: TextStyle(color: Colors.white)),
                          )
                        : FlutterCarousel.builder(
                            itemCount: homeViewModel.movies.length,
                            options: FlutterCarouselOptions(
                              autoPlay: false,
                              enlargeCenterPage: true,
                              viewportFraction: 0.5,
                              showIndicator: false,
                              initialPage: (homeViewModel.movies.length) ~/ 2,
                              enableInfiniteScroll: true,
                            ),
                            itemBuilder: (context, index, realIdx) {
                              var movie = homeViewModel.movies[index];
                              DateTime now = DateTime.now();
                              DateTime releaseDate = DateFormat("dd/MM/yyyy")
                                  .parse(movie.releaseDate);

                              if ((selectedIndex == 0 &&
                                      releaseDate.isAfter(now)) ||
                                  (selectedIndex == 1 &&
                                      (releaseDate.isBefore(now) ||
                                          releaseDate.isAtSameMomentAs(now)))) {
                                return SizedBox.shrink();
                              }

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailFilmPage(movieId: movie.id,),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 150,
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color.fromARGB(
                                                255, 95, 90, 90)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                              movie.imageUrl,
                                              width: 150,
                                              height: 220,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 0),
                                      child: Text(
                                        movie.name,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
            SizedBox(height: 20),
            Text(
              "Danh sách rạp",
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            homeViewModel.isLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: homeViewModel.cinemas.isEmpty
                        ? Center(
                            child: Text("Không có rạp nào",
                                style: TextStyle(color: Colors.white)),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: homeViewModel.cinemas.length,
                            itemBuilder: (context, index) {
                              var cinema = homeViewModel.cinemas[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CinemaDetailPage(cinemaId: cinema.id),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 150,
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color.fromARGB(255, 95, 90, 90)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          cinema.imageUrl,
                                          width: 150,
                                          height: 220,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 0),
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            child: Text(
                                              cinema.name,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
