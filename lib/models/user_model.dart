import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sports_game_reminder/data/league.dart';
import 'package:sports_game_reminder/data/requests.dart';

class UserModel extends Model {
  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  String mainTeamName;
  List<String> favTeams;
  League league;
  Team currentTeam;

  bool completedIntro = false;
  bool leagueLoaded = false;

  UserModel() {
    league = new League([], [], {});
    getNHL();
    _loadData();
  }

  void _loadData() async {
    final sp = await SharedPreferences.getInstance();
    mainTeamName = sp.getString('mainTeam') ?? '';

    if (mainTeamName != '') {
      favTeams = sp.getStringList('favTeams');
      print(favTeams);
      completedIntro = true;
    } else {
      favTeams = [];
      completedIntro = false;
    }
    notifyListeners();
  }

  void saveData() async {
    final sp = await SharedPreferences.getInstance();
    print("Saving Data");
    sp.setString('mainTeam', mainTeamName);
    sp.setStringList('favTeams', favTeams);
    sp.setInt('length', favTeams.length);
  }

  void clearData() async {
    final sp = await SharedPreferences.getInstance();
    sp.remove('mainTeam');
    sp.remove('favTeams');
    sp.remove('length');
    sp.remove('introComplete');
    favTeams = [];
    mainTeamName = '';
    currentTeam = null;
    completedIntro = false;
    notifyListeners();
  }

  ///adds a team to the list of favorite teams
  void addTeam(String name) {
    favTeams.add(name);
    notifyListeners();
  }

  ///removes the team from the list of favorite teams
  void removeTeam(String name) {
    favTeams.remove(name);
    notifyListeners();
  }

  ///Changes the current primary team to the one 
  ///selected by the user on the update prefs page
  void setMainTeam(String name) {
    mainTeamName = name;
    currentTeam = league.findTeam(name);
    notifyListeners();
  }

  ///Fetches division jsons from API
  void getNHL() async {
    await Requests.fetchNHL().then(
      (List<Division> divs) {
        leagueLoaded = true;
        league.divisions = divs;
        league.createConfStats();
        league.createLeagList();
        league.createRosters();

        if (mainTeamName != '') {
          currentTeam = league.findTeam(mainTeamName);
        }
        
        notifyListeners();
      }
    );
  }


  void finishedIntro() {
    completedIntro = true;
    notifyListeners();
  }
}
