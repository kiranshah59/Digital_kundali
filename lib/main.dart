import 'package:flutter/material.dart';
import 'features/onboarding/pages/main_page_view.dart';

void main() {
  runApp(const DigitalKundaliApp());
}

class DigitalKundaliApp extends StatelessWidget {
  const DigitalKundaliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Kundali',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAF9F5),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Inter', color: Color(0xFF11141A)),
        ),
      ),
      home: const MainPageView(),
    );
  }
}
