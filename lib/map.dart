import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          'Corona cases Survey Map',
        ),
      ),

      body:Column(
        children: <Widget>[
          Expanded(child: Image.asset('assets/map1.jpeg')),
        ],
      )
    );
  }
}
