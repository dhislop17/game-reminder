import 'package:sports_game_reminder/data/player.dart';
import 'package:sports_game_reminder/data/requests.dart';

class League {
  List<Team> teams;
  List<Team> sortedTeams;
  List<Division> divisions;
  Map<String, Conference> conferences;

  League(this.teams, this.divisions, this.conferences);

  void createConfStats() {
    print("Creating Conferences");
    var eastTemp = divisions[0].teams + divisions[1].teams;
    var westTemp = divisions[2].teams + divisions[3].teams;
    conferences['Eastern'] = new Conference(name: 'Eastern', teams: eastTemp);
    conferences['Western'] = new Conference(name: 'Western', teams: westTemp);
    conferences.forEach((key, value) => value.reorderTeams());
  }

  void createLeagList() {
    print("Creating League List");
    teams = conferences['Eastern'].teams + conferences['Western'].teams;
    teams.sort((a, b) => int.parse(a.teamStat.leagRank)
        .compareTo(int.parse(b.teamStat.leagRank)));
    sortedTeams = List.from(teams);
    sortedTeams.sort((a, b) => a.name.compareTo(b.name));
  }

  void createRosters() {
    teams.forEach((team) {
      team.getRoster(team.id);
    });
  }

  Team findTeam(String name) {
    return teams.firstWhere((team) => team.name == name);
  }

  @override
  String toString() {
    return teams.toString();
  }
}

class Conference {
  String name;
  List<Team> teams;

  Conference({this.name, this.teams});

  void reorderTeams() {
    teams.sort((a, b) => int.parse(a.teamStat.confRank)
        .compareTo(int.parse(b.teamStat.confRank)));
  }

  @override
  String toString() {
    return name + " " + teams.toString();
  }
}

class Division {
  String name;
  String conf;
  List<Team> teams;

  Division({this.name, this.conf, this.teams});

  Division.fromJson(Map<String, dynamic> parsedJson) {
    name = parsedJson['division']['name'];
    conf = parsedJson['conference']['name'];
    teams = [];
    parsedJson['teamRecords'].forEach((rec) {
      teams.add(new Team.fromJson(rec, name, conf));
    });
  }

  static List<Division> createDivs(Map<String, dynamic> parsedJson) {
    List<Division> result;
    if (parsedJson['records'] != null) {
      result = [];
      parsedJson['records'].forEach((v) {
        result.add(new Division.fromJson(v));
      });
      return result;
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return name + " " + teams.toString();
  }
}

class Team {
  int id;
  String name;
  String conf;
  String div;
  Stat teamStat;
  Roster roster;

  Team(this.id, this.name, this.conf, this.div, this.teamStat);

  Team.fromJson(Map<String, dynamic> parsedJson, String d, String c) {
    div = d;
    conf = c;
    id = parsedJson['team']['id'];
    name = parsedJson['team']['name'];
    teamStat = Stat.fromJson(parsedJson);
  }

  void getRoster(int id) async {
    await Requests.fetchRoster(id).then((Roster r) {
      roster = r;
    });
  }

  @override
  String toString() {
    return name + " " + conf;
  }

  String testString() {
    return name + " " + teamStat.testString();
  }

  String nameWithRank(String rankType) {
    if (rankType == 'div') {
      return teamStat.divRank + ". " + name;
    } else if (rankType == 'conf') {
      return teamStat.confRank + ". " + name;
    } else {
      return teamStat.leagRank + ". " + name;
    }
  }

  int divCode() {
    if (div == 'Metropolitan') {
      return 0;
    } else if (div == 'Atlantic') {
      return 1;
    } else if (div == 'Central') {
      return 2;
    } else {
      return 3;
    }
  }
}

class Stat {
  int points;
  int wins;
  int losses;
  int ot;
  int gamesPlayed;
  String divRank;
  String confRank;
  String leagRank;
  String streak;

  Stat(this.points, this.wins, this.losses, this.ot, this.gamesPlayed,
      this.divRank, this.confRank, this.leagRank, this.streak);

  Stat.fromJson(Map<String, dynamic> parsedJson) {
    wins = parsedJson['leagueRecord']['wins'];
    losses = parsedJson['leagueRecord']['losses'];
    ot = parsedJson['leagueRecord']['ot'];
    points = parsedJson['points'];
    divRank = parsedJson['divisionRank'];
    confRank = parsedJson['conferenceRank'];
    leagRank = parsedJson['leagueRank'];
    gamesPlayed = parsedJson['gamesPlayed'];
    streak = parsedJson['streak']['streakCode'];
  }

  String testString() {
    return wins.toString() +
        ", " +
        losses.toString() +
        ", " +
        ot.toString() +
        ", " +
        points.toString() +
        ", " +
        streak;
  }
}
