import 'package:flutter/material.dart';

//By Conf, div, and league
//Should default base on selected team
class StandingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Standings"),
     ),
     body: Container(child: Text("Standings")),
   );
  }
}