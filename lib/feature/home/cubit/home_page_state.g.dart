// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HomePageStateCWProxy {
  HomePageState isConnectNetwork(bool isConnectNetwork);

  HomePageState status(HomePageStatus status);

  HomePageState isLoadingHome(bool isLoadingHome);

  HomePageState currentIndexPage(int currentIndexPage);

  HomePageState isNotification(bool isNotification);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HomePageState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HomePageState(...).copyWith(id: 12, name: "My name")
  /// ````
  HomePageState call({
    bool isConnectNetwork,
    HomePageStatus status,
    bool isLoadingHome,
    int currentIndexPage,
    bool isNotification,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHomePageState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHomePageState.copyWith.fieldName(...)`
class _$HomePageStateCWProxyImpl implements _$HomePageStateCWProxy {
  const _$HomePageStateCWProxyImpl(this._value);

  final HomePageState _value;

  @override
  HomePageState isConnectNetwork(bool isConnectNetwork) =>
      this(isConnectNetwork: isConnectNetwork);

  @override
  HomePageState status(HomePageStatus status) => this(status: status);

  @override
  HomePageState isLoadingHome(bool isLoadingHome) =>
      this(isLoadingHome: isLoadingHome);

  @override
  HomePageState currentIndexPage(int currentIndexPage) =>
      this(currentIndexPage: currentIndexPage);

  @override
  HomePageState isNotification(bool isNotification) =>
      this(isNotification: isNotification);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HomePageState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HomePageState(...).copyWith(id: 12, name: "My name")
  /// ````
  HomePageState call({
    Object? isConnectNetwork = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? isLoadingHome = const $CopyWithPlaceholder(),
    Object? currentIndexPage = const $CopyWithPlaceholder(),
    Object? isNotification = const $CopyWithPlaceholder(),
  }) {
    return HomePageState(
      isConnectNetwork: isConnectNetwork == const $CopyWithPlaceholder()
          ? _value.isConnectNetwork
          // ignore: cast_nullable_to_non_nullable
          : isConnectNetwork as bool,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as HomePageStatus,
      isLoadingHome: isLoadingHome == const $CopyWithPlaceholder()
          ? _value.isLoadingHome
          // ignore: cast_nullable_to_non_nullable
          : isLoadingHome as bool,
      currentIndexPage: currentIndexPage == const $CopyWithPlaceholder()
          ? _value.currentIndexPage
          // ignore: cast_nullable_to_non_nullable
          : currentIndexPage as int,
      isNotification: isNotification == const $CopyWithPlaceholder()
          ? _value.isNotification
          // ignore: cast_nullable_to_non_nullable
          : isNotification as bool,
    );
  }
}

extension $HomePageStateCopyWith on HomePageState {
  /// Returns a callable class that can be used as follows: `instanceOfHomePageState.copyWith(...)` or like so:`instanceOfHomePageState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HomePageStateCWProxy get copyWith => _$HomePageStateCWProxyImpl(this);
}
