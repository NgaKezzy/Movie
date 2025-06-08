import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'locale_state.g.dart';

enum LocaleStatus { init, start, loading, success, error }

List<String> newCountryNames = ['English', 'Vietnamese', 'French', 'Hindi'];
List<String> codes = ['en', 'vi', 'fr', 'hi'];
List<String> newPathCountryFlag = [
  'england_flag.png',
  'vietnam_flag.png',
  'france_flag.png',
  'india_flag.png'
];

@CopyWith()
class LocaleState extends Equatable {
  const LocaleState(
      {this.languageCodes = const [],
      this.languageCode = '',
      this.countryNames = const [],
      this.isSelectLanguage = false,
      this.pathCountryFlags = const [],
      this.status = LocaleStatus.init});
  final List<String> languageCodes;
  final String languageCode;
  final List<String> countryNames;
  final bool isSelectLanguage;
  final List<String> pathCountryFlags;
  final LocaleStatus status;

  @override
  List<Object> get props => [
        languageCodes,
        languageCode,
        countryNames,
        isSelectLanguage,
        pathCountryFlags,
        status,
      ];
}
