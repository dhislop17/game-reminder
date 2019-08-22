import 'package:flutter/material.dart';
import 'package:sports_game_reminder/models/theme_model.dart';
import 'package:sports_game_reminder/models/user_model.dart';

class SettingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        DrawerHeader(
          child: Center(
              child: Text(UserModel.of(context).mainTeamName,
                  style: TextStyle(fontSize: 16))),
          decoration: BoxDecoration(
              color: ThemeModel.of(context).teamSecondaryColor,
              border: Border.all(width: 2)),
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
          leading: Icon(Icons.person),
          onTap: () {},
          title: Text("Rosters"),
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
