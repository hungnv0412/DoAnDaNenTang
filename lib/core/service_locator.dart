import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/domain/repositories/booking_repository.dart';
import 'package:my_app/domain/repositories/seat_repository.dart';
import 'package:my_app/domain/use_cases/book_seat_usecase.dart';
import 'package:my_app/domain/use_cases/get_booking_by_id_usecase.dart';
import 'package:my_app/domain/use_cases/get_booking_by_userId.dart';
import 'package:my_app/domain/use_cases/get_seat_usecase.dart';
import 'package:my_app/domain/use_cases/sign_out_use_case.dart';
import 'package:my_app/presentation/view_model/cinema_detail_viewmodel.dart';
import 'package:my_app/presentation/view_model/profile_viewmodel.dart';
import 'package:my_app/presentation/view_model/select_seat_viewmodel.dart';

// Repositories
import '../data/repositories/booking_repository_impl.dart'
    show BookingRepositoryImpl;
import '../data/repositories/seat_repository_impl.dart';
import '../data/repositories/showtimes_repository_impl.dart';
import '../data/repositories/user_repository_impl.dart';
import '../data/repositories/movie_repository_impl.dart';
import '../data/repositories/cinema_repository_impl.dart';

import '../domain/repositories/showtimes_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/repositories/movie_repository.dart';
import '../domain/repositories/cinema_repository.dart';

// Use Cases
import '../domain/use_cases/get_booking_data.dart';
import '../domain/use_cases/get_cinema_detail.dart';
import '../domain/use_cases/get_movie_by_id.dart';
import '../domain/use_cases/get_movies.dart';
import '../domain/use_cases/get_cinemas.dart';
import '../domain/use_cases/sign_in_use_case.dart';
import '../domain/use_cases/sign_up_use_case.dart';

// View Models
import '../presentation/view_model/booking_viewmodel.dart';
import '../presentation/view_model/home_view_model.dart';
import '../presentation/view_model/sign_in_view_model.dart';
import '../presentation/view_model/sign_up_view_model.dart';
import '../presentation/view_model/detail_film_view_model.dart';
import '../presentation/view_model/ticket_detail_viewmodel.dart';
import '../presentation/view_model/ticket_viewmodel.dart' show TicketViewmodel;

final sl = GetIt.instance;

void init() {
  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Repositories
  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(sl()));
  sl.registerLazySingleton<CinemaRepository>(() => CinemaRepositoryImpl(sl()));
  sl.registerLazySingleton<ShowtimesRepository>(
      () => ShowtimesRepositoryImpl(sl()));
  sl.registerLazySingleton<SeatRepository>(() => SeatRepositoryImpl(sl()));
  sl.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetMovies(sl()));
  sl.registerLazySingleton(() => GetCinemas(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => GetMovieById(sl()));
  sl.registerLazySingleton(() => GetAvailableDatesUseCase(sl()));
  sl.registerLazySingleton(() => GetCinemasByMovieAndDateUseCase(sl()));
  sl.registerLazySingleton(() => GetShowtimesUseCase(sl()));
  sl.registerLazySingleton(() => GetCinemaDetailUseCase(sl(), sl()));
  sl.registerLazySingleton(() => GetSeatUsecase(sl()));
  sl.registerLazySingleton(() => BookSeatUsecase(sl()));
  sl.registerLazySingleton(() => GetBookingByUserid(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetBookingByIdUsecase(sl()));

  // View Models
  sl.registerFactory(() => HomeViewModel(
        getMovies: sl(),
        getCinemas: sl(),
      ));
  sl.registerFactory(() => SignInViewModel(signInUseCase: sl()));
  sl.registerFactory(() => SignUpViewModel(signUpUseCase: sl()));
  sl.registerFactory(() => DetailFilmViewModel(
        getMovieById: sl(),
      ));
  sl.registerFactory(() => BookingViewModel(
      getDatesUseCase: sl(),
      getCinemasUseCase: sl(),
      getShowtimesUseCase: sl(),
      getMovieByIdUseCase: sl()));
  sl.registerFactory(() => CinemaDetailViewModel(
        useCase: sl(),
      ));
  sl.registerFactory(
      () => SelectSeatViewmodel(bookSeatUsecase: sl(), getSeatUsecase: sl()));
  sl.registerFactory(() => TicketViewmodel(getBookingByUserid: sl()));
  sl.registerFactory(() => ProfileViewmodel(
        signOutUseCase: sl(),
      ));
  sl.registerFactory(() => TicketDetailViewmodel(
        getBookingByIdUsecase: sl(),
      ));
}
