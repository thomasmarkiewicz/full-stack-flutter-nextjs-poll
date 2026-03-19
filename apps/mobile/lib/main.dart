import 'package:flutter/material.dart';
import 'router.dart';

// ── Change this to your machine's LAN IP when testing on a physical device ──
const String _apiBaseUrl =
    'http://10.0.2.2:3000/api'; // Android emulator default

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Anketa Poll',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routerConfig: buildRouter(apiBaseUrl: _apiBaseUrl),
    );
  }
}
