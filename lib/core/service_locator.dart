import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/data/repositories/booking_repository_impl.dart';
import 'package:my_app/domain/repositories/booking_repository.dart';
import 'package:my_app/domain/use_cases/get_booking_data.dart';
import 'package:my_app/domain/use_cases/get_movie_by_id.dart';
import 'package:my_app/presentation/view_model/booking_viewmodel.dart';

// Repositories
import '../data/repositories/user_repository_impl.dart';
import '../data/repositories/movie_repository_impl.dart';
import '../data/repositories/cinema_repository_impl.dart';

import '../domain/repositories/user_repository.dart';
import '../domain/repositories/movie_repository.dart';
import '../domain/repositories/cinema_repository.dart';

// Use Cases
import '../domain/use_cases/get_movies.dart';
import '../domain/use_cases/get_cinemas.dart';
import '../domain/use_cases/sign_in_use_case.dart';
import '../domain/use_cases/sign_up_use_case.dart';

// View Models
import '../presentation/view_model/home_view_model.dart';
import '../presentation/view_model/sign_in_view_model.dart';
import '../presentation/view_model/sign_up_view_model.dart';
import '../presentation/view_model/detail_film_view_model.dart';

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
  sl.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl( ));

  // Use Cases
  sl.registerLazySingleton(() => GetMovies(sl()));
  sl.registerLazySingleton(() => GetCinemas(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => GetMovieById(sl()));
  sl.registerLazySingleton(()=> GetMovieShowtimes(sl()));

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
        getMovieShowtimes: sl(), movieId: '',
      ));
}
