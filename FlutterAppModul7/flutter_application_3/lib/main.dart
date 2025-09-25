import 'package:flutter/material.dart';
import 'home.dart';
import 'tujuan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigasi Antar Halaman',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HalamanHome(),
        '/tujuan': (context) => const HalamanTujuan(),
      },
    );
  }
}
