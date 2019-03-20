import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const url = "https://api.hgbrasil.com/finance?format=json-cors&key=3d39b833";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(url);

  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChange(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChange(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChange(String text) {
    double euro = double.parse(text);

    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  double dolar, euro, real;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando dados...",
                    style: TextStyle(fontSize: 25.0, color: Colors.amber),
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao carregar dados :/",
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.amber,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on,
                            color: Colors.amber, size: 150.0),
                        builderTextField(
                            "Real", "R\$ ", realController, _realChange),
                        Divider(),
                        builderTextField(
                            "Dolar", "US\$ ", dolarController, _dolarChange),
                        Divider(),
                        builderTextField(
                            "Euro", "£ ", euroController, _euroChange)
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget builderTextField(
    String label, String prefix, TextEditingController controller, Function f) {
  return TextField(
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.amber,
      ),
      prefixText: prefix,
      border: OutlineInputBorder(),
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    controller: controller,
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
