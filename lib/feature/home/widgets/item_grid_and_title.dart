import 'package:app/component/loading_widget.dart';
import 'package:app/config/app_size.dart';
import 'package:app/config/di.dart';
import 'package:app/feature/home/cubit/movie_cubit.dart';
import 'package:app/feature/home/models/movie_information.dart';
import 'package:app/feature/home/movie_list.dart';
import 'package:app/feature/login/cubit/auth_cubit.dart';
import 'package:app/l10n/cubit/locale_cubit.dart';
import 'package:app/routers/router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

// ignore: must_be_immutable
class ItemGridAndTitle extends StatefulWidget {
  ItemGridAndTitle(
      {super.key,
      required this.itemFilms,
      required this.title,
      this.isScroll = true});
  List<MovieInformation> itemFilms;
  final String title;
  final bool isScroll;

  @override
  State<ItemGridAndTitle> createState() => _ItemGridAndTitleState();
}

class _ItemGridAndTitleState extends State<ItemGridAndTitle> {
  bool isDetail = false;
  final AuthCubit authCubit = di.get();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final app = AppLocalizations.of(context);

    return widget.itemFilms.isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: GridView.builder(
              physics: widget.isScroll ? null : NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    3, // nếu muốn hiển thị số lượng phim theo hàng ngang
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.6,
              ),
              itemCount:
                  widget.itemFilms.length, // Số lượng items trong grid view
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (widget.itemFilms[index].isPremium == true) {
                      if (authCubit.state.userInfo!.isPremium == true) {
                        context.push(
                            '${AppRouteConstant.myHomeApp}${AppRouteConstant.watchAVideo}',
                            extra: widget.itemFilms[index].slug);
                      } else {
                        // Thay thế SnackBar bằng ShowDialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  AppLocalizations.of(context)!.notification),
                              content: Text(AppLocalizations.of(context)!
                                  .youNeedToRegister),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel,
                                    style: TextStyle(
                                        color: theme.colorScheme.tertiary),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    AppLocalizations.of(context)!.register,
                                    style: TextStyle(
                                        color: theme.colorScheme.tertiary),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    // Chuyển đến trang đăng ký Premium
                                    context.push(AppRouteConstant.premium);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      context.push(
                          '${AppRouteConstant.myHomeApp}${AppRouteConstant.watchAVideo}',
                          extra: widget.itemFilms[index].slug);
                    }
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: widget.itemFilms[index].thumb_url,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Center(
                                  child: LoadingWidget(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.warning),
                              ),

                              // Thêm print để debug
                              Builder(builder: (context) {
                                print(
                                    "Film ${widget.itemFilms[index].name} isPremium: ${widget.itemFilms[index].isPremium}");
                                return const SizedBox();
                              }),

                              // Badge Premium - đảm bảo điều kiện đúng
                              if (widget.itemFilms[index].isPremium ==
                                  true) // Thêm == true để chắc chắn
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Premium',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          context.watch<LocaleCubit>().state.languageCode !=
                                  'vi'
                              ? widget.itemFilms[index].origin_name
                              : widget.itemFilms[index].name,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
  }
}
