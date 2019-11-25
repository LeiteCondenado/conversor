import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance/stock_price?key=26e04c34&symbol=bidi4";

void main() async{
  runApp(MaterialApp(
    home: Container(),
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
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.pink,
      appBar: AppBar(
        title: Text("conversor"),
        backgroundColor: Colors.pink[800],
        centerTitle: true,
      )
    );
  }
}