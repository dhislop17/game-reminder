import 'dart:convert';
import 'package:flutter/foundation.dart';
//import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

import 'package:sports_game_reminder/data/schedule.dart';
import 'package:sports_game_reminder/data/league.dart';

class Player {
  String name;
  String pos;
  int goals;
  int assists;
  int points;
}

class Requests {
  static String baseRoute = 'https://statsapi.web.nhl.com/api/v1/';
  
  //TODO: Consider dynamic start and end dates
  static String startDate = '2019-09-01';
  static String endDate = '2020-04-10'; 
  static String testRoute = 'https://statsapi.web.nhl.com/api/v1/schedule?teamId=10&startDate=2019-09-01&endDate=2019-12-31';

  static Map<String, String> nameToAbbr = {
    'ANA': 'Anahiem Ducks',
    'ARI': 'Arizona Coyotes',
    'BOS': 'Boston Bruins',
    'BUF': 'Buffalo Sabres',
    'CAR': 'Carolina Hurricanes',
    'CBJ': 'Columbus Blue Jackets',
    'CGY': 'Calgary Flames',
    'CHI': 'Chicago Blackhawks',
    'COL': 'Colorado Avalanche',
    'DAL': 'Dallas Stars',
    'DET': 'Detroit Red Wings',
    'EDM': 'Edmonton Oilers',
    'FLA': 'Florida Panthers',
    'LAK': 'Los Angeles Kings',
    'MIN': 'Minnesota Wild',
    'MTL': 'Montréal Canadiens',
    'NSH': 'Nashville Predators',
    'NJD': 'New Jersey Devils',
    'NYI': 'New York Islanders',
    'NYR': 'New York Rangers',
    'OTT': 'Ottawa Senators',
    'PHI': 'Philadelphia Flyers',
    'PIT': 'Pittsburgh Penguins',
    'SJS': 'San Jose Sharks',
    'STL': 'St. Louis Blues',
    'TBL': 'Tampa Bay Lightning',
    'TOR': 'Toronto Maple Leafs',
    'VAN': 'Vancouver Canucks',
    'VGK': 'Vegas Golden Knights',
    'WPG': 'Winnipeg Jets',
    'WSH': 'Washington Capitals'
  };


  static String teamFinder(String name, String inputNameType) {
    String result;

    if (inputNameType == 'full name') {
      return nameToAbbr.keys.firstWhere((k) => nameToAbbr[k] == name);
    } else {
      result = nameToAbbr[name];
    }
    return result;
  }


  static Future<List<Division>> fetchNHL() async {
    final response = await http.get(baseRoute + 'standings');

    if (response.statusCode == 200){
      return compute(parseNHL, response.body);
    }
    else {
      throw Exception("Unable to fetch NHL data");
    }
  }

  static List<Division> parseNHL(String responseBody){
    final parsed = json.decode(responseBody);
    List<Division> result = Division.createDivs(parsed);

    return result;
  }

  static Future<Schedule> fetchSched(int teamId) async {
    final response = await http.get(baseRoute +
        'schedule?teamId=$teamId&startDate=$startDate&endDate=$endDate');

    if (response.statusCode == 200) {
      return compute(parseSched, response.body);
    } else {
      throw Exception();
    }
  }

  static Schedule parseSched(String responseBody) {
    final parsed = json.decode(responseBody);
    Schedule temp = Schedule.fromJson(parsed);

    return temp;
  }
}
