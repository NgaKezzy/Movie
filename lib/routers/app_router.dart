import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie/common/domain/entities/response/movie_data.dart';
import 'package:movie/core/di/di.dart';
import 'package:movie/features/auth/cubit/auth_cubit.dart';
import 'package:movie/features/auth/login_screen.dart';
import 'package:movie/features/auth/register_screen.dart';
import 'package:movie/features/home/models/param_movie_list_page.dart';
import 'package:movie/features/home/view/home_page.dart';
import 'package:movie/features/home/view/movie_list_page.dart';
import 'package:movie/features/home/view/watch_movie_screen.dart';
import 'package:movie/features/movie/cubit/movie_cubit.dart';
import 'package:movie/features/my_home_page.dart';
import 'package:movie/features/search/search_page.dart';
import 'package:movie/features/setting/movie_history_page.dart';
import 'package:movie/features/setting/setting_page.dart';
import 'package:movie/features/splash/splash_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class RouteName {
  RouteName._();

  static const String initial = '/';
  static const String onboardingPage = '/onboarding-page';
  static const String loginScreen = '/login-screen';
  static const String register = '/register';
  static const String myHomePage = '/my-home-page';
  static const String homePage = '/home-page';
  static const String searchPage = '/search-page';
  static const String movieHistoryPage = '/movie-history-page';
  static const String settingPage = '/setting-page';
  static const String watchMovie = '/watch-movie';
  // static const String movieHistory = '/movie-history';
  static const String movieListPage = '/movie-list-page';
}

class AppRoutes {
  static final AppRoutes _singleton = AppRoutes._internal();
  factory AppRoutes() {
    return _singleton;
  }
  AppRoutes._internal();

  /// Khai báo các màn hình mới tại đây
  GoRouter router = GoRouter(
    initialLocation: RouteName.initial,
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MyHomePage(shell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteName.homePage,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: BlocProvider.value(
                    value: getIt.get<MovieCubit>(),
                    child: HomePage(),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteName.searchPage,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: BlocProvider.value(
                    value: getIt.get<MovieCubit>(),
                    child: SearchPage(),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteName.movieHistoryPage,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: BlocProvider.value(
                    value: getIt.get<MovieCubit>(),
                    child: MovieHistoryPage(),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteName.settingPage,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: BlocProvider.value(
                    value: getIt.get<AuthCubit>(),
                    child: SettingPage(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteName.initial,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider.value(
            value: getIt.get<AuthCubit>(),

            child: SplashPage(),
          );
        },
      ),
      GoRoute(
        path: RouteName.loginScreen,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider.value(
            value: getIt.get<AuthCubit>(),
            child: LoginScreen(),
          );
        },
      ),
      GoRoute(
        path: RouteName.register,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider.value(
            value: getIt.get<AuthCubit>(),
            child: RegisterScreen(),
          );
        },
      ),

      GoRoute(
        path: RouteName.watchMovie,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider.value(
            value: getIt.get<MovieCubit>(),
            child: WatchMovieScreen(
              movie: state.extra is Movie ? state.extra as Movie : Movie(),
            ),
          );
        },
      ),

      GoRoute(
        path: RouteName.movieListPage,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider.value(
            value: getIt.get<MovieCubit>(),
            child: MovieListPage(
              param: state.extra is ParamMovieListPage
                  ? state.extra as ParamMovieListPage
                  : ParamMovieListPage(title: '', movies: []),
            ),
          );
        },
      ),
    ],
  );
}
