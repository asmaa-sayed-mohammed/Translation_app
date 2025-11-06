import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:string_similarity/string_similarity.dart';
import '../models/language.dart';
import '../models/word.dart';
import '../models/translation.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';
import '../main.dart';
import 'get_words.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final translatedWord = ''.obs;
  final fromLanguage = ''.obs;
  final toLanguage = ''.obs;
  final similarWords = <Word>[].obs;
  final matches = <String>[].obs;
  final getWords = <Word>[].obs;

  final fromLang = TextEditingController();
  final toLang = TextEditingController();
  final wordController = TextEditingController();

  final apiService = ApiService();
  late final hiveService = HiveService(wordBox);

  final List<Language> languages = [
    Language(code: 'en', name: 'English'),
    Language(code: 'ar', name: 'Arabic'),
    Language(code: 'fr', name: 'French'),
    Language(code: 'de', name: 'German'),
    Language(code: 'it', name: 'Italian'),
    Language(code: 'es', name: 'Spanish'),
    Language(code: 'pt', name: 'Portuguese'),
    Language(code: 'ru', name: 'Russian'),
    Language(code: 'zh-CN', name: 'Chinese (Simplified)'),
    Language(code: 'ja', name: 'Japanese'),
    Language(code: 'ko', name: 'Korean'),
    Language(code: 'tr', name: 'Turkish'),
    Language(code: 'nl', name: 'Dutch'),
    Language(code: 'el', name: 'Greek'),
    Language(code: 'hi', name: 'Hindi'),
  ];

  @override
  void initState() {
    super.initState();
    getWords.value = hiveService.getAllWords();
  }

  List<Word> getSimilarWords(String input) {
    input = input.toLowerCase();
    return getWords
        .where((w) => w.word.toLowerCase().similarityTo(input) >= 0.5)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF324332),
        title: const Text('Smart Translator', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🌐 Language Selection Card
              _buildCard(
                child: Column(
                  children: [
                    const Text(
                      "Select Languages",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF324332)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownMenu<Language>(
                            hintText: 'From...',
                            enableSearch: true,
                            controller: fromLang,
                            onSelected: (value) {
                              if (value != null) fromLanguage.value = value.code;
                            },
                            dropdownMenuEntries: languages
                                .map((lang) =>
                                DropdownMenuEntry(value: lang, label: lang.name))
                                .toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          //child: Icon(Icons.compare_arrows, color: Color(0xFF324332)),
                          child: IconButton(
                            onPressed: () {
                              // swap text in dropdown fields
                              final tempText = fromLang.text;
                              fromLang.text = toLang.text;
                              toLang.text = tempText;

                              // swap actual language codes
                              final tempCode = fromLanguage.value;
                              fromLanguage.value = toLanguage.value;
                              toLanguage.value = tempCode;
                              wordController.clear();
                            },
                            icon: const Icon(Icons.compare_arrows, color: Color(0xFF324332)),
                          ),

                        ),
                        Expanded(
                          child: DropdownMenu<Language>(
                            hintText: 'To...',
                            enableSearch: true,
                            controller: toLang,
                            onSelected: (value) {
                              if (value != null) toLanguage.value = value.code;
                            },
                            dropdownMenuEntries: languages
                                .map((lang) =>
                                DropdownMenuEntry(value: lang, label: lang.name))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ✏️ Input Card
              _buildCard(
                child: Column(
                  children: [
                    TextField(
                      controller: wordController,
                      decoration: InputDecoration(
                        hintText: "Enter text to translate...",
                        prefixIcon: const Icon(Icons.translate),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_circle_right_outlined),
                      label: const Text('Translate', style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF324332),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _onTranslatePressed,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 📘 Saved Words Button
              ElevatedButton.icon(
                icon: const Icon(Icons.bookmark),
                label: const Text('See My Words', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF324332),
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Get.to(() => const GetWords()),
              ),

              const SizedBox(height: 30),

              // 💬 Translation Result
              Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: translatedWord.value.isEmpty
                    ? const SizedBox.shrink()
                    : _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Translation:",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF324332)),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        translatedWord.value,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )),

              // 🧠 Similar Words
              Obx(() {
                if (similarWords.isEmpty) return const SizedBox.shrink();
                return _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Similar Words:",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF324332)),
                      ),
                      const SizedBox(height: 10),
                      for (var w in similarWords)
                        Text(
                          "• ${w.word} → ${w.translatedWord}",
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // 🌟 Helper: builds card sections
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: child,
    );
  }

  // 🔁 Translation Logic
  Future<void> _onTranslatePressed() async {
    if (fromLanguage.value.isEmpty || toLanguage.value.isEmpty) {
      Get.snackbar("Error", "Please select both languages");
      return;
    } else if (fromLanguage.value == toLanguage.value) {
      Get.snackbar("Error", "Languages must be different");
      return;
    } else if (wordController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a word to translate");
      return;
    }

    final findWord = hiveService.getWord(
      wordController.text,
      fromLanguage.value,
      toLanguage.value,
    );

    if (findWord == null) {
      final translation = await apiService.getTranslation(
        wordController.text,
        fromLanguage.value,
        toLanguage.value,
      );

      final translatedText = translation?.responseData.translatedText ?? '';
      translatedWord.value = translatedText;
      matches.value = translation?.matches.map((m) => m.translation).toList() ?? [];

      final newWord = Word(
        word: wordController.text,
        translatedWord: translatedText,
        matches: matches.toList(),
      );

      final key =
          '${wordController.text.toLowerCase()}_${fromLanguage.value}_${toLanguage.value}';
      await hiveService.saveWord(key, newWord);
      Get.snackbar('From API', 'Word added to database');
    } else {
      translatedWord.value = findWord.translatedWord;
      Get.snackbar('From Hive', 'Loaded from local database');
    }

    similarWords.value = getSimilarWords(wordController.text);
  }
}
