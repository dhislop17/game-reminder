import "package:flutter/material.dart";
import 'package:sports_game_reminder/models/user_model.dart';
import 'package:sports_game_reminder/widgets/team_prefs_list.dart';

class TeamPrefsPage extends StatefulWidget {
  @override
  _TeamPrefsPageState createState() => _TeamPrefsPageState();
}

class _TeamPrefsPageState extends State<TeamPrefsPage> {
  @override
  Widget build(BuildContext context) {
    print("Prefs Page Build");
   // return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return WillPopScope(
        onWillPop: () {
          UserModel.of(context).saveData();
          //model.saveData();
          Navigator.pop(context);
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Set Main Team'),
          ),
          body: TeamPrefsList(), 
        ),
      );
   // });
  }
}
