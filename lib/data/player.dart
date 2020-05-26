class Player {
  int id;
  String name;
  String pos;
  String posShort;
  String type;
  String number;

  Player(this.id, this.name, this.pos, this.posShort, this.type, this.number);

  Player.fromJson(Map<String, dynamic> parsedJson) {
    name = parsedJson['person']['fullName'];
    id = parsedJson['person']['id'];
    number = parsedJson['jerseyNumber'];
    type = parsedJson['position']['type'];
    pos = parsedJson['position']['name'];
    posShort = parsedJson['position']['abbreviation'];
  }

  @override
  String toString() {
    return name + " - " + '#$number' + ' - ' + type;
  }
}

class SkaterStat {
  int gamesPlayed;
  int goals;
  int assists;
  int points;
  int penaltyMins;
  int plusMinus;
  int ppg;
  int ppp;
  int shg;
  int shp;

  SkaterStat(this.gamesPlayed, this.goals, this.assists, this.points,
      this.penaltyMins, this.plusMinus, this.ppg, this.ppp, this.shg, this.shp);

  SkaterStat.fromJson(Map<String, dynamic> parsedJson) {
    Map<String, dynamic> shorten = parsedJson['stats'][0]['splits'][0]['stat'];
    gamesPlayed = shorten['games'];
    goals = shorten['goals'];
    assists = shorten['assists'];
    points = shorten['points'];
    penaltyMins = shorten['pim'];
    plusMinus = shorten['plusMinus'];
    ppg = shorten['powerPlayGoals'];
    ppp = shorten['powerPlayPoints'];
    shg = shorten['shortHandedGoals'];
    shp = shorten['shortHandedPoints'];
  }
}

class GoalieStat {
  int gamesPlayed;
  int wins;
  int losses;
  int ot;
  int so;
  double gaa;
  double svp;

  GoalieStat(
      this.gamesPlayed, this.wins, this.losses, this.so, this.ot, this.gaa, this.svp);

  GoalieStat.fromJson(Map<String, dynamic> parsedJson) {
    Map<String, dynamic> shorten = parsedJson['stats'][0]['splits'][0]['stat'];
    gamesPlayed = shorten['games'];
    wins = shorten['wins'];
    losses = shorten['losses'];
    ot = shorten['ot'];
    so = shorten['shutouts'];
    gaa = shorten['goalAgainstAverage'];
    svp = shorten['savePercentage'];
  }
}

class Roster {
  List<Player> skaters;
  List<Player> goalies;

  Roster({this.skaters, this.goalies});

  Roster.fromJson(Map<String, dynamic> parsedJson) {
    skaters = [];
    goalies = [];
    parsedJson['roster'].forEach((p) {
      if (p['position']['type'] != 'Goalie') {
        skaters.add(new Player.fromJson(p));
      } else {
        goalies.add(new Player.fromJson(p));
      }
    });
  }

  @override
  String toString() {
    return 'Skaters ->' +
        skaters.length.toString() +
        ',' +
        goalies.length.toString();
  }
}
