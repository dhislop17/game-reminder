import 'package:intl/intl.dart';

class Schedule {
  List<Game> games;
  Map<DateTime, List<Game>> gamesList;

  Schedule({this.games});

  Schedule.fromJson(Map<String, dynamic> json) {
    games = [];
    json['dates'].forEach((g) {
      games.add(new Game.fromJson(g));
    });
  }

  @override
  String toString() {
    return gamesList.toString();
  }

  ///Map the games to a day that will be used for the calendar widget
  void gamesMap() {
    gamesList = Map.fromIterable(
      games,
      key: (item) => DateTime.parse(item.date),
      value: (item) => [item],
    );
  }

  ///Method used by the calandar model to update the gamecard displayed
  ///under the calendar. Shows any scheduled games for that day
  Game getGame(DateTime date) {
    return games.firstWhere((game) => DateTime.parse(game.date) == date,
        orElse: () {
      return null;
    });
  }
}

class Game {
  String date;
  String home;
  String away;
  DateTime startTime;
  int homeScore;
  int awayScore;
  String score;
  String status;
  String homeRecord;
  String awayRecord;

  Game({
    this.date,
    this.home,
    this.homeRecord,
    this.away,
    this.awayRecord,
    this.startTime,
    this.homeScore,
    this.awayScore,
    this.status,
  });

  Game.fromJson(Map<String, dynamic> json) {
    date = json['date'] + 'T12:00:00Z';

    //temporary variables to make parsing the json object more readable
    var game = json['games'][0];
    var awayTeam = game['teams']['away'];
    var homeTeam = game['teams']['home'];

    startTime = DateTime.parse(game['gameDate']).toLocal();
    status = game['status']['abstractGameState'];

    home = homeTeam['team']['name'];
    away = awayTeam['team']['name'];
    homeScore = homeTeam['score'];
    awayScore = awayTeam['score'];

    if (game['gameType'] == 'R') {
      homeRecord = '(' +
          homeTeam['leagueRecord']['wins'].toString() +
          '-' +
          homeTeam['leagueRecord']['losses'].toString() +
          '-' +
          homeTeam['leagueRecord']['ot'].toString() +
          ')';
      awayRecord = '(' +
          awayTeam['leagueRecord']['wins'].toString() +
          '-' +
          awayTeam['leagueRecord']['losses'].toString() +
          '-' +
          awayTeam['leagueRecord']['ot'].toString() +
          ')';
    } else if (game['gameType'] == 'P') {
      homeRecord = '(' +
          homeTeam['leagueRecord']['wins'].toString() +
          '-' +
          homeTeam['leagueRecord']['losses'].toString() +
          ')';
      awayRecord = '(' +
          awayTeam['leagueRecord']['wins'].toString() +
          '-' +
          awayTeam['leagueRecord']['losses'].toString() +
          ')';
    } else {
      homeRecord = "";
      awayRecord = "";
    }
  }

  ///Serialize the game object in order to be saved
  String serializeGame() {
    return '${this.date},${this.home},${this.homeRecord},${this.away},${this.awayRecord},${this.startTime},${this.homeScore},${this.awayScore},${this.score},${this.status}';
  }

  ///Deserializes the saved game object
  static Game deserializeGame(String s) {
    List desGame = s.split(',');
    return Game(
        date: desGame[0],
        home: desGame[1],
        homeRecord: desGame[2],
        away: desGame[3],
        awayRecord: desGame[4],
        startTime: DateTime.parse(desGame[5]),
        homeScore: int.parse(desGame[6]),
        awayScore: int.parse(desGame[7]),
        status: desGame[8]);
  }

  @override
  String toString() {
    return getAway() + " @ " + getHome();
  }

  String getHome() {
    return home + " " + homeRecord;
  }

  String getAway() {
    return away + " " + awayRecord;
  }

  ///Convert the game's start time to human readable format
  String getNormalTime() {
    String temp = DateFormat.jm().format(startTime).toString();
    return temp;
  }

  ///Return the scores of the teams in the game
  String getScore() {
    return awayScore.toString() + " - " + homeScore.toString();
  }
}
