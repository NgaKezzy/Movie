import 'package:app/config/debounce.dart';
import 'package:app/config/key_app.dart';
import 'package:app/config/print_color.dart';
import 'package:app/feature/home/cubit/movie_state.dart';
import 'package:app/feature/home/models/data_film.dart';
import 'package:app/feature/home/models/movie_details.dart';
import 'package:app/feature/home/models/movie_information.dart';
import 'package:app/feature/home/network/fetch_api_movie.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:translator/translator.dart';
import 'dart:math';

class MovieCubit extends Cubit<MovieState> {
  MovieCubit() : super(const MovieState()) {
    getMovieDataTheLocalStorage();
    getViewHistoryTheLocalStorage();
  }

  final translator = GoogleTranslator();

  Future<void> getMovie() async {
    // hàm này để lấy thông tin các bộ phim mới nhất
    emit(state.copyWith(status: MovieStatus.loading));
    List<MovieInformation> newMovies = [];

    final random = Random();

    final data = await FetchApiMovie.getMovies();

    List items = data['items'];
    for (var i = 0; i < items.length; i++) {
      final MovieInformation item;
      item = MovieInformation.fromJson(items[i]);

      // Random isPremium với tỷ lệ 20%
      item.isPremium = random.nextDouble() < 0.2;

      newMovies.add(item);
    }
    if (state.favoriteMovies.isNotEmpty && newMovies.isNotEmpty) {
      for (int i = 0; i < newMovies.length; i++) {
        for (int j = 0; j < state.favoriteMovies.length; j++) {
          if (newMovies[i].slug == state.favoriteMovies[j]!.slug) {
            newMovies[i].isFavorite = true;
          }
        }
      }
    }
    emit(state.copyWith(
      movies: newMovies,
      status: MovieStatus.success,
    ));
  }

  Future<void> getMovieDetails(String slug, String languageCode) async {
    // lấy thông tin chi tiết của 1 bộ phim
    DataFilm? newDataFilm;
    Box<MovieDetails> favoriteMovieBox = Hive.box(KeyApp.FAVORITE_MOVIE_BOX);
    emit(state.copyWith(status: MovieStatus.loading, dataFilm: newDataFilm));

    try {
      final data = await FetchApiMovie.getMovieDetails(slug);
      if (data['status'] == false) {
        emit(state.copyWith(status: MovieStatus.error, dataFilm: null));
        return;
      }

      newDataFilm = DataFilm.fromJson(data);
      if (languageCode == 'en') {
        // nếu là tiếng anh thì dịch nội dung phim
        newDataFilm.movie.content = await translate(newDataFilm.movie.content);

        for (var i = 0; i < newDataFilm.movie.actor.length; i++) {
          newDataFilm.movie.actor[i] =
              await translate(newDataFilm.movie.actor[i]);
        }

        for (var i = 0; i < newDataFilm.movie.category.length; i++) {
          newDataFilm.movie.category[i].name =
              await translate(newDataFilm.movie.category[i].name);
        }
      }
      
      // Kiểm tra xem phim có trong danh sách yêu thích không
      newDataFilm.movie.isFavorite = false; // Mặc định là false
      for (var movieDetails in favoriteMovieBox.values) {
        if (movieDetails.slug == newDataFilm.movie.slug) {
          newDataFilm.movie.isFavorite = true;
          printGreen("Movie ${newDataFilm.movie.name} is in favorites");
          break;
        }
      }
    } catch (e) {
      printRed("Error in getMovieDetails: $e");
      emit(state.copyWith(status: MovieStatus.error, dataFilm: null));
      return;
    }
    
    emit(state.copyWith(dataFilm: newDataFilm, status: MovieStatus.success));
  }

  Future<String> translate(String content) async {
    // hàm để dịch sang tiếng anh
    String newContent = '';
    await translator.translate(content, to: 'en').then((value) => {
          newContent = value.toString(),
        });
    return newContent;
  }

