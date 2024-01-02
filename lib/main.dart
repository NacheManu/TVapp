import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tv_app/screens/login.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV APP',
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        primaryColor: const Color.fromARGB(255, 180, 21, 9),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 199, 0, 0)),
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 180, 21, 9),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
