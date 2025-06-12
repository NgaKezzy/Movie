import 'package:app/component/loading_widget.dart';
import 'package:app/config/app_size.dart';
import 'package:app/config/print_color.dart';
import 'package:app/feature/home/cubit/movie_cubit.dart';
import 'package:app/feature/home/models/data_film.dart';
import 'package:app/feature/home/models/movie_category.dart';
import 'package:app/feature/home/models/movie_episodes.dart';
import 'package:app/l10n/cubit/locale_cubit.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key,
    required this.url,
    required this.dataFilm,
    // required this.movieInformation
  });
  final String url;
  final DataFilm? dataFilm;
  // MovieInformation? movieInformation;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late FlickManager flickManager;
  bool isHidden = false;
  bool isCheckHidden = true;
  List<String> items = [];
  List<String> beginningOfContent = [];
  String summaryContent = '';

  void splitContent() {
    // làm chức năng chia nhỏ content để hiện 1 phần
    setState(() {
      items = widget.dataFilm!.movie.content.split(' ');
      if (items.length >= 50) {
        isCheckHidden = false;
        isHidden = true;
        for (var i = 0; i < 35; i++) {
          beginningOfContent.add(items[i]);
        }
        summaryContent = beginningOfContent.join(' ');
        summaryContent = '$summaryContent ...';
        printYellow(summaryContent);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    splitContent();

    flickManager = FlickManager(
      autoPlay: true,
      autoInitialize: true,
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
      ),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LocaleCubit localeCubit = context.watch<LocaleCubit>();
    final double height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final MovieCubit movieCubit = context.read<MovieCubit>();
    final app = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height * 0.3,
          child: FlickVideoPlayer(
            wakelockEnabled: true,
            flickManager: flickManager,
            flickVideoWithControls: FlickVideoWithControls(
              aspectRatioWhenLoading: 16 / 9,
              videoFit: BoxFit.fill,
              controls: FlickPortraitControls(
                iconSize: 40,
                progressBarSettings: FlickProgressBarSettings(
                  playedColor: Colors.blue,
                ),
              ),
              playerLoadingFallback: const LoadingWidget(),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.film,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppSize.size16),
                    ),
                    GestureDetector(
                      onTap: () async {
                        // Chỉ cần gọi setHeart(), không cần gọi thêm các hàm khác
                        await movieCubit.setHeart();
                      },
                      child: Icon(
                        Icons.favorite, // icon trái tim thêm phim yêu thích
                        size: AppSize.size35,
                        color: context
                                .watch<MovieCubit>()
                                .state
                                .dataFilm!
                                .movie
                                .isFavorite
                            ? theme.colorScheme
                                .onPrimary // chuyển màu xanh thì Colors.blue hoặc Colors.green
                            : theme.colorScheme.tertiary,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    localeCubit.state.languageCode == 'vi'
                        ? widget.dataFilm!.movie.name
                        : widget.dataFilm!.movie.origin_name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                widget.dataFilm!.episodes[0].server_data.length == 1
                    ? const SizedBox()
                    : EpisodeNumberOfTheMovie(
                        flickManager: flickManager,
                        items: widget.dataFilm!.episodes,
                      ),
                const SizedBox(
                  height: 10,
                ),
                TitleAndContent(
                    title: AppLocalizations.of(context)!.content,
                    content: isHidden
                        ? summaryContent
                        : widget.dataFilm!.movie.content),
                const SizedBox(
                  height: 5,
                ),
                isCheckHidden
                    ? const SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isHidden = !isHidden;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                isHidden ? app!.seeMore : app!.hideLess,
                                style: TextStyle(
                                    color: theme.colorScheme.onPrimary,
                                    fontSize: AppSize.size11),
                              ),
                            ),
                          )
                        ],
                      ),
                const SizedBox(
                  height: 10,
                ),
                ContentActor(items: widget.dataFilm?.movie.actor ?? []),
                const SizedBox(
                  height: 10,
                ),
                ContentCategory(items: widget.dataFilm!.movie.category),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EpisodeNumberOfTheMovie extends StatefulWidget {
  const EpisodeNumberOfTheMovie(
      {super.key, required this.items, required this.flickManager});

  final List<MovieEpisodes> items;
  final FlickManager flickManager;

  @override
  State<EpisodeNumberOfTheMovie> createState() =>
      _EpisodeNumberOfTheMovieState();
}

class _EpisodeNumberOfTheMovieState extends State<EpisodeNumberOfTheMovie> {
  int indexSelected = 0;

  void playNewVideo(FlickManager flickManager, String url) {
    setState(() {
      flickManager
          .handleChangeVideo(VideoPlayerController.networkUrl(Uri.parse(url)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.episode,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: AppSize.size16),
        ),
        const SizedBox(
          height: 10,
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.items[0].server_data.length,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              crossAxisSpacing: 10,
              childAspectRatio: 0.8,
              mainAxisSpacing: 10),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              if (indexSelected != index) {
                setState(() {
                  indexSelected = index;
                  print(indexSelected);
                });
                playNewVideo(widget.flickManager,
                    widget.items[0].server_data[index].link_m3u8);
              }
            },
            child: Container(
              alignment: Alignment.center,
              width: 35,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: indexSelected == index ? Colors.pink : Colors.grey,
              ),
              child: Text('${index + 1}'),
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: camel_case_types
class ContentActor extends StatelessWidget {
  const ContentActor({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.actor,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: AppSize.size16),
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 8.0, // Khoảng cách giữa các widget con
          runSpacing: 8.0, // Khoảng cách giữa các dòng
          alignment: WrapAlignment.center, // Căn giữa theo chiều ngang
          children: List.generate(
              items.length,
              (index) => Container(
                  alignment: Alignment.center,
                  width: handleWidthActor(items, context),
                  child: Text(items[index]))),
        )
      ],
    );
  }
}

// ignore: camel_case_types
class ContentCategory extends StatelessWidget {
  const ContentCategory({super.key, required this.items});

  final List<MovieCategory> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.category,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: AppSize.size16),
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 8.0, // Khoảng cách giữa các widget con
          runSpacing: 8.0, // Khoảng cách giữa các dòng
          alignment: WrapAlignment.center, // Căn giữa theo chiều ngang
          children: List.generate(
              items.length,
              (index) => Container(
                  alignment: Alignment.center,
                  width: handleWidthCategory(items, context),
                  child: Text(items[index].name))),
        )
      ],
    );
  }
}

class TitleAndContent extends StatelessWidget {
  const TitleAndContent({super.key, this.title = '', this.content = ''});
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: AppSize.size16),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            textAlign: TextAlign.justify,
            content,
          ),
        ],
      ),
    );
  }
}

double handleWidthCategory(List items, BuildContext context) {
  double width = 0;
  if (items.length == 1) {
    width = MediaQuery.of(context).size.width - 20;
  } else if (items.length == 2) {
    width = (MediaQuery.of(context).size.width - 20) * 0.45;
  } else {
    width = (MediaQuery.of(context).size.width - 20) * 0.3;
  }
  return width;
}

double handleWidthActor(List items, BuildContext context) {
  double width = 0;
  if (items.length == 1) {
    width = MediaQuery.of(context).size.width - 0.95;
  } else {
    width = (MediaQuery.of(context).size.width - 20) * 0.45;
  }
  return width;
}
