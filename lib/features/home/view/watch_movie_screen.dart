import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:floating/floating.dart';
import 'package:gap/gap.dart';
import 'package:movie/common/domain/entities/response/movie_data.dart';
import 'package:movie/core/colors/app_colors.dart';
import 'package:movie/core/di/di.dart';
import 'package:movie/core/text_style/app_text_style.dart';
import 'package:movie/features/movie/cubit/movie_cubit.dart';
import 'package:movie/features/movie/cubit/movie_state.dart';
import 'package:video_player/video_player.dart';
import 'package:movie/core/language/l10n/app_localizations.dart';

class WatchMovieScreen extends StatefulWidget {
  const WatchMovieScreen({super.key, required this.movie});
  final Movie movie;

  @override
  State<WatchMovieScreen> createState() => _WatchMovieScreenState();
}

class _WatchMovieScreenState extends State<WatchMovieScreen> {
  final MovieCubit movieCubit = getIt.get();
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  int currentIndex = 0;
  bool _hasCalledVideoEnd = false;
  Timer? timer;

  // PiP variables
  final Floating _floating = Floating();
  bool _isPipAvailable = false;

  // iOS PiP Method Channel
  static final MethodChannel _pipChannel = MethodChannel('com.movie/pip');

  @override
  void initState() {
    super.initState();
    initData();
    _checkPipAvailability();
    if (Platform.isIOS) _setupPipCallbacks();
  }

