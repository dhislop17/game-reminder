import 'package:flutter/material.dart';
import 'package:sports_game_reminder/models/theme_model.dart';
import 'package:sports_game_reminder/models/user_model.dart';

class SettingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: DrawerHeader(
            child: Text(
              "Hockey Reminder", style: TextStyle(fontSize: 29, color: Colors.white)
            ),
            decoration: BoxDecoration(
              color: ThemeModel.of(context).teamPrimaryColor
            ),
          ),
          height: 75,
        ),
        ListTile(
          leading: Icon(Icons.access_alarms),
          onTap: () {
            Navigator.pushNamed(context, 'reminders');
          },
          title: Text("Reminders"),
        ),
        ListTile(
          leading: Icon(Icons.format_list_numbered),
          onTap: () {
            Navigator.pushNamed(context, 'standings');
          },
          title: Text("Standings"),
        ),
        ListTile(
          //TODO: Consider renaming this Players
          leading: Icon(Icons.person),
          onTap: () {
            Navigator.pushNamed(context, 'rosters', arguments: UserModel.of(context).currentTeam);
          },
          title: Text("Roster"),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          onTap: () {
            Navigator.pushNamed(context, 'settings');
          },
          title: Text("Settings"),
        )
      ],
    );
  }
}
