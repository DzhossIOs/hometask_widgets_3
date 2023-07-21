import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/action_button.dart';
import 'pages/fight_page.dart';
import 'pages/main_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.pressStart2pTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: MainPage(),
    );
  }
}
