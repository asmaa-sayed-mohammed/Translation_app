import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:untitled3/views/splash_screen.dart';
import 'models/word.dart';
import 'views/translation_page.dart';

late Box<Word> wordBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(WordAdapter());
  wordBox = await Hive.openBox<Word>('words');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Translator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: const Color(0xFF324332)),
      home: const SplashScreen(),
    );
  }
}
