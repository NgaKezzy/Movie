import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie/common/widgets/loading/loading_component.dart';
import 'package:movie/core/di/di.dart';
import 'package:movie/features/home/models/param_movie_list_page.dart';
import 'package:movie/features/movie/cubit/movie_cubit.dart';

class MovieListPage extends StatelessWidget {
  MovieListPage({super.key, required this.param});
  final ParamMovieListPage param;
  final MovieCubit movieCubit = getIt.get();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(param.title)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1.43,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                movieCubit.playMovie(
                  movie: param.movies[index],
                  context: context,
                );
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: param.movies[index].fullThumbUrl,
                          errorWidget:
                              (context, url, error) =>
                                  Center(child: Icon(Icons.warning)),
                          placeholder:
                              (context, url) => Container(
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                child: LoadingComponent(),
                              ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      // width: ScreenUtil().screenWidth / 2 - 11,
                      child: Text(
                        param.movies[index].name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },

          itemCount: param.movies.length,
        ),
      ),
    );
  }
}
