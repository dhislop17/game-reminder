import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sports_game_reminder/data/requests.dart';
import 'package:sports_game_reminder/models/calendar_model.dart';
import 'package:sports_game_reminder/models/user_model.dart';
import 'package:sports_game_reminder/widgets/team_prefs_list.dart';

class PickFavsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PickFavsPageState();
}

class PickFavsPageState extends State<PickFavsPage>
    with SingleTickerProviderStateMixin {
  String selectedTeam;
  List<String> teams = Requests.nameToAbbr.values.toList();
  TabController _tabController;
  int tabPos = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_updateIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateIndex(){
    setState(() {
     tabPos = _tabController.index; 
    });
  }

  Widget _buildTeamsRow(String teamName) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return ListTile(
          title: Text(teamName, style: TextStyle(fontSize: 16)),
          trailing: Icon(
            (model.favTeams != null && model.favTeams.contains(teamName))
                ? Icons.favorite
                : Icons.favorite_border,
            color: (model.favTeams != null && model.favTeams.contains(teamName))
                ? Colors.red
                : null,
          ),
          onTap: () {
            selectedTeam = teamName;
            if (model.favTeams != null && model.favTeams.contains(teamName)) {
              model.removeTeam(selectedTeam);
            } else {
              model.addTeam(selectedTeam);
            }
          });
    });
  }

  Widget _buildTeamsList() {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) => Divider(),
      itemCount: teams.length,
      itemBuilder: (context, index) {
        return _buildTeamsRow(teams[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Fav Page Build");
   // return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text("Select Teams to Follow"),
          bottom: TabBar(
            tabs: [Tab(text: "All Teams"), Tab(text: "Set Primary Team")],
            controller: _tabController
          ),
          automaticallyImplyLeading: (tabPos == 1) ? false : true,
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[_buildTeamsList(), TeamPrefsList()],
        ),
        floatingActionButton: (tabPos == 1)
            ? FloatingActionButton.extended(
                label: Text("Continue"),
                icon: Icon(Icons.arrow_forward),
                onPressed: () async {
                  var prefs = await SharedPreferences.getInstance();
                  //model.saveData();
                  UserModel.of(context).saveData();
                  prefs.setBool('introComplete', true);
                  if (Navigator.canPop(context)){
                    Navigator.popUntil(context, ModalRoute.withName('settings'));
                  }
                  else {
                    //UserModel.of(context).getLeague();
                    CalendarModel.of(context).getSched(
                      UserModel.of(context).currentTeam.id
                    );
                    //CalendarModel.of(context).getSched(model.currentTeam.id);
                    Navigator.pushReplacementNamed(context, 'app');
                  }
                },
              )
            : null,
      );
   // });
  }
}
