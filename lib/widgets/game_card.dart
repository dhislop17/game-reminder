import 'package:flutter/material.dart';
import 'package:sports_game_reminder/data/schedule.dart';

class GameCard extends StatelessWidget {
  final Game _game;

  const GameCard(this._game);
//TODO: Implement changes for Postponed Case b/c of rona
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Text(
              (_game.status == 'Live') ? "Game In Progress" : "Final Score",
              style: Theme.of(context).textTheme.subtitle2,
              textAlign: TextAlign.center,
            ))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
                child: Text(
                  _game.away + " " + _game.awayRecord,
                  style: TextStyle(fontSize: 18),
                ),
                padding: EdgeInsets.only(left: 10)),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                _game.awayScore.toString(),
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
                child: Text(
                  _game.home + " " + _game.homeRecord,
                  style: TextStyle(fontSize: 18),
                ),
                padding: EdgeInsets.only(left: 10)),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                _game.homeScore.toString(),
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
