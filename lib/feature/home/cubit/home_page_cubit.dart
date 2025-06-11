import 'package:app/config/key_app.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../../../config/print_color.dart';
import 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(const HomePageState()) {
    initIsSelectedNotifications();
    _initNetworkListener();
  }

  StreamSubscription<List<ConnectivityResult>>? _networkSubscription;

  void _initNetworkListener() {
    // kiểm tra xem có kết nối mạng hay ko
    _networkSubscription =
        Connectivity().onConnectivityChanged.listen((results) {
      final result = results.first;
      if (result == ConnectivityResult.none) {
        printRed('Network disconnected');
        emit(state.copyWith(
            isConnectNetwork: false, status: HomePageStatus.success));
      } else {
        printRed('Network connected');
        emit(state.copyWith(
            isConnectNetwork: true, status: HomePageStatus.success));
      }
    });
  }

  @override
  Future<void> close() {
    _networkSubscription?.cancel();
    return super.close();
  }

  Future<void> checkNetwork() async {
    emit(state.copyWith(status: HomePageStatus.init));
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.first == ConnectivityResult.none) {
      printRed('No connect network');
      emit(state.copyWith(
          isConnectNetwork: false, status: HomePageStatus.success));
    } else {
      printRed('Connect network');
      emit(state.copyWith(
          isConnectNetwork: true, status: HomePageStatus.success));
    }
  }

  Future<void> loadingHomeIsFalse() async {
    emit(state.copyWith(status: HomePageStatus.init));

    emit(state.copyWith(isLoadingHome: false, status: HomePageStatus.success));
  }

  Future<void> notificationsEnabled() async {
    emit(state.copyWith(status: HomePageStatus.loading));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(KeyApp.IS_SELECTED_NOTIFICATION, true);
    emit(state.copyWith(isNotification: true));
  }

  Future<void> initIsSelectedNotifications() async {
    emit(state.copyWith(status: HomePageStatus.loading));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSelected = prefs.getBool(KeyApp.IS_SELECTED_NOTIFICATION) ?? false;
    emit(state.copyWith(isNotification: isSelected));
  }

  void setPageIndex(int indexPage) {
    emit(state.copyWith(currentIndexPage: indexPage));
  }
}