  Future<void> getAListOfIndividualMovies() async {
    // lấy danh sách các bộ phim 1 tập
    emit(state.copyWith(status: MovieStatus.loading));
    List<MovieInformation> newSingleMovie = [];
    final random = Random();

    final data = await FetchApiMovie.getAListOfIndividualMovies();

    List items = data['data']['items'];
    for (var i = 0; i < items.length; i++) {
      final MovieInformation item;
      item = MovieInformation.fromJson(items[i]);
      item.poster_url = 'https://img.phimapi.com/${item.poster_url}';
      item.thumb_url = 'https://img.phimapi.com/${item.thumb_url}';
      // Random isPremium với tỷ lệ 20%
      item.isPremium = random.nextDouble() < 0.2;

      newSingleMovie.add(item);
    }
    if (state.favoriteMovies.isNotEmpty && newSingleMovie.isNotEmpty) {
      for (int i = 0; i < newSingleMovie.length; i++) {
        for (int j = 0; j < state.favoriteMovies.length; j++) {
          if (newSingleMovie[i].slug == state.favoriteMovies[j]!.slug) {
            newSingleMovie[i].isFavorite = true;
          }
        }
      }
    }
    emit(state.copyWith(
      singleMovies: newSingleMovie,
      status: MovieStatus.success,
    ));
  }

  Future<void> getTheListOfMoviesAndSeries() async {
    // lấy danh sách phim nhiều tập
    emit(state.copyWith(status: MovieStatus.loading));
    List<MovieInformation> newSeriesMovies = [];
    final Random random = Random();

    final data = await FetchApiMovie.getTheListOfMoviesAndSeries();

    List items = data['data']['items'];
    for (var i = 0; i < items.length; i++) {
      final MovieInformation item;
      item = MovieInformation.fromJson(items[i]);
      item.poster_url = 'https://img.phimapi.com/${item.poster_url}';
      item.thumb_url = 'https://img.phimapi.com/${item.thumb_url}';
      // Random isPremium với tỷ lệ 20%
      item.isPremium = random.nextDouble() < 0.2;
      newSeriesMovies.add(item);
    }
    if (state.favoriteMovies.isNotEmpty && newSeriesMovies.isNotEmpty) {
      for (int i = 0; i < newSeriesMovies.length; i++) {
        for (int j = 0; j < state.favoriteMovies.length; j++) {
          if (newSeriesMovies[i].slug == state.favoriteMovies[j]!.slug) {
            newSeriesMovies[i].isFavorite = true;
          }
        }
      }
    }
    emit(state.copyWith(
      seriesMovies: newSeriesMovies,
      status: MovieStatus.success,
    ));
  }

  Future<void> getTheListOfCartoons() async {
    // lấy danh sách phim hoạt hình
    emit(state.copyWith(status: MovieStatus.loading));
    List<MovieInformation> newCartoons = [];
    final Random random = Random();

    final data = await FetchApiMovie.getTheListOfCartoons();
    List items = data['data']['items'];
    for (var i = 0; i < items.length; i++) {
      final MovieInformation item;
      item = MovieInformation.fromJson(items[i]);
      item.poster_url = 'https://img.phimapi.com/${item.poster_url}';
      item.thumb_url = 'https://img.phimapi.com/${item.thumb_url}';
      // Random isPremium với tỷ lệ 20%
      item.isPremium = random.nextDouble() < 0.2;
      newCartoons.add(item);
    }

    if (state.favoriteMovies.isNotEmpty && newCartoons.isNotEmpty) {
      for (int i = 0; i < newCartoons.length; i++) {
        for (int j = 0; j < state.favoriteMovies.length; j++) {
          if (newCartoons[i].slug == state.favoriteMovies[j]!.slug) {
            newCartoons[i].isFavorite = true;
          }
        }
      }
    }
    emit(state.copyWith(
      cartoon: newCartoons,
      status: MovieStatus.success,
    ));
  }

  Future<void> moviesSearch(String keyWord) async {
    // tìm kiếm phim theo tên
    emit(state.copyWith(status: MovieStatus.loading));
    List<MovieInformation> newMoviesSearch = [];
    try {
      final data = await FetchApiMovie.movieSearch(keyWord);
      List items = data['data']['items'];
      for (var i = 0; i < items.length; i++) {
        final MovieInformation item;
        item = MovieInformation.fromJson(items[i]);
        item.poster_url = 'https://img.phimapi.com/${item.poster_url}';
        item.thumb_url = 'https://img.phimapi.com/${item.thumb_url}';
        newMoviesSearch.add(item);
      }
      emit(state.copyWith(
        moviesSearch: newMoviesSearch,
        status: MovieStatus.success,
      ));
    } catch (e) {
      printRed(e.toString());
    }
  }

