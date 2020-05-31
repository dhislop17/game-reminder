import 'package:flutter/material.dart';
import 'package:sports_game_reminder/data/league.dart';
import 'package:sports_game_reminder/data/player.dart';
import 'package:sports_game_reminder/data/requests.dart';

class PageArgs {
  Player player;
  Team team;
  Color color1;
  Color color2;

  PageArgs(this.player, this.team, this.color1, this.color2);
}

Widget _statPage(PageArgs args, BuildContext context,
    {GoalieStat goalieStat, SkaterStat skaterStat}) {
  return Scaffold(
    body: Container(
      color: args.color2,
        child: Stack(
      children: <Widget>[
        Container(color: args.color1, height: 250),
        ListView(
          children: <Widget>[
            Card(
              elevation: 5,
              margin: EdgeInsets.only(top:96, left:32, right: 32, bottom: 10),
              child: Container(
                height: 210, //length of the card
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    Text(args.player.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Text(args.team.name),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                      Text(args.player.pos),
                      SizedBox(width: 10),
                      Text('#'+args.player.number.toString()),
                    ],)
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              margin: EdgeInsets.only(left: 32, right:32, bottom: 10),
              elevation: 5,
              child: Container(
                height: 210,
                child: (goalieStat != null) 
                  ? Column(
                    children: <Widget>[
                      SizedBox(height: 30),
                      Text("Current Season Stats", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('GP: ' + goalieStat.gamesPlayed.toString()),
                          Text('W: ' + goalieStat.wins.toString()),
                          Text('L: ' + goalieStat.losses.toString()),
                          Text('OTL: ' + goalieStat.ot.toString()),
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('SO: ' + goalieStat.gamesPlayed.toString()),
                          Text('Sv%: ' + goalieStat.svp.toString()),
                          Text('GAA: ' + goalieStat.gaa.toString()),
                        ],
                      )
                    ]
                  )
                  : Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text("Current Season Stats", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('GP: ' + skaterStat.gamesPlayed.toString()),
                          Text('G: ' +  skaterStat.goals.toString()),
                          Text('A: ' + skaterStat.assists.toString()),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Pts: ' + skaterStat.points.toString()),
                          Text('PIM: ' + skaterStat.penaltyMins.toString()),
                          Text('+/-: ' + skaterStat.plusMinus.toString()),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('PPG: ' + skaterStat.ppg.toString()),
                          Text('PPP: ' + skaterStat.ppp.toString()),
                          Text('SHG: ' + skaterStat.shg.toString()),
                          Text('SHP: ' + skaterStat.shp.toString()),
                        ],
                      ),
                    ],
                  ),
              ),
            )
          ],
        )
      ],
    )),
  );
}

class PlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PageArgs args = ModalRoute.of(context).settings.arguments;

    if (args.player.type == 'Goalie') {
      return FutureBuilder<GoalieStat>(
        future: Requests.fetchGoStat(args.player.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _statPage(args, context, goalieStat: snapshot.data);
          } else if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              body: Center(
                child: Text(
                  "Unable to load player data", 
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,),
              ),
            );
          }
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      );
    } else {
      return FutureBuilder<SkaterStat>(
        future: Requests.fetchSkStat(args.player.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _statPage(args, context, skaterStat: snapshot.data);
          } else if (snapshot.hasError) {
            print(args.player.id);
            print(snapshot.error.toString());
            return Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              body: Center(
                child: Text(
                  "Unable to load player data", 
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,),
              ),
            );
          }
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      );
    }
  }
}
