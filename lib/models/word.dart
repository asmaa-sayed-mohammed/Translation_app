import 'package:hive/hive.dart';

part 'word.g.dart';

@HiveType(typeId: 1)
class Word {
  @HiveField(1)
  final String word;

  @HiveField(2)
  final String translatedWord;

  @HiveField(3)
  final List<String> matches;

  Word({
    required this.word,
    required this.translatedWord,
    required this.matches,
  });
}
