import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class Conversor extends StatefulWidget {
  int numero;
  bool esMaya;

  Conversor() {
    numero = Random().nextInt(400);
    esMaya = Random().nextBool();
  }

  @override
  _ConversorState createState() => _ConversorState();
}

class _ConversorState extends State<Conversor> {
  List<int> respuestasArabigas = [];
  int indiceMaya = 0;
  List<List<int>> respuestasMayas = [[]];


 //Cuadro que muestra el resultado ya sea correcto o incorrecto
  Widget dialogoResultado(int resultado) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
            margin: EdgeInsets.all(15.0),
            padding: EdgeInsets.all(20.0),
            decoration: ShapeDecoration(
                color: resultado == widget.numero
                    ? Colors.green[700]
                    : Colors.red[500],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(15),
                  child: Text(
                      "${resultado != widget.numero ? "$resultado / " : ""}${widget.numero}",
                      style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontSize: 40)),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Text(
                      "Respuesta ${resultado == widget.numero ? "Correcta" : "Incorrecta"}",
                      style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontSize: 17)),
                )
              ],
            )),
      ),
    );
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }

  Widget muestraNumerosMayas(List<List<int>> numerosMayas) {
    List<Widget> widgetsList = [];
    for (List<int> lista in numerosMayas) {
      if (lista.isEmpty) return Container();
      widgetsList.add(objetoNumerosMayas(lista));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgetsList,
    );
  }

  Widget objetoNumerosMayas(List<int> list) {
    if (list.isEmpty) return Container();
    List<Widget> lista = [];
    if (list.contains(1)) {
      List<Widget> rowsList = [];
      list.where((element) => element == 1).toList().forEach((element) {
        rowsList.add(Container(
          margin: EdgeInsets.all(3),
          child: Image.asset("imagenes/1.png", height: 15, color: Colors.black),
        ));
      });
      lista.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: rowsList,
            ),
          )
        ],
      ));
    }
    if (list.contains(5)) {
      list.where((element) => element == 5).toList().forEach((element) {
        lista.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(3),
              child: Image.asset("imagenes/5.png",
                  height: 12, color: Colors.black),
            )
          ],
        ));
      });
    }
    if (list.contains(0)) {
      lista.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(3),
            child:
                Image.asset("imagenes/0.png", height: 25, color: Colors.black),
          )
        ],
      ));
    }
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
      child: Column(children: lista),
    );
  }

  Widget _numeroSeleccionado() {
    if (widget.esMaya) {
      return Expanded(
          flex: 2,
          child: Center(
            child: SingleChildScrollView(
              child: muestraNumerosMayas(deArabigoAMaya(widget.numero)),
            ),
          ));
    } else {
      return Expanded(
          flex: 1,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  "${widget.numero}",
                  style: TextStyle(fontSize: 50),
                ),
              ),
            ),
          ));
    }
  }

  Widget imagenBoton(int numero) {
    switch (numero) {
      case 0:
        return Image.asset("imagenes/0.png", color: Colors.black);
      case 1:
        return Image.asset("imagenes/1.png", height: 25, color: Colors.black);
      case 5:
        return Image.asset("imagenes/5.png", color: Colors.black);
      default:
        return Image.asset("imagenes/0.png", color: Colors.black);
    }
  }

  Widget tecladoMaya() {
    return Container(
        margin: EdgeInsets.all(10),
        child: Wrap(
            spacing: 15,
            runSpacing: 15,
            children: [0, 1, 5].map((numero) {
              return Container(
                height: 80,
                width: 80,
                child: RaisedButton(
                    onPressed: () {
                      if (numero == 0 &&
                          (respuestasMayas[indiceMaya].contains(0) ||
                              respuestasMayas[indiceMaya].isNotEmpty)) return;
                      Map map = Map<int, int>();
                      if (numero == 1) {
                        respuestasMayas[indiceMaya].forEach((x) =>
                            map[x] = !map.containsKey(x) ? (1) : (map[x] + 1));
                        if (map.containsKey(0) ||
                            map.containsKey(1) && map[1] == 4) return;
                      }
                      if (numero == 5) {
                        respuestasMayas[indiceMaya].forEach((x) =>
                            map[x] = !map.containsKey(x) ? (1) : (map[x] + 1));
                        if (map.containsKey(0) ||
                            map.containsKey(5) && map[5] == 3) return;
                      }
                      setState(() {
                        respuestasMayas[indiceMaya].add(numero);
                      });
                    },
                    child: imagenBoton(numero)),
              );
            }).toList()));
  }

  Widget entradaMaya() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(children: [
        Column(
          children: respuestasMayas.map((lista) {
            return Row(
              children: [
                Expanded(
                    child: Material(
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 3),
                          borderRadius: BorderRadius.circular(20),
                          color: (respuestasMayas.indexOf(lista) == indiceMaya)
                              ? Colors.grey
                              : null),
                      child: objetoNumerosMayas(lista),
                    ),
                    onTap: () {
                      setState(() {
                        indiceMaya = respuestasMayas.indexOf(lista);
                      });
                    },
                  ),
                  type: MaterialType.transparency,
                )),
                (respuestasMayas.indexOf(lista) == indiceMaya)
                    ? IconButton(
                        icon: Icon(Icons.backspace),
                        onPressed: () {
                          setState(() {
                            lista.removeLast();
                          });
                        })
                    : Container()
              ],
            );
          }).toList()
            ..insert(
                0,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        if (respuestasMayas.first.isNotEmpty) {
                          setState(() {
                            indiceMaya = 0;
                            respuestasMayas.insert(0, []);
                          });
                        }
                      },
                      child: Icon(Icons.add),
                    )
                  ],
                )),
        ),
        tecladoMaya()
      ]),
    );
  }

  Widget entradaArabiga() {
    return Column(
      children: [cuadroTextoArabiga(), tecladoArabigo()],
    );
  }

  Widget cuadroTextoArabiga() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
      child: Row(
        children: [
          Expanded(
              child: Text(
            "${respuestasArabigas.join()}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontStyle: FontStyle.italic),
          )),
          IconButton(
              icon: Icon(Icons.backspace),
              iconSize: 25,
              onPressed: () {
                setState(() {
                  respuestasArabigas.removeLast();
                });
              })
        ],
      ),
    );
  }

  Widget tecladoArabigo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Wrap(
          spacing: 5,
          runSpacing: 5,
          children: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9].map((numero) {
            return Container(
              height: 50,
              width: 50,
              child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      respuestasArabigas.add(numero);
                    });
                  },
                  child: Text(
                    "$numero",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            );
          }).toList()),
    );
  }

  Widget _entradaNumeros() {
    return Expanded(
        flex: 2,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              child: widget.esMaya ? entradaArabiga() : entradaMaya(),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversor Arabigo-Maya"),
      ),
      body: Column(
        children: [
          Expanded(
              child: Column(
            children: [_numeroSeleccionado(), _entradaNumeros()],
          )),
          Center(
            child: Container(
              margin: EdgeInsets.all(5),
              child: RaisedButton(
                child: Text("Comprobar"),
                onPressed: comprobarNumero,
              ),
            ),
          )
        ],
      ),
    );
  }

  void comprobarNumero() async {
    if (respuestasArabigas.isNotEmpty || validarRespuestaMaya()) {
      int respuesta;
      if (!widget.esMaya) {
        respuesta = deMayaAArabigo(respuestasMayas);
      } else {
        respuesta = int.tryParse(respuestasArabigas.join()) ?? -1;
      }
      showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return dialogoResultado(respuesta);
        },
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 200),
      ).whenComplete(() {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Conversor()));
      });
    }
  }

  bool validarRespuestaMaya() {
    for (List<int> lista in respuestasMayas) {
      if (lista.isEmpty) return false;
    }
    return true;
  }

  int deMayaAArabigo(List<List<int>> listaCompleta) {
    int numero = 0;
    listaCompleta.reversed.toList().forEach((lista) {
      lista.forEach((numeroLista) => numero += (numeroLista *
          pow(20, listaCompleta.reversed.toList().indexOf(lista))));
    });
    return numero;
  }

  List<List<int>> deArabigoAMaya(int numero) {
    List<List<int>> listaResultados = [];
    for (int multi in [400, 20, 1]) {
      List<int> resultado = [];
      for (int value in [5, 1]) {
        if (numero ~/ (value * multi) >= 1) {
          for (int i = 0; i < numero ~/ (value * multi).toInt(); i++) {
            resultado.add(value);
          }
          numero = numero % (value * multi);
        }
      }
      if (resultado.isEmpty) resultado.add(0);
      listaResultados.add(resultado);
    }
    while (listaResultados[0].contains(0) && listaResultados.length > 1) {
      listaResultados.removeAt(0);
    }
    return listaResultados;
  }
}
