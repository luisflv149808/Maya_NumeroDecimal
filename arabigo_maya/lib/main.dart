import 'package:flutter/material.dart';
import 'inicio.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
        title: 'Atinale Al Numero',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.purple[600],
          accentColor: Colors.deepPurpleAccent[200],
        ),
 
        home: Inicio());
  }
}