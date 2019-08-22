import 'package:flutter/widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:sports_game_reminder/app_theme.dart';
import 'package:sports_game_reminder/data/requests.dart';

class ThemeModel extends Model {
  String teamName;
  Color teamPrimaryColor;
  Color teamSecondaryColor;
  bool darkMode = false;

  static ThemeModel of (BuildContext context) =>
    ScopedModel.of<ThemeModel>(context);

    ThemeModel() {
      _loadData();
    }

    _loadData() async {
      final sp = await SharedPreferences.getInstance();
      teamName = sp.getString('mainTeam') ?? '';
      darkMode = sp.getBool('darkModeEnabled?') ?? false;
      if (teamName != '') {
        setFavorite(teamName);
      }
    }

    _saveData() async {
      final sp = await SharedPreferences.getInstance();
      sp.setBool('darkModeEnabled?', darkMode);
    }

    setFavorite(String name) {
      teamName = Requests.teamFinder(name, 'full name');
      teamPrimaryColor = Themes.teamColors[teamName][0];
      teamSecondaryColor = Themes.teamColors[teamName][1];
      notifyListeners();
    }

    setDarkMode(bool state) {
      darkMode = state;
      _saveData();
      notifyListeners();
    }


}