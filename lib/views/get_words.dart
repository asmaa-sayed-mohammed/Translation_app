import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/word.dart';
import '../main.dart';

final getWords = <Word>[].obs;

class GetWords extends StatefulWidget {
  const GetWords({super.key});

  @override
  State<GetWords> createState() => _GetWordsState();
}

class _GetWordsState extends State<GetWords> {
  @override
  void initState() {
    super.initState();
    loadWords();
  }

  void loadWords() {
    getWords.value = wordBox.values.toList();
  }

  void clearAll() {
    wordBox.clear();
    getWords.clear();
    Get.snackbar(
      "Deleted",
      "All saved translations have been removed",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withOpacity(0.8),
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF324332),
        title: const Text("Saved Translations", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded, color: Colors.white),
            onPressed: clearAll,
            tooltip: "Delete All",
          ),
        ],
      ),
      body: Obx(() {
        if (getWords.isEmpty) {
          return const Center(
            child: Text(
              "No saved translations yet 🗒️",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: getWords.length,
          itemBuilder: (ctx, index) {
            final word = getWords[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                title: Text(word.word,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(word.translatedWord,
                    style: const TextStyle(fontSize: 16, color: Colors.black87)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () {
                    wordBox.deleteAt(index);
                    getWords.removeAt(index);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
