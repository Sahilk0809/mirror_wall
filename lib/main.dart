import 'package:flutter/material.dart';
import 'package:mirror_wall/provider/search_engine_provider.dart';
import 'package:mirror_wall/view/search_engine/search_engine_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SearchEngineProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchEngineScreen(),
    );
  }
}