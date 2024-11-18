import 'dart:async';

import 'package:app_licenta/views/login_screen.dart';
import 'package:app_licenta/views/register_screen.dart';
import 'package:app_licenta/widgets/bottom_nav_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/library_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (context) => LibraryModel(),
      child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      initialRoute: '/login', // Start with Login screen
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => SignupScreen(),
        '/home': (context) => CustomBottomNavBar(),
      },
    );
  }
}