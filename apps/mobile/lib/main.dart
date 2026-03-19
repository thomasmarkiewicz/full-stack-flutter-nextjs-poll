import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/poll_bloc.dart';
import 'bloc/poll_event.dart';
import 'data/repositories/poll_repository_impl.dart';
import 'ui/poll_page.dart';

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
    return BlocProvider(
      create: (_) =>
          PollBloc(repository: PollRepositoryImpl(baseUrl: _apiBaseUrl))
            ..add(const PollsLoadRequested()),
      child: MaterialApp(
        title: 'Anketa Poll',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const PollPage(),
      ),
    );
  }
}
