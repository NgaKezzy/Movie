import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:movie/common/widgets/empty/empty_widget.dart';
import 'package:movie/common/widgets/loading/loading_component.dart';
import 'package:movie/core/colors/app_colors.dart';
import 'package:movie/core/di/di.dart';
import 'package:movie/core/gen/assets.gen.dart';
import 'package:movie/core/text_style/app_text_style.dart';
import 'package:movie/features/movie/cubit/movie_cubit.dart';
import 'package:movie/features/movie/cubit/movie_state.dart';
import 'package:movie/core/language/l10n/app_localizations.dart';

class MovieHistoryPage extends StatelessWidget {
  const MovieHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context);

    final MovieCubit movieCubit = getIt.get();
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
              // Text lịch sử với gradient
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => LinearGradient(
                  colors: [AppColors.red1, AppColors.red5],
                ).createShader(bounds),
                child: Text(
                  language?.history ?? 'History',
                  style: AppTextStyles.textStyleBold20.copyWith(
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: BlocBuilder<MovieCubit, MovieState>(
            builder: (context, state) {
              if (state.movieHistory.isNotEmpty) {
                return GridView.builder(
                  padding: EdgeInsets.only(bottom: 90),
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
                          movie: state.movieHistory[index],
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
                                  imageUrl:
                                      state.movieHistory[index].fullThumbUrl,
                                  errorWidget: (context, url, error) =>
                                      Center(child: Icon(Icons.warning)),
                                  placeholder: (context, url) => Container(
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
                                state.movieHistory[index].name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },

                  itemCount: state.movieHistory.length,
                );
              } else {
                return Center(
                  child: EmptyWidget(content: language!.noDataAvailable),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
