import 'package:app/component/header_app.dart';
import 'package:app/component/item_setting.dart';
import 'package:app/config/app_size.dart';
import 'package:app/config/di.dart';
import 'package:app/feature/home/cubit/movie_cubit.dart';
import 'package:app/feature/login/cubit/auth_cubit.dart';
import 'package:app/feature/login/cubit/auth_state.dart';
import 'package:app/feature/setting/select_language.dart';
import 'package:app/routers/router.dart';
import 'package:app/theme/cubit/theme_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  AuthCubit authCubit = di.get();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context).colorScheme;
    final ThemeCubit themeCubit = context.watch<ThemeCubit>();
    final app = AppLocalizations.of(context);
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(app!.setting),
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: state.userInfo?.photoUrl ?? '',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(state.userInfo?.name ?? ''),
                SizedBox(
                  height: 10,
                ),
                ItemSetting(
                  path: 'assets/icons/premium.svg',
                  text: app.premiumMember,
                  onTap: () {
                    context.push(AppRouteConstant.premium);
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  width: width,
                  // color: Colors.red,\
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          themeCubit.state.isDark
                              ? SvgPicture.asset('assets/icons/moon.svg',
                                  color: theme.onPrimary)
                              : SvgPicture.asset('assets/icons/sun.svg',
                                  color: theme.onPrimary),
                          const SizedBox(
                            width: AppSize.size10,
                          ),
                          Text(app.darkMode),
                        ],
                      ),
                      Switch(
                        // This bool value toggles the switch.
                        value: themeCubit.state.isDark,
                        activeColor: Colors.red,
                        onChanged: (bool value) {
                          // chỗ này nhấn nút để gọi hàm thay đổi chế độ sáng tối
                          context.read<ThemeCubit>().toggedTheme();
                        },
                      )
                    ],
                  ),
                ),
                ItemSetting(
                  path: 'assets/icons/global.svg',
                  text: app.language,
                  onTap: () {
                    Navigator.push(
                        context,
                        SwipeablePageRoute(
                            builder: (context) => const SelectLanguage()));
                  },
                ),
                ItemSetting(
                  path: 'assets/icons/bookmark.svg',
                  text: app.viewHistory,
                  onTap: () {
                    context.push(AppRouteConstant.viewHistory);
                  },
                ),
                ItemSetting(
                  path: 'assets/icons/trash.svg',
                  text: app.clearCache,
                  onTap: () {
                    _showMyDialog(context);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () => authCubit.logout(context, app.error),
                    child: Text(app.logout))
              ],
            );
          },
        ),
      ),
    );
  }
}

Future<void> _showMyDialog(BuildContext context) async {
  final MovieCubit movieCubit = di.get();

  final app = AppLocalizations.of(context);
  final theme = Theme.of(context).colorScheme;

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(app!.notification),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(app.areYouSureYouWantToClearTheCache),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              app.cancel,
              style: TextStyle(color: theme.tertiary),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              app.ok,
              style: TextStyle(color: theme.tertiary),
            ),
            onPressed: () async {
              movieCubit.clearCache();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
