import 'dart:io';

import 'package:app/config/di.dart';
import 'package:app/feature/home/cubit/home_page_cubit.dart';
import 'package:app/firebase/firebase_api.dart';
import 'package:app/firebase_options.dart';
import 'package:app/l10n/cubit/locale_cubit.dart';
import 'package:app/local_storage/local_storage.dart';
import 'package:app/routers/router.dart';
import 'package:app/theme/cubit/theme_cubit.dart';
import 'package:app/theme/dark_theme.dart';
import 'package:app/theme/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

String language = 'vi';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.top,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  final directory = await getApplicationDocumentsDirectory();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(directory.path),
  );
  await Hive.initFlutter('dev_box');
  await LocalStorage.hiveRegisterAdapter();
  await LocalStorage.hiveOpenBox();
  await setup();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

    await FirebaseApi().initNotifications();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocaleCubit(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => HomePageCubit(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late LocaleCubit localeCubit;
  late ThemeCubit themeCubitRead;
  @override
  void initState() {
    themeCubitRead = context.read<ThemeCubit>();
    localeCubit = context.read<LocaleCubit>();
    themeCubitRead.initTheme();
    localeCubit.initLanguage();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeCubit themeCubit = context.watch<ThemeCubit>();
    final LocaleCubit localeCubitWatch = context.watch<LocaleCubit>();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // kiểm tra xem biến true hay false rồi chuyển ngôn ngữ tương ứng
      locale: Locale(localeCubit.state.languageCode.isEmpty
          ? 'en'
          : localeCubitWatch.state.languageCode),
      // kiểm tra xem biến true hay false rồi sẽ gán file màu tương ứng
      theme: themeCubit.state.isDark ? dark : light,
      routerConfig: AppRoutes().router,
    );
  }
}
