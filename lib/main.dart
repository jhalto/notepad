import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:notepad/apl_key.dart';
import 'package:notepad/home.dart';

void main() {
  Gemini.init(
    apiKey: Gemini_Api
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home: Home(),
    );
  }
}
