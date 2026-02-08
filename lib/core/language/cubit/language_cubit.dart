import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:movie/common/data/data_source/local/local_storage.dart';
import 'package:movie/core/language/cubit/language_state.dart';


class LanguageCubit extends HydratedCubit<LanguageState> {
  LanguageCubit(this._sharedPrefs) : super(LanguageState());
  final SharedPrefs _sharedPrefs;

  void changedLanguage(String code) {
    if (code != state.languageCode) {
      emit(state.copyWith(languageCode: code));
    }
  }

    
  @override
  LanguageState? fromJson(Map<String, dynamic> json) {
 try {
      return LanguageState.fromJson(json);
    } catch (_) {
      return null;
    }
  }
  
  @override
  Map<String, dynamic>? toJson(LanguageState state) {
    try {
      return state.toJson();
    } catch (_) {
      return null;
    }
  }
}
