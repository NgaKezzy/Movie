import 'dart:io';

import 'package:app/config/print_color.dart';
import 'package:app/feature/favorite/favorite_movie_page.dart';
import 'package:app/feature/home/home_page_provider.dart';
import 'package:app/feature/movie_cartoon/movie_cartoon_provider.dart';
import 'package:app/feature/movie_serial/movie_serial_provider.dart';
import 'package:app/feature/setting/setting_page.dart';
import 'package:app/feature/setting/setting_page_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class MyHomeApp extends StatefulWidget {
  const MyHomeApp({super.key});

  @override
  State<MyHomeApp> createState() => _MyHomeAppState();
}

class _MyHomeAppState extends State<MyHomeApp> {
  int pageIndex = 0;
  List<Widget> pages = [
    const HomePageProvider(),
    MovieSerialProvider(),
    const FavoriteMoviePage(),
    // MovieCartoonProvider(),
    const SettingPageProvider()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Lắng nghe thông báo khi app đang mở

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground Notification: ${message.notification?.title}");
    });

    // Lắng nghe sự kiện nhấn vào thông báo
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Foreground Notification: ${message.notification?.title}");
    });

    // Kiểm tra nếu app được mở từ thông báo
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message?.data['route'] != null && message?.data['slug'] != null) {
        final String slug = message?.data['slug'];
        final String route = message?.data['route'];
        context.pushReplacement(route, extra: slug);
        printRed(route);
        printRed(slug);
      }
      print("Foreground Notification: ${message?.notification?.title}");
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final app = AppLocalizations.of(context);
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: pages[pageIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: theme.colorScheme.surface,
          type: BottomNavigationBarType.fixed,
          currentIndex: pageIndex,
          unselectedIconTheme: IconThemeData(color: theme.colorScheme.tertiary),
          showUnselectedLabels: true,
          showSelectedLabels: true,
          unselectedItemColor: theme.colorScheme.tertiary,
          selectedItemColor: theme.colorScheme.onPrimary,
          onTap: (value) {
            setState(() {
              pageIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/home.svg',
                color: theme.colorScheme.tertiary,
              ),
              label: app?.home,
              activeIcon: SvgPicture.asset(
                'assets/icons/home.svg',
                color: theme.colorScheme.onPrimary,
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/movie.svg',
                width: 24,
                color: theme.colorScheme.tertiary,
              ),
              label: app?.seriesMovie,
              activeIcon: SvgPicture.asset(
                'assets/icons/movie.svg',
                width: 24,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/heart.svg',
                color: theme.colorScheme.tertiary,
              ),
              label: app?.favorite,
              activeIcon: SvgPicture.asset(
                'assets/icons/heart.svg',
                color: theme.colorScheme.onPrimary,
              ),
            ),
            // BottomNavigationBarItem(
            //   icon: SvgPicture.asset(
            //     'assets/icons/bear.svg',
            //     width: 24,
            //     color: theme.colorScheme.tertiary,
            //   ),
            //   label: app?.cartoon,
            //   activeIcon: SvgPicture.asset(
            //     'assets/icons/bear.svg',
            //     width: 24,
            //     color: theme.colorScheme.onPrimary,
            //   ),
            // ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/setting.svg',
                color: theme.colorScheme.tertiary,
              ),
              label: app?.setting,
              activeIcon: SvgPicture.asset(
                'assets/icons/setting.svg',
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
