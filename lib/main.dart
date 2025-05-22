import 'package:flutter/material.dart';
import 'package:my_app/presentation/pages/customer_screen/bottom_nav.dart';

import 'package:my_app/presentation/pages/customer_screen/home_page.dart';
import 'package:my_app/presentation/view_model/booking_viewmodel.dart';
import 'package:my_app/presentation/view_model/detail_film_view_model.dart';
import 'package:my_app/presentation/view_model/select_seat_viewmodel.dart';
import 'package:my_app/presentation/view_model/sign_in_view_model.dart';
import 'package:my_app/presentation/view_model/sign_up_view_model.dart';
import 'package:my_app/presentation/view_model/ticket_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/service_locator.dart';
import 'presentation/view_model/cinema_detail_viewmodel.dart';
import 'presentation/view_model/home_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  init(); // Initialize dependencies
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<HomeViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<SignInViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<SignUpViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<DetailFilmViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<BookingViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<CinemaDetailViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<SelectSeatViewmodel>()),
        ChangeNotifierProvider(create: (_) => sl<TicketViewmodel>()),
        // Add other states here as needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Bottomnav(), // Ensure this widget is correctly imported
      ),
    );
  }
}
