import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sports_game_reminder/models/theme_model.dart';
import 'package:sports_game_reminder/models/user_model.dart';

class TeamPrefsList extends StatelessWidget{
  Widget _buildTeamTile(String teamName) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return RadioListTile(
        value: teamName,
        groupValue: model.mainTeamName,
        title: Text(teamName),
        onChanged: (String newName) {
          model.setMainTeam(newName);
          ThemeModel.of(context).setFavorite(newName);
        },
        selected: teamName == model.mainTeamName,
        activeColor: ThemeModel.of(context).teamPrimaryColor,
      );
    });
  }
  
  @override 
  Widget build(BuildContext context){
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        return _buildTeamTile(UserModel.of(context).favTeams[index]);
      },
      itemCount: UserModel.of(context).favTeams.length,
    );
  }
}