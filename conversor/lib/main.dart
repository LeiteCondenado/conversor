import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/weather?key=26e04c34";

void main() async{
  runApp(MaterialApp(
    home: Home(), 
    theme: ThemeData(
      hintColor: Colors.white,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
          ),
        ),
      ),
  ));
}

Future<Map> getData() async{
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;
  void realChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / this.dolar).toStringAsFixed(2);
    euroController.text = (real / this.euro).toStringAsFixed(2);
  }
  void dolarChanged(String text){
    double dolar = double.parse(text);
    double real = dolar * this.dolar;
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (real / this.euro).toStringAsFixed(2);
  }
  void euroChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    double real = euro * this.euro;
    realController.text = real.toStringAsFixed(2);
    dolarController.text = (real / this.dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.pink,
      appBar: AppBar(
        title: Text("conversor"),
        backgroundColor: Colors.pink[800],
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return _buildMessage("Carregando Dados...", Colors.blue);
            default:
              if (snapshot.hasError) {
                return _buildMessage("Erro ao Carregando Dados...", Colors.purple[200]);
              } else {
                this.dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                this.euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150.0, color:
                      Colors.red,),
                      // buildTextField("Real", "R\$", realController, realChanged),
                      // Divider(),
                      // buildTextField("Dolar", "US\$", dolarController, dolarChanged),
                      // Divider(),
                      // buildTextField("Euro", "€", euroController, euroChanged),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Real",
                          prefixText: "R\$",
                          labelStyle: TextStyle(color: Colors.white)
                        ),
                      ),
                      Divider(),
                       TextField(
                        decoration: InputDecoration(
                          labelText: "Dolar",
                          prefixText: "US\$",
                          labelStyle: TextStyle(color: Colors.white)
                        ),
                      ),
                      Divider(),
                        TextField(
                        decoration: InputDecoration(
                          labelText: "Euro",
                          prefixText: "€",
                          labelStyle: TextStyle(color: Colors.white)
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                  ),
                );
              }
          }
        },
      ),
    );
  }//build
  Widget _buildMessage(String text, Color color){
    return Center(
      child: Text(
      text,
      style: TextStyle(color: color, fontSize: 25.0),
      textAlign: TextAlign.center,
      ),
    );
  }//_buildMessage
  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }
  Widget buildTextField(String labelText, String prefixText,
  TextEditingController textEditingController, Function onChanged){
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        prefixText: prefixText),
      style: TextStyle(color: Colors.white),
      controller: textEditingController,
      onChanged: onChanged,
    );
  }
}//HomeState