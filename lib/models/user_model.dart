import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sports_game_reminder/data/league.dart';
import 'package:sports_game_reminder/data/requests.dart';


class UserModel extends Model {
  static UserModel of (BuildContext context) =>
    ScopedModel.of<UserModel>(context);
  
  String mainTeamName;
  String mainTeamAbbr;
  List<String> favTeams;
  League league;
  Team currentTeam;

  bool completedIntro = false;
  bool leagueLoaded = false;

  UserModel() {
    getLeague();
    _loadData();
  }
  
  void _loadData() async {
    final sp = await SharedPreferences.getInstance();
    mainTeamName = sp.getString('mainTeam') ?? '';

    if (mainTeamName != '') {
      mainTeamAbbr = Requests.teamFinder(mainTeamName, 'full name');
      favTeams = sp.getStringList('favTeams');
      print(favTeams);
      completedIntro = true;
    }
    else {
      mainTeamAbbr = '';
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

  void addTeam(String name) {
    favTeams.add(name);
    notifyListeners();
  }

  void removeTeam(String name) {
    favTeams.remove(name);
    notifyListeners();
  }

  void setMainTeam(String name) {
    mainTeamName = name;
    mainTeamAbbr = Requests.teamFinder(name, 'full name');
    currentTeam = league.findTeam(name);
    notifyListeners();
  }

  void getLeague() async {
    await Requests.fetch()
      .then((League temp) {
       league = temp;
       leagueLoaded = true;
       if (mainTeamName != ''){
         currentTeam = league.findTeam(mainTeamName);
       }
       notifyListeners();
      });    
  }

  void finishedIntro(){
    completedIntro = true;
    notifyListeners();
  }
 
}