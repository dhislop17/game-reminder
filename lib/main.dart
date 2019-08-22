import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:sports_game_reminder/app_theme.dart';
import 'package:sports_game_reminder/models/calendar_model.dart';
import 'package:sports_game_reminder/models/user_model.dart';
import 'package:sports_game_reminder/models/theme_model.dart';

import 'package:sports_game_reminder/screens/home.dart';
import 'package:sports_game_reminder/screens/landing_page.dart';
import 'package:sports_game_reminder/screens/pick_favs_page.dart';
import 'package:sports_game_reminder/screens/reminder_page.dart';
import 'package:sports_game_reminder/screens/settings_page.dart';
import 'package:sports_game_reminder/screens/standings_page.dart';
import 'package:sports_game_reminder/screens/team_prefs.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<StatefulWidget> {
  //initialize the models
  final ThemeModel themeModel = ThemeModel();
  final UserModel userModel = UserModel();
  final CalendarModel calendarModel = CalendarModel();
  
  @override
  Widget build(BuildContext context) {
    //insert the models into the widget tree
    return ScopedModel<UserModel>(
      model: userModel,
      child: ScopedModel<ThemeModel>(
          model: themeModel,
          child: ScopedModel<CalendarModel>(
              model: calendarModel,
              child: ScopedModelDescendant<ThemeModel>(
                  builder: (context, child, model) {
                return MaterialApp(
                  theme: (!ThemeModel.of(context).darkMode)
                      ? Themes.lightTheme
                      : Themes.darkTheme,
                  home: LandingPage(),
                  //create routes
                  routes: {
                    'app' : (context) => HomePage(),
                    'favs' : (context) => PickFavsPage(),
                    'prefs' : (context) => TeamPrefsPage(),
                    'settings' : (context) => SettingsPage(),
                    'standings' : (context) => StandingsPage(),
                    'reminders' : (context) => ReminderPage()
                  },
                );
              }))),
    );
  }
}
