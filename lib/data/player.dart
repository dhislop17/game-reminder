class Player {
  int id;
  String name;
  String pos;
  String posShort;
  String type;
  String number;
  PlayerStat stats;

  Player(this.id, this.name, this.pos, this.posShort, this.type, this.number, {this.stats});

  Player.fromJson(Map<String, dynamic> parsedJson){
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

class PlayerStat {

}

class Roster{
  List<Player> skaters;
  List<Player> goalies;

  Roster({this.skaters, this.goalies});

  Roster.fromJson(Map<String, dynamic> parsedJson){
    skaters = [];
    goalies = [];
    parsedJson['roster'].forEach((p) {
      if (p['position']['type'] != 'Goalie'){
        skaters.add(new Player.fromJson(p));
      }
      else {
        goalies.add(new Player.fromJson(p));
      }
    });
  }

    @override
    String toString() {
      return 'Skaters ->' + skaters.length.toString() + ',' + goalies.length.toString();
    }
    

}