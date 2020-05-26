import 'package:flutter/material.dart';
import 'package:sports_game_reminder/data/player.dart';
import 'package:sports_game_reminder/screens/player_page.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:sports_game_reminder/data/league.dart';
import 'package:sports_game_reminder/app_theme.dart';
import 'package:sports_game_reminder/data/requests.dart';

//TODO; Option to view different roster from here
class RosterPage extends StatelessWidget {
  Widget _playerHeader(
      String pType, Color currColor, Color secCol, Team currTeam, BuildContext context) {
    return StickyHeader(
        header: Column(
          children: <Widget>[
            Container(
              height: 40,
              color: currColor,
              child: Center(
                  child: Container(
                      child:
                          Text(pType, style: TextStyle(color: Colors.white)))),
            ),
            Container(
              height: 25,
              color: Colors.grey.shade100,
              child: Row(
                children: <Widget>[
                  Expanded(child: Text("Name"), flex: 3),
                  Expanded(child: Text("Number")),
                  Expanded(child: Text("Position"))
                ],
              ),
            )
          ],
        ),
        content: Column(
            children: (pType != 'Goalies') 
                        ? currTeam.roster.skaters
                        .map((p) => Container(child: _playerRow(p, currTeam, currColor, secCol, context)))
                        .toList()
                        : currTeam.roster.goalies
                        .map((p) => Container(child: _playerRow(p, currTeam, currColor, secCol, context)))
                        .toList()
              ));
  }

  Widget _playerRow(Player p, Team t, Color c1, Color c2, BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, 'player', arguments: PageArgs(p, t, c1, c2));
        },
        child: Container(
          height: 40,
          child: Row(
            children: <Widget>[
              Expanded(child: Text(p.name), flex: 3),
              Expanded(child: Text(p.number)),
              Expanded(child: Text(p.posShort)),
            ],
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Team viewTeam = ModalRoute.of(context).settings.arguments;
    String name = Requests.teamFinder(viewTeam.name, 'full name');
    Color teamCol = Themes.teamColors[name][0];
    Color secCol = Themes.teamColors[name][1];

    return Scaffold(
        appBar: AppBar(
          title: Text(viewTeam.name),
          backgroundColor: teamCol,
        ),
        body: ListView(children: [
          _playerHeader('Skaters', teamCol, secCol, viewTeam, context),
          _playerHeader('Goalies', teamCol, secCol, viewTeam, context),
        ]));
  }
}
