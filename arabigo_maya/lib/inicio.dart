import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'conversor.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversor Arabigo-Maya / Maya-Arabigo"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Iniciar"),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Conversor()),
            );
          },
        ),
      ),
    );
  }
}

