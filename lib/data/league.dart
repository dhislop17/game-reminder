
class League {
  List<Team> teams;

  League({this.teams});

  League.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson['teams'] != null) {
      teams = new List<Team>();
      parsedJson['teams'].forEach((v) {
        teams.add(new Team.fromJson(v));
      });
    }
  }

  @override
  String toString() {
    return teams.toString();
  }

  Team findTeam(String name) {
    return teams.firstWhere((team) => team.name == name);
  }
}

class Team {
  int id;
  String name;
  String abbr;
  String conf;
  String div;

  Team({this.id, this.name, this.abbr, this.conf, this.div});

  Team.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    name = parsedJson['name'];
    abbr = parsedJson['abbreviation'];
    conf = parsedJson['conference']['name'];
    div = parsedJson['division']['name'];
  }

  @override
  String toString() {
    return name + " " + conf;
  }
}