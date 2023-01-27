import 'package:flutter/material.dart';
import 'package:sudoku/sudoku_widget.dart';
import 'package:firebase_core/firebase_core.dart';
Future  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBDpdfuuVPYP178dDJtw-PBnB7A8ekvWx8",  
      authDomain: "sudoku-dad.firebaseapp.com",  
      projectId: "sudoku-dad",  
      storageBucket: "sudoku-dad.appspot.com", 
      messagingSenderId: "888302933344", 
      appId: "1:888302933344:web:6abf016b373f53b6103a05", 
      measurementId: "G-WCVX7D2ETM"
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: const SudokuWidget(),
    );
  }
}

