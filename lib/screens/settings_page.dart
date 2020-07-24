import 'package:flutter/material.dart';
import 'package:sports_game_reminder/models/calendar_model.dart';
import 'package:sports_game_reminder/models/theme_model.dart';
import 'package:sports_game_reminder/models/user_model.dart';

class SettingsPage extends StatefulWidget {
  @override
  State createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Settings"),
        //back button
      ),
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Switch(
                  value: ThemeModel.of(context).darkMode,
                  onChanged: (value) {
                    ThemeModel.of(context).setDarkMode(value);
                  },
                  activeColor: Theme.of(context).accentIconTheme.color,
                  activeTrackColor: Theme.of(context).accentColor,
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(child: Text("Dark Mode")),
              ),
            ],
          ),
          ListTile(
            title: Text("Change Team Preferences"),
            onTap: () {
              Navigator.pushNamed(context, 'favs');
            },
          ),
          ListTile(
            title: Text("Clear Saved Preferences"),
            onTap: () {
              UserModel.of(context).clearData();
              ThemeModel.of(context).clearData();
              CalendarModel.of(context).clearData();
            },
          ),
        ],
      ),
    );
  }
}