  Future<void> getMovieDataTheLocalStorage() async {
    // hàm để lấy các bộ phim yêu thích dưới bộ nhớ máy khi khởi động
    emit(state.copyWith(status: MovieStatus.loading));
    List<MovieDetails?> itemFilms = [];

    Box<MovieDetails> favoriteMovieBox = Hive.box(KeyApp.FAVORITE_MOVIE_BOX);
    printGreen("Loading favorites from storage. Total: ${favoriteMovieBox.length}");

    if (favoriteMovieBox.isEmpty) {
      emit(state.copyWith(favoriteMovies: []));
    } else {
      for (int i = 0; i < favoriteMovieBox.length; i++) {
        MovieDetails? movie = favoriteMovieBox.getAt(i);
        if (movie != null) {
          itemFilms.add(movie);
          printGreen("Loaded favorite: ${movie.name}");
        }
      }
      emit(state.copyWith(favoriteMovies: itemFilms));
    }
  }

  Future<void> addMoviesToFavoritesList({
    required MovieDetails? itemFilm,
  }) async {
    emit(state.copyWith(status: MovieStatus.loading));
    
    // Kiểm tra xem itemFilm có null không
    if (itemFilm == null) {
      printRed("Error: Trying to add null movie to favorites");
      emit(state.copyWith(status: MovieStatus.error));
      return;
    }
    
    Box<MovieDetails> favoriteMovieBox = Hive.box(KeyApp.FAVORITE_MOVIE_BOX);
    
    // Không xóa toàn bộ box, chỉ thêm phim mới vào
    // favoriteMovieBox.clear(); - Dòng này gây ra vấn đề
    
    List<MovieDetails?> newFavoriteMovies = [itemFilm, ...state.favoriteMovies];
    
    // Thêm phim mới vào box
    await favoriteMovieBox.add(itemFilm);
    
    // In ra thông tin để debug
    printGreen("Added movie to favorites: ${itemFilm.name}");
    printGreen("Total favorites: ${favoriteMovieBox.length}");
    
    emit(state.copyWith(
      favoriteMovies: newFavoriteMovies, 
      status: MovieStatus.success
    ));
  }

  Future<void> removeMoviesToFavoritesList({
    required MovieDetails? itemFilm,
  }) async {
    if (itemFilm == null) {
      printRed("Error: Trying to remove null movie from favorites");
      return;
    }
    
    emit(state.copyWith(status: MovieStatus.loading));
    
    // Tạo danh sách mới không bao gồm phim cần xóa
    List<MovieDetails?> updatedFavorites = [];
    for (var movie in state.favoriteMovies) {
      if (movie != null && movie.slug != itemFilm.slug) {
        updatedFavorites.add(movie);
      }
    }
    
    // Cập nhật state
    emit(state.copyWith(favoriteMovies: updatedFavorites));
    
    // Cập nhật Hive box
    Box<MovieDetails> favoriteMovieBox = Hive.box(KeyApp.FAVORITE_MOVIE_BOX);
    favoriteMovieBox.clear();
    
    for (var movie in updatedFavorites) {
      if (movie != null) {
        await favoriteMovieBox.add(movie);
      }
    }
    
    printGreen("Removed movie from favorites: ${itemFilm.name}");
    printGreen("Total favorites after removal: ${favoriteMovieBox.length}");
    
    emit(state.copyWith(status: MovieStatus.success));
  }

  Future<void> setHeart() async {
    emit(state.copyWith(status: MovieStatus.star));

    DataFilm? newDataFilm = state.dataFilm;
    if (newDataFilm == null || newDataFilm.movie == null) {
      printRed("Error: DataFilm or movie is null in setHeart");
      emit(state.copyWith(status: MovieStatus.error));
      return;
    }
    
    // Đảo ngược trạng thái yêu thích
    bool newFavoriteState = !newDataFilm.movie.isFavorite;
    newDataFilm.movie.isFavorite = newFavoriteState;
    
    // Cập nhật trong state
    emit(state.copyWith(dataFilm: newDataFilm, status: MovieStatus.success));
    
    // Lưu thay đổi vào Hive
    if (newFavoriteState) {
      // Nếu yêu thích, thêm vào danh sách
      await addMoviesToFavoritesList(itemFilm: newDataFilm.movie);
    } else {
      // Nếu bỏ yêu thích, xóa khỏi danh sách
      await removeMoviesToFavoritesList(itemFilm: newDataFilm.movie);
    }
    
    printGreen("Heart set to: $newFavoriteState for movie: ${newDataFilm.movie.name}");
  }

