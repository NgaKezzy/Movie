import 'dart:io';

import 'package:cupertino_native/components/tab_bar.dart';
import 'package:cupertino_native/style/sf_symbol.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie/core/language/l10n/app_localizations.dart';
import 'package:movie/common/widgets/dot_navigation_bar/DotNavigationBarItem.dart';
import 'package:movie/common/widgets/dot_navigation_bar/NavBars.dart';
import 'package:movie/features/home/home_provider/home_provider.dart';
import 'package:movie/features/search/search_provider/search_provider.dart';
import 'package:movie/features/setting/setting_provider/movie_history_provider.dart';
import 'package:movie/features/setting/setting_provider/setting_provider.dart';
import 'package:movie/routers/app_router.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.child});
  final Widget child;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _getIndex(String location) {
    if (location.startsWith(AppRouteConstant.homePage)) return 0;
    if (location.startsWith(AppRouteConstant.searchPage)) return 1;
    if (location.startsWith(AppRouteConstant.movieHistoryPage)) return 2;
    if (location.startsWith(AppRouteConstant.settingPage)) return 3;
    return 0;
  }

  void onTap(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRouteConstant.homePage);
        break;
      case 1:
        context.go(AppRouteConstant.searchPage);
        break;
      case 2:
        context.go(AppRouteConstant.movieHistoryPage);
        break;
      case 3:
        context.go(AppRouteConstant.settingPage);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    return PopScope(
      canPop: true,
      child: Scaffold(
        body: widget.child,
        extendBodyBehindAppBar: true,
        extendBody: true,
        bottomNavigationBar: _buildBottomNavigationBar(context, location),
      ),
    );
  }

  Widget? _buildBottomNavigationBar(BuildContext context, String location) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final language = AppLocalizations.of(context);

    if (Platform.isIOS) {
      return // Overlay this at the bottom of your page
      CNTabBar(
        rightCount: 1,
        split: true,
        items: [
          CNTabBarItem(label: language?.home, icon: CNSymbol('house.fill')),
          CNTabBarItem(
            label: language?.search,
            icon: CNSymbol('magnifyingglass'),
          ),
          CNTabBarItem(label: language?.history, icon: CNSymbol('clock')),
          CNTabBarItem(
            label: language?.setting,
            icon: CNSymbol('gearshape.fill'),
          ),
        ],
        currentIndex: _getIndex(location),
        onTap: (value) {
          onTap(value, context);
        },
      );
    } else {
      return DotNavigationBar(
        marginR: EdgeInsets.only(bottom: 20, left: 50, right: 50),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        // backgroundColor: Colors.red,
        paddingR: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        enablePaddingAnimation: false,
        dotIndicatorColor: Colors.transparent,
        currentIndex: _getIndex(location),
        onTap: (index) {
          onTap(index, context);
        },
        items: [
          DotNavigationBarItem(
            icon: const Icon(Icons.home),
            selectedColor: Colors.purple,
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.search),
            selectedColor: Colors.pink,
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.history),
            selectedColor: Colors.orange,
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.settings),
            selectedColor: Colors.teal,
          ),
        ],
      );
    }
  }
}
