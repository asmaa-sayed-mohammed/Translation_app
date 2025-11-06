import 'package:hive/hive.dart';
import '../models/word.dart';

class HiveService {
  final Box<Word> wordBox;

  HiveService(this.wordBox);

  Word? getWord(String word, String fromLang, String toLang) {
    final key = '${word.toLowerCase()}_${fromLang}_${toLang}';
    return wordBox.get(key);
  }

  Future<void> saveWord(String key, Word word) async {
    await wordBox.put(key, word);
  }

  List<Word> getAllWords() => wordBox.values.toList();

  Future<void> clearAll() async => await wordBox.clear();
}
