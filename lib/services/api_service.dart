import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/translation.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<TranslationService?> getTranslation(
      String text, String fromLang, String toLang) async {
    final url =
        'https://api.mymemory.translated.net/get?q=$text&langpair=$fromLang|$toLang';

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        return translationServiceFromJson(json.encode(response.data));
      }
    } catch (e) {
      print("API error: $e");
    }
    return null;
  }
}
