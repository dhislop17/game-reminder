import 'package:flutter/material.dart';
import 'package:sports_game_reminder/app_theme.dart';
import 'package:sports_game_reminder/data/league.dart';
import 'package:sports_game_reminder/data/requests.dart';
import 'package:sports_game_reminder/models/user_model.dart';

class TeamListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose a Roster to View"),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: UserModel.of(context).league.sortedTeams.length,
        itemBuilder: (context, index) {
          Team currTeam = UserModel.of(context).league.sortedTeams[index];
          String short = Requests.teamFinder(currTeam.name, 'full name');
          return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Themes.teamColors[short][0],
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.popAndPushNamed(context, 'rosters', arguments: currTeam);
              },
              title: Text(currTeam.name, style: TextStyle(color: Colors.white),),
            ),
          );
        },
      ),
    );
  }
}
