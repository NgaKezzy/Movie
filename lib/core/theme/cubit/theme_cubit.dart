import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:movie/common/data/data_source/local/local_storage.dart';
import 'package:movie/core/theme/cubit/theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit(this._sharedPrefs) : super(const ThemeState());
  final SharedPrefs _sharedPrefs;

  Future<void> toggedTheme() async {
    emit(state.copyWith(isDark: !state.isDark));
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    try {
      return ThemeState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    try {
      return state.toJson();
    } catch (_) {
      return null;
    }
  }
}
