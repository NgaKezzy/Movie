import 'package:app/feature/home/cubit/movie_cubit.dart';
import 'package:app/feature/login/cubit/auth_cubit.dart';
import 'package:get_it/get_it.dart';

final di = GetIt.instance;

Future<void> setup() async {
  di.registerSingleton<MovieCubit>(MovieCubit());
  di.registerSingleton<AuthCubit>(AuthCubit());

// Alternatively you could write it if you don't like global variables
}
