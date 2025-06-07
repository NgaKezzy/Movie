import 'package:app/config/app_size.dart';
import 'package:app/feature/home/cubit/movie_cubit.dart';
import 'package:app/feature/home/models/movie_information.dart';
import 'package:app/feature/home/movie_list.dart';
import 'package:app/l10n/cubit/locale_cubit.dart';
import 'package:app/routers/router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

// ignore: must_be_immutable

// ignore: must_be_immutable
class ItemFilmHorizontally extends StatelessWidget {
  ItemFilmHorizontally({
    super.key,
    this.itemsFilm = const [],
    required this.title,
    required this.color,
  });
  List<MovieInformation> itemsFilm;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SliverToBoxAdapter(
      child: itemsFilm.isEmpty
          ? const SizedBox()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 30, bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          SwipeablePageRoute(
                              builder: (context) => MovieList(
                                    itemFilms: itemsFilm,
                                    title: title,
                                  )));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              fontSize: AppSize.size20,
                              fontWeight: FontWeight.w600),
                        ),
                        SvgPicture.asset(
                          'assets/icons/chevron-right.svg',
                          color: color,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 250, //
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 10,
                    ),

                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          context.push(
                              '${AppRouteConstant.myHomeApp}${AppRouteConstant.watchAVideo}',
                              extra: itemsFilm[index].slug);
                        },
                        child: SizedBox(
                          width: size.width * 0.4,
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: itemsFilm[index].thumb_url,
                                        imageBuilder: (context, imageProvider) => Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                      
                                      // Badge Premium
                                      if (itemsFilm[index].isPremium)
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
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
                                height: 10,
                              ),
                              Container(
                                height: 40,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  context
                                              .watch<LocaleCubit>()
                                              .state
                                              .languageCode ==
                                          'en'
                                      ? itemsFilm[index].origin_name
                                      : itemsFilm[index].name,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: 20, // Số lượng mục trong danh sách
                  ),
                ),
              ],
            ),
    );
  }
}
