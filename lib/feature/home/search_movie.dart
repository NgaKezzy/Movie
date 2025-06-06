import 'package:app/component/loading_widget.dart';
import 'package:app/config/debounce.dart';
import 'package:app/config/di.dart';
import 'package:app/config/print_color.dart';
import 'package:app/feature/home/cubit/movie_cubit.dart';
import 'package:app/feature/home/cubit/movie_state.dart';
import 'package:app/feature/home/watch_a_movie.dart';
import 'package:app/feature/home/widgets/item_movie_information.dart';
import 'package:app/l10n/cubit/locale_cubit.dart';
import 'package:app/routers/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class SearchMovie extends StatefulWidget {
  const SearchMovie({super.key});

  @override
  State<SearchMovie> createState() => _SearchMovieState();
}

class _SearchMovieState extends State<SearchMovie> {
  final TextEditingController searchController = TextEditingController();
  MovieCubit movieCubit = di.get();
  bool isPlaySearch = false;
  bool isFirst = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  final Debounce debounce = Debounce();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 20),
              child: SizedBox(
                height: 35,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        cursorColor: theme.colorScheme.onPrimary,
                        autofocus: true,
                        controller: searchController,
                        // chỗ này là khi nào nhấn done mới tìm kiếm
                        onFieldSubmitted: (value) async {
                          if (searchController.text.trim().isNotEmpty) {
                            setState(() {
                              isPlaySearch = true;
                            });
                            FocusScope.of(context).unfocus();
                            await movieCubit
                                .moviesSearch(searchController.text.trim());
                            isPlaySearch = false;
                            isFirst = false;

                            setState(() {});
                          }
                        },
                        onChanged: (value) {
                          // Hàm để gọi để tìm kiếm
                          debounce.call(() async {
                            if (searchController.text.trim().isNotEmpty) {
                              setState(() {
                                isPlaySearch = true;
                              });
                              // FocusScope.of(context).unfocus();
                              await movieCubit
                                  .moviesSearch(searchController.text.trim());
                              isPlaySearch = false;
                              isFirst = false;

                              setState(() {});
                            }
                          });
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () async {
                                if (searchController.text.trim().isNotEmpty) {
                                  setState(() {
                                    isPlaySearch = true;
                                  });
                                  FocusScope.of(context).unfocus();
                                  await movieCubit.moviesSearch(
                                      searchController.text.trim());
                                  isPlaySearch = false;
                                  isFirst = false;

                                  setState(() {});
                                }
                              },
                              child: Icon(Icons.search,
                                  color: theme.colorScheme.tertiary)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          fillColor: theme.colorScheme.tertiary,
                          hintText: AppLocalizations.of(context)!.search,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              width: 1,
                              color: theme.colorScheme.tertiary,
                              style: BorderStyle.solid,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              width: 1,
                              color: theme.colorScheme.tertiary,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.cancel))
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            isFirst
                ? const Column(

                    /// sau này sẽ viết lịch sử tìm kiếm
                    )
                : BlocBuilder<MovieCubit, MovieState>(
                    builder: (context, state) {
                      if (state.moviesSearch.isEmpty) {
                        return Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: double.infinity,
                          color: Colors.grey,
                          child:
                              Text(AppLocalizations.of(context)!.movieNotFound),
                        );
                      }
                      return Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 50),
                          itemCount: state.moviesSearch.length,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();

                                  printRed(state.moviesSearch[index].slug);
                                  context.push(
                                      '${AppRouteConstant.myHomeApp}${AppRouteConstant.watchAVideo}',
                                      extra: state.moviesSearch[index].slug);
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => WatchAMovie(
                                  //             slug: state
                                  //                 .moviesSearch[index].slug)));
                                },
                                child: ItemMovieInformation(
                                  imageUrl: state.moviesSearch[index].thumb_url,
                                  name: context
                                              .watch<LocaleCubit>()
                                              .state
                                              .languageCode ==
                                          'en'
                                      ? state.moviesSearch[index].origin_name
                                      : state.moviesSearch[index].name,
                                  year:
                                      state.moviesSearch[index].year.toString(),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }
}
