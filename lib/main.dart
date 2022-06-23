import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Wikipedia search API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future getAutoData() async {
    var response = await http.get(Uri.parse("https://ghibliapi.herokuapp.com/vehicles"));

    var jsonData = jsonDecode(response.body);

    List<Auto> autos = [];

    for (var u in jsonData) {
      Auto auto = Auto(u["id"], u["name"], u["description"], u["vehicle_class"], u["length"]);
      autos.add(auto);
    }

    return autos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proyecto 2'),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        child: Card(
          child: FutureBuilder(
            future: getAutoData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(child: Text('Cargando')),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return Card(
                          child: ListTile(
                        title: Text(snapshot.data[i].name),
                        subtitle: Text(snapshot.data[i].description),
                        trailing: Text(snapshot.data[i].vehicle_class),
                      ));
                    });
              }
            },
          ),
        ),
      ),
    );
  }
}

class Auto {
  final String id, name, description, vehicle_class, length;
  Auto(this.id, this.name, this.description, this.vehicle_class, this.length);
}
