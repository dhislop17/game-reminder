import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:sports_game_reminder/models/calendar_model.dart';
import 'package:sports_game_reminder/models/theme_model.dart';
import 'package:sports_game_reminder/models/user_model.dart';
import 'package:sports_game_reminder/widgets/calendar_schedule.dart';
import 'package:sports_game_reminder/widgets/settings_list.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<DateTime> days;
  List<String> gameNames;
  Map<DateTime, List<String>> gameDays;

  //TODO: Improve Get requests
  @override
  Widget build(BuildContext context) {
    print("home page build");
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, uModel) {
        if (uModel.leagueLoaded) {
          CalendarModel.of(context)
              .getSched(UserModel.of(context).currentTeam.id);
        }
        return Scaffold(
            appBar: AppBar(
              backgroundColor: ThemeModel.of(context).teamPrimaryColor,
              title: Text(UserModel.of(context).mainTeamName),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.swap_horizontal_circle),
                  onPressed: () {
                    Navigator.pushNamed(context, 'prefs');
                  },
                ),
              ],
            ),
            drawer: Drawer(
              child: SettingsList(),
            ),
            body: ScopedModelDescendant<CalendarModel>(
                builder: (context, child, cModel) {
              if (!CalendarModel.of(context).schedLoaded) {
                return Center(child: CircularProgressIndicator());
              } else {
                return CalendarSchedule();
              }
            }));
      },
    );
  }
}
