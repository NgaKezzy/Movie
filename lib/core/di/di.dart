
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:movie/common/data/data_source/local/local_storage.dart';
import 'package:movie/common/data/data_source/remote/movie_data_source.dart';
import 'package:movie/common/data/data_source/repository/movie_repository_iplm.dart';
import 'package:movie/core/dio/app_dio.dart';
import 'package:movie/core/language/cubit/language_cubit.dart';
import 'package:movie/core/logger/app_logger.dart';
import 'package:movie/core/theme/cubit/theme_cubit.dart';
import 'package:movie/features/auth/cubit/auth_cubit.dart';
import 'package:movie/features/movie/cubit/movie_cubit.dart';

final getIt = GetIt.instance;

Future<void> setup(String baseUrl) async {
  getIt.registerSingleton<Logger>(AppLogger.logger);
  getIt.registerSingleton<Dio>(AppNetworkModule.provideDio());
  getIt.registerSingleton<SharedPrefs>(SharedPrefs());
  await getIt<SharedPrefs>().init();

  // data_source
  getIt.registerSingleton<MovieDataSource>(
    MovieDataSource(getIt.get(), baseUrl: baseUrl),
  );

  // repository
  getIt.registerSingleton<MovieRepositoryImpl>(
    MovieRepositoryImpl(movieDataSource: getIt.get()),
  );

  // Cubit
  getIt.registerSingleton<ThemeCubit>(ThemeCubit(getIt.get()));

  getIt.registerSingleton<LanguageCubit>(LanguageCubit(getIt.get()));

  getIt.registerSingleton<MovieCubit>(
    MovieCubit(movieRepositoryImpl: getIt.get()),
  );
  getIt.registerSingleton<AuthCubit>(AuthCubit());
}