  /// Listen for native iOS PiP events (restore / stopped)
  void _setupPipCallbacks() {
    _pipChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onPipRestore':
          // User tapped expand button on PiP window
          final args = call.arguments as Map<dynamic, dynamic>?;
          final position = args?['position'] as int? ?? 0;
          print('iOS PiP restore at position: ${position}s');
          // Seek Flutter player to PiP position and resume
          await _videoPlayerController?.seekTo(Duration(seconds: position));
          await _videoPlayerController?.play();
          if (mounted) setState(() {});
          break;
        case 'onPipStopped':
          // PiP was dismissed (swipe away / close)
          final args = call.arguments as Map<dynamic, dynamic>?;
          final position = args?['position'] as int? ?? 0;
          print('iOS PiP stopped at position: ${position}s');
          // Resume Flutter player at PiP position
          await _videoPlayerController?.seekTo(Duration(seconds: position));
          await _videoPlayerController?.play();
          if (mounted) setState(() {});
          break;
      }
    });
  }

  Future<void> initData() async {
    await movieCubit.getMovieInfo(widget.movie.slug ?? "");
    setVideoPlayerController(
      linkVideo:
          movieCubit
              .state
              .movieInfo
              ?.episodes!
              .last
              .serverData?[widget.movie.episodeCurrentlyWatching]
              .linkM3U8 ??
          '',
      index: widget.movie.episodeCurrentlyWatching,
    );
  }

  Future<void> _checkPipAvailability() async {
    if (Platform.isAndroid) {
      final status = await _floating.isPipAvailable;
      setState(() {
        _isPipAvailable = status;
      });
    } else if (Platform.isIOS) {
      try {
        final status = await _pipChannel.invokeMethod<bool>('isPipAvailable');
        setState(() {
          _isPipAvailable = status ?? false;
        });
      } catch (e) {
        print('iOS PiP check failed: $e');
        setState(() {
          _isPipAvailable = false;
        });
      }
    }
  }

  Future<void> _enablePip() async {
    if (Platform.isAndroid && _isPipAvailable) {
      final status = await _floating.enable(
        ImmediatePiP(aspectRatio: Rational.landscape()),
      );
      print('PiP enabled: $status');
    } else if (Platform.isIOS && _isPipAvailable) {
      try {
        final position = _videoPlayerController?.value.position.inSeconds ?? 0;
        // Pause Flutter player first
        await _videoPlayerController?.pause();
        await _pipChannel.invokeMethod('enablePip', {'position': position});
        print('iOS PiP enabled');
      } catch (e) {
        print('iOS PiP failed: $e');
        // Resume Flutter player if PiP failed
        _videoPlayerController?.play();
      }
    }
  }

  void _videoListener() {
    final controller = _videoPlayerController;
    if (controller == null || !controller.value.isInitialized) return;

    final position = controller.value.position;
    final duration = controller.value.duration;

    if (duration > Duration.zero &&
        !controller.value.isPlaying &&
        (duration - position).inMilliseconds.abs() < 500 &&
        !_hasCalledVideoEnd) {
      _hasCalledVideoEnd = true;
      print('🎬 Video kết thúc!');
      _onVideoEnd();
    }
  }

  Future<void> setVideoPlayerController({
    required String linkVideo,
    required int index,
    bool isStart = false,
  }) async {
    timer?.cancel();
    // Thoát fullscreen nếu đang bật
    if (_chewieController?.isFullScreen == true) {
      _chewieController?.exitFullScreen();
      await Future.delayed(const Duration(milliseconds: 500));
    }

    setState(() {
      _chewieController = null;
    });

    _hasCalledVideoEnd = false; // ← reset tại đây!
    currentIndex = index;

    _videoPlayerController?.removeListener(_videoListener);
    _videoPlayerController?.pause();
    await _videoPlayerController?.dispose();
    _chewieController?.dispose();

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(linkVideo),
    );

    await _videoPlayerController?.initialize();
    _videoPlayerController?.addListener(_videoListener);

    await _videoPlayerController?.setLooping(false);
    await _videoPlayerController?.setVolume(1.0);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      startAt: isStart ? null : widget.movie.duration,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      deviceOrientationsOnEnterFullScreen: [DeviceOrientation.landscapeRight],
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      placeholder: const Center(child: CircularProgressIndicator()),
      aspectRatio: 16 / 9,
    );

    setState(() {});

    // Pre-create PiP controller for iOS (so PiP button starts instantly)
    if (Platform.isIOS && _isPipAvailable) {
      _pipChannel
          .invokeMethod('preparePip', {'url': linkVideo})
          .catchError((e) => print('iOS preparePip failed: $e'));
    }

    timer = Timer.periodic(Duration(seconds: 10), (_) {
      final current = _videoPlayerController?.value.position;
      if (current != null) {
        print('⏱ Đang phát tại: ${current.inSeconds}s');
        movieCubit.saveMovieInformation(
          index: currentIndex,
          duration: Duration(seconds: current.inSeconds),
        );
      }
    });
  }

  void _onVideoEnd() {
    final total =
        movieCubit.state.movieInfo?.episodes?.last.serverData?.length ?? 0;

    if (currentIndex + 1 < total) {
      setVideoPlayerController(
        linkVideo:
            movieCubit
                .state
                .movieInfo
                ?.episodes!
                .last
                .serverData?[currentIndex + 1]
                .linkM3U8 ??
            '',
        index: currentIndex + 1,
        isStart: true,
      );
    } else {
      print('🚫 Đã hết tập phim, không còn video để phát tiếp.');
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    // Full cleanup iOS PiP
    if (Platform.isIOS) {
      _pipChannel.invokeMethod('disposePip').catchError((_) {});
    }
    _videoPlayerController?.removeListener(_videoListener);
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context);

    final scaffoldWidget = Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: AppColors.red5.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18.sp,
              color: AppColors.red5,
            ),
          ),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon play
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.red5, AppColors.red3],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.red5.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                size: 18.sp,
                color: Colors.white,
              ),
            ),
            Gap(10.w),
            // Title với gradient
            Flexible(
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => LinearGradient(
                  colors: [AppColors.red1, AppColors.red5],
                ).createShader(bounds),
                child: Text(
                  language!.watchAMovie,
                  style: AppTextStyles.textStyleBold18.copyWith(
                    letterSpacing: 1,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // PiP button - chỉ Android
          if (_isPipAvailable)
            IconButton(
              onPressed: _enablePip,
              icon: Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: AppColors.red5.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.picture_in_picture_alt_rounded,
                  size: 18.sp,
                  color: AppColors.red5,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<MovieCubit, MovieState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [buildVideo(), buildInfoMovie(context)],
            );
          },
        ),
      ),
    );

    // Android: Dùng PiPSwitcher
    if (Platform.isAndroid) {
      return PiPSwitcher(
        childWhenDisabled: scaffoldWidget,
        childWhenEnabled: Container(
          color: Colors.black,
          child: Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _chewieController != null
                  ? Chewie(
                      key: ValueKey(_chewieController),
                      controller: _chewieController!,
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
        ),
      );
    }

    // iOS: Trả về Scaffold thẳng
    return scaffoldWidget;
  }

  Widget buildVideo() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _chewieController != null
          ? SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Chewie(
                key: ValueKey(
                  _chewieController,
                ), // 👈 Force rebuild khi đổi controller
                controller: _chewieController!,
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildInfoMovie(BuildContext context) {
    final language = AppLocalizations.of(context);

    return BlocBuilder<MovieCubit, MovieState>(
      builder: (context, state) {
        if (state.movieInfo != null) {
          return Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Gap(10),

                      Text(
                        '${language!.movieName}: ${state.movieInfo?.movie?.name}',
                        style: AppTextStyles.textStyle18,
                      ),
                      Gap(10),

                      if ((state.movieInfo?.episodes?.last.serverData?.length ??
                              0) >
                          1)
                        GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 8,
                                childAspectRatio: 1,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                          shrinkWrap: true,
                          itemCount:
                              state
                                  .movieInfo
                                  ?.episodes
                                  ?.last
                                  .serverData
                                  ?.length ??
                              0,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setVideoPlayerController(
                                  linkVideo:
                                      state
                                          .movieInfo
                                          ?.episodes!
                                          .first
                                          .serverData?[index]
                                          .linkM3U8 ??
                                      '',
                                  index: index,
                                  isStart: true,
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: currentIndex == index
                                      ? Colors.blue
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('${index + 1}'),
                              ),
                            );
                          },
                        ),

                      Gap(10),
                      Text(
                        '${language.movieContent}: ${state.movieInfo?.movie?.content}',
                      ),
                      Gap(10),

                      Text(
                        '${language.movieDirector}: ${state.movieInfo?.movie!.director?.join(', ')}',
                      ),
                      Gap(10),

                      Text(
                        '${language.movieActor}: ${state.movieInfo?.movie!.actor?.join(', ')}',
                      ),
                      Gap(10),
                      Text(
                        '${language.category}: ${state.movieInfo?.movie!.category?.join(', ')}', // chỗ này gọi đến phương thức toString trong class Category
                      ),

                      Gap(20),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
