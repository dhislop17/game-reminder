import 'package:intl/intl.dart';

class Schedule {
  List<Game> games;
  Map<DateTime, List<Game>> gamesList;

  Schedule({this.games});

  Schedule.fromJson(Map<String, dynamic> json) {
    games = new List<Game>();
    json['dates'].forEach((g) {
      games.add(new Game.fromJson(g));
    });
  }

  @override
  String toString() {
    return gamesList.toString();
  }

  void gamesMap() {
    gamesList = Map.fromIterable(
      games,
      key: (item) => DateTime.parse(item.date),
      value: (item) => [item],
    );
  }

  Game getGame(DateTime date) {
    return games.firstWhere((game) => DateTime.parse(game.date) == date,
        orElse: () {return null;});
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

  Game(
      {this.date,
      this.home,
      this.away,
      this.startTime,
      this.homeScore,
      this.awayScore,
      this.status});

  //TODO: Consider implementation for team records

  Game.fromJson(Map<String, dynamic> json) {
    //TODO: Improve This
    date = json['date'] + 'T12:00:00Z';
    var game = json['games'][0];
    startTime = DateTime.parse(game['gameDate']).toLocal();
    status = game['status']['detailedState'];
    home = game['teams']['home']['team']['name'];
    away = game['teams']['away']['team']['name'];
    homeScore = game['teams']['home']['score'];
    awayScore = game['teams']['away']['score'];
  }

  String get awayTeam => away;
  String get homeTeam => home;
  String get awayTScore => awayScore.toString();
  String get homeTScore => homeScore.toString();

  String serializeGame(){
    return '${this.date},${this.home},${this.away},${this.startTime},${this.homeScore},${this.awayScore},${this.score},${this.status}';
  }

  static Game deserializeGame(String s){
    List desGame = s.split(',');
    return Game(
      date: desGame[0],
      home: desGame[1],
      away: desGame[2],
      startTime: DateTime.parse(desGame[3]),
      homeScore: int.parse(desGame[4]),
      awayScore: int.parse(desGame[5]),
      status: desGame[7],
    );
  }


  @override
  String toString() {
    return away + " @ " + home;
  }

  String getNormalTime() {
    String temp = DateFormat.jm().format(startTime).toString();
    return temp;
  }

  String getScore() {
    return awayScore.toString() + " - " + homeScore.toString();
  }
}