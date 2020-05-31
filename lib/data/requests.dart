import 'dart:convert';
import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;

import 'package:sports_game_reminder/data/schedule.dart';
import 'package:sports_game_reminder/data/league.dart';
import 'package:sports_game_reminder/data/player.dart';

class Season {
  String startDate;
  String endDate;
  String seasonId;

  Season({this.seasonId, this.startDate, this.endDate});

  factory Season.fromJson(Map<String, dynamic> parsedJson) {
    return Season(
        seasonId: parsedJson['seasons'][0]['seasonId'],
        startDate: parsedJson['seasons'][0]['regularSeasonStartDate'],
        endDate: parsedJson['seasons'][0]['regularSeasonEndDate']);
  }
}

class Requests {
  static String baseRoute = 'https://statsapi.web.nhl.com/api/v1/';

  static Map<String, String> nameToAbbr = {
    'ANA': 'Anaheim Ducks',
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

  static Future<Season> fetchSeason() async {
    final response = await http.get(baseRoute + 'seasons/current');

    if (response.statusCode == 200) {
      return compute(parseSeason, response.body);
    } else {
      throw Exception("Unable to fetch season data");
    }
  }

  static Season parseSeason(String responseBody) {
    final parsed = json.decode(responseBody);
    Season result = Season.fromJson(parsed);

    return result;
  }

  static Future<List<Division>> fetchNHL() async {
    final response = await http.get(baseRoute + 'standings');

    if (response.statusCode == 200) {
      return compute(parseNHL, response.body);
    } else {
      throw Exception("Unable to fetch NHL data");
    }
  }

  static List<Division> parseNHL(String responseBody) {
    final parsed = json.decode(responseBody);
    List<Division> result = Division.createDivs(parsed);

    return result;
  }

  static Future<Schedule> fetchSched(int teamId) async {
    Season curr = await fetchSeason().then((Season s) => s);
    final response = await http.get(baseRoute +
        'schedule?teamId=$teamId&startDate=${curr.startDate}&endDate=${curr.endDate}');

    if (response.statusCode == 200) {
      return compute(parseSched, response.body);
    } else {
      throw Exception('Unable to fetch schedule data');
    }
  }

  static Schedule parseSched(String responseBody) {
    final parsed = json.decode(responseBody);
    Schedule temp = Schedule.fromJson(parsed);

    return temp;
  }

  static Future<Roster> fetchRoster(int teamId) async {
    final response = await http.get(baseRoute + 'teams/$teamId/roster');

    if (response.statusCode == 200) {
      return compute(parseRoster, response.body);
    } else {
      throw Exception("Unable to request roster data");
    }
  }

  static Roster parseRoster(String responseBody) {
    final parsed = json.decode(responseBody);
    Roster roster = Roster.fromJson(parsed);

    return roster;
  }

  static Future<SkaterStat> fetchSkStat(int pId) async {
    Season curr = await fetchSeason().then((Season s) => s);
    final response = await http.get(baseRoute +
        'people/$pId/stats?stats=statsSingleSeason&season=${curr.seasonId}');

    if (response.statusCode == 200) {
      return compute(parseSkate, response.body);
    } else {
      throw Exception("Unable to retrive player data");
    }
  }

  static SkaterStat parseSkate(String responseBody) {
    final parsed = json.decode(responseBody);
    SkaterStat result = SkaterStat.fromJson(parsed);

    return result;
  }

  static Future<GoalieStat> fetchGoStat(int pId) async {
    Season curr = await fetchSeason().then((Season s) => s);
    final response = await http.get(baseRoute +
        'people/$pId/stats?stats=statsSingleSeason&season=${curr.seasonId}');

    if (response.statusCode == 200) {
      return compute(parseGoal, response.body);
    } else {
      throw Exception("Unable to retrive player data");
    }
  }

  static GoalieStat parseGoal(String responseBody) {
    final parsed = json.decode(responseBody);
    GoalieStat result = GoalieStat.fromJson(parsed);

    return result;
  }
}
