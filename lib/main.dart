import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:movie/core/di/di.dart';
import 'package:movie/core/language/cubit/language_cubit.dart';
import 'package:movie/routers/app_router.dart';
import 'package:movie/core/theme/cubit/theme_cubit.dart';
import 'package:toastification/toastification.dart';
import 'package:movie/core/language/l10n/app_localizations.dart';

enum BuildFlavor { dev, staging, production }

BuildFlavor appFlavor = BuildFlavor.dev;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );

  final directory = await getApplicationDocumentsDirectory();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(directory.path),
  );

  appFlavor = BuildFlavor.production; // khi build cần thay đổi môi trg ở đây

  await dotenv.load(fileName: '.env');

  final baseUrl = appFlavor == BuildFlavor.production
      ? dotenv.env['BASE_URL_PROD']
      : dotenv.env['BASE_URL_DEV'];

  await setup(baseUrl.toString());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>.value(value: getIt<LanguageCubit>()),
        BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return OverlaySupport.global(
          child: ToastificationWrapper(
            child: MaterialApp.router(
              builder: (context, child) {
                ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                  return Scaffold(
                    body: Center(child: Text(language!.somethingWentWrong)),
                  );
                };
                return child!;
              },
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: Locale(context.watch<LanguageCubit>().state.languageCode),
              debugShowCheckedModeBanner: false,
              routerConfig: AppRoutes().router,
              themeMode: context.watch<ThemeCubit>().state.isDark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
            ),
          ),
        );
      },
    );
  }
}
