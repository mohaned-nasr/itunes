import 'package:flutter/material.dart';
import 'package:itunes/models/album_class.dart';
import 'package:itunes/providers/album_provider.dart';
import 'package:itunes/screens/home_screen.dart';
import 'package:itunes/services/api_service.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AlbumProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: const HomeScreen(),
    );
}
}