  Future<void> addToWatchHistory({required String slug}) async {
    // thêm bộ phim vào lịch sử xem và lưu xuống bộ nhớ máy
    MovieDetails? itemFilm = state.dataFilm?.movie;
    itemFilm?.slug = slug;
    Box<MovieDetails> viewHistoryBox = Hive.box(KeyApp.VIEW_HISTORY_BOX);

    List<MovieDetails?> newViewHistory = [];
    if (state.viewHistory.isEmpty) {
      /// nếu mảng rỗng thêm luôn phim vào
      newViewHistory.add(itemFilm);
      await viewHistoryBox.add(itemFilm!);
      printRed(viewHistoryBox.length.toString());
      emit(state.copyWith(
          viewHistory: newViewHistory, status: MovieStatus.success));
    } else {
      // nếu mảng có chứa phần từ thì
      viewHistoryBox.clear();
      //  kiểm tra mảng có tồn tại phần tử đó chưa
      bool isContains = false;
      int index = -1;

      for (int i = 0; i < state.viewHistory.length; i++) {
        if (itemFilm!.slug == state.viewHistory[i]!.slug) {
          isContains = true;
          index = i;
        }
      }

      if (isContains) {
        // xóa phim ở vị trí cũ đi thay phim vào vị trí đầu tiên
        List<MovieDetails?> items = state.viewHistory;
        items.removeAt(index);
        newViewHistory = [itemFilm, ...items];
        for (var element in newViewHistory) {
          await viewHistoryBox.add(element!);
        }

        emit(state.copyWith(
            viewHistory: newViewHistory, status: MovieStatus.success));
      } else {
        if (state.viewHistory.length == 20) {
          /// nếu 20 phần tử thì xóa phần tử cuối rồi thêm phim mới xem vào đầu tiên

          List<MovieDetails?> items = [...state.viewHistory];
          items.removeLast();
          newViewHistory = [itemFilm, ...items];
          for (var element in newViewHistory) {
            await viewHistoryBox.add(element!);
          }
          emit(state.copyWith(
              viewHistory: newViewHistory, status: MovieStatus.success));
        } else {
          // nhỏ hơn 20 phần tử thì thêm vào phim vào phần tử đầu tiên của mảng

          List<MovieDetails?> items = [...state.viewHistory];
          newViewHistory = [itemFilm, ...items];
          for (var element in newViewHistory) {
            await viewHistoryBox.add(element!);
          }
          emit(state.copyWith(
              viewHistory: newViewHistory, status: MovieStatus.success));
        }
      }
    }
    emit(state.copyWith(status: MovieStatus.success));
  }

  Future<void> getViewHistoryTheLocalStorage() async {
    // lấy các phim của lịch sử xem dưới bộ nhớ máy
    emit(state.copyWith(status: MovieStatus.loading));
    Box<MovieDetails> viewHistoryBox = Hive.box(KeyApp.VIEW_HISTORY_BOX);
    printRed(viewHistoryBox.length.toString());
    List<MovieDetails?> newViewHistory = [];
    if (viewHistoryBox.length == 0) {
      emit(
        state.copyWith(
          favoriteMovies: [],
        ),
      );
    } else {
      for (int i = 0; i < viewHistoryBox.length; i++) {
        newViewHistory.add(viewHistoryBox.getAt(i));
      }
      emit(state.copyWith(viewHistory: newViewHistory));
      printCyan(state.viewHistory.length.toString());
    }
  }

  Future<void> clearCache() async {
    // xóa bộ nhớ đệm, chính là xóa bộ nhớ của lịch sử xem và phim yêu thích
    emit(state.copyWith(status: MovieStatus.loading));
    Box<MovieDetails> viewHistoryBox = Hive.box(KeyApp.VIEW_HISTORY_BOX);
    Box<MovieDetails> favoriteMovieBox = Hive.box(KeyApp.FAVORITE_MOVIE_BOX);
    viewHistoryBox.clear();
    favoriteMovieBox.clear();
    emit(state.copyWith(
        status: MovieStatus.success, favoriteMovies: [], viewHistory: []));
  }

  void debounce(Function() onChanged) {
    final Debounce debounce = Debounce(milliseconds: 10000);
    debounce.call(onChanged);
  }
}
