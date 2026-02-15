import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:movie/common/domain/entities/response/movie_data.dart';
import 'package:movie/common/widgets/text_field/default_textfield.dart';
import 'package:movie/core/colors/app_colors.dart';
import 'package:movie/core/gen/assets.gen.dart';
import 'package:movie/core/language/l10n/app_localizations.dart';
import 'package:movie/core/di/di.dart';
import 'package:movie/core/text_style/app_text_style.dart';
import 'package:movie/features/movie/cubit/movie_cubit.dart';
import 'package:movie/features/movie/cubit/movie_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final MovieCubit movieCubit = getIt.get();
  Timer? _debounce;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    movieCubit.clearSearchMovie();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Row(
            children: [
              // Logo SVG hình tròn
              SvgPicture.asset(Assets.svg.appLogo, height: 28.h, width: 28.w),
              Gap(12.w),
              // Text tìm kiếm với gradient
              Expanded(
                child: AppTextField(
                  heightContainer: 40,
                  controller: _searchController,
                  onChanged: (p0) {
                    if (_debounce?.isActive ?? false) {
                      _debounce!.cancel();
                    }
                    _debounce = Timer(const Duration(milliseconds: 400), () {
                      movieCubit.getMovieSearch(_searchController.text.trim());
                    });
                  },
                  onTapOutSide: () {
                    FocusScope.of(context).unfocus();
                  },
                  isError: false,
                  hintText: language?.search,
                  maxLines: 1,
                  isShowCounter: true,
                  prefixIcon: Icon(Icons.search, color: AppColors.red5),
                ),
              ),
              Gap(16.w),
            ],
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Search field riêng biệt

            // Danh sách kết quả
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: BlocBuilder<MovieCubit, MovieState>(
                  builder: (context, state) {
                    final movieSearchList = state.movieSearchList ?? [];
                    if (movieSearchList.isEmpty) {
                      if (_searchController.text.trim().isEmpty) {
                        return SizedBox();
                      }
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 64.sp,
                              color: AppColors.red5.withOpacity(0.5),
                            ),
                            Gap(16.h),
                            Text(
                              language?.searchNotFound ??
                                  'Không tìm thấy phim nào',
                              style: AppTextStyles.textStyle14.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        return _buildMovie(movieSearchList[index]);
                      },
                      separatorBuilder: (context, index) => Gap(10),
                      itemCount: movieSearchList.length,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovie(Movie? movie) {
    return GestureDetector(
      onTap: () {
        if (movie != null && movie.slug != null && movie.slug!.isNotEmpty) {
          movieCubit.playMovie(movie: movie, context: context);
        }
      },
      child: Container(
        height: 100,

        width: ScreenUtil().screenWidth,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 120,
                height: 80,

                child: CachedNetworkImage(
                  imageUrl: 'https://phimimg.com/${movie?.thumbUrl}',
                  errorWidget: (context, url, error) => Icon(Icons.warning),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Gap(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: ScreenUtil().screenWidth - 166.sp,
                  child: Text(
                    movie?.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.textStyle14.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().screenWidth - 166.sp,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(movie?.time ?? '', style: AppTextStyles.textStyle12),
                      Text(
                        movie?.year.toString() ?? '',
                        style: AppTextStyles.textStyle12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
