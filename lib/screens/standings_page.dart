import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:sports_game_reminder/app_theme.dart';
import 'package:sports_game_reminder/data/league.dart';
import 'package:sports_game_reminder/models/user_model.dart';

//TODO: Consider making each row tappable which would take you to that team's roster
//TODO: For Wildcard in Div mode put some indicicator as well as line after 3rd place
//TODO: For Conference put line after 8th

class _ListHeader extends SliverPersistentHeaderDelegate {
  _ListHeader(this._child, this.minHeight, this.maxHeight);

  final Widget _child;
  final double minHeight;
  final double maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: _child);
  }

  @override
  double get maxExtent => math.max(minHeight, maxHeight);

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(_ListHeader oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        _child != oldDelegate._child;
  }
}

class StandingsPage extends StatelessWidget {
  ///Team row rank widget
  Widget _rowBuilder(Team team, String rankType) {
    return Row(children: <Widget>[
      Expanded(
        child: Text(team.nameWithRank(rankType)),
        flex: 5,
      ),
      Expanded(child: Text(team.teamStat.gamesPlayed.toString())),
      Expanded(child: Text(team.teamStat.wins.toString())),
      Expanded(child: Text(team.teamStat.losses.toString())),
      Expanded(child: Text(team.teamStat.ot.toString())),
      Expanded(child: Text(team.teamStat.points.toString())),
      Expanded(child: Text(team.teamStat.streak.toString())),
    ]);
  }

  ///Standings stat header widget
  Widget _secHeader({String standType}) {
    return Row(
      children: <Widget>[
        Expanded(
            child: (standType != null) ? Text(standType) : Text('Team'),
            flex: 5),
        Expanded(child: Text("GP")),
        Expanded(child: Text("W")),
        Expanded(child: Text("L")),
        Expanded(child: Text("OTL")),
        Expanded(child: Text("Pts")),
        Expanded(child: Text("Strk")),
      ],
    );
  }

  ///Section Header w/ Conference color Widget
  Widget _confListHeader(String conf, UserModel uModel,
      [bool divMode, String div]) {
    Color confCol;
    String longName = conf + " Conference";
    String divNameIn;
    int divCode;

    if (divMode != null) {
      if (div != null) {
        divCode = uModel.currentTeam.divCode();
        divNameIn = div;
      } else {
        if (conf == 'Eastern') {
          divNameIn = 'Metropolitan';
          divCode = 0;
        } else {
          divNameIn = 'Central';
          divCode = 2;
        }
      }
    }

    if (conf == 'Eastern') {
      confCol = Themes.eastRed;
    } else {
      confCol = Themes.westBlue;
    }

    return StickyHeader(
      header: Column(children: [
        Container(
          height: 45,
          color: confCol,
          child: Center(child: Text(longName)),
        ),
        Container(
          color: Colors.grey.shade300,
          height: 30,
          child: (divMode != null)
              ? _secHeader(standType: divNameIn)
              : _secHeader(),
        ),
      ]),
      content: Column(
          children: (divMode == null)
              ? uModel.league.conferences[conf].teams
                  .map((team) => InkWell(
                        onTap: () {},
                        child: Container(
                            padding: EdgeInsets.only(bottom: 15),
                            child: _rowBuilder(team, 'conf')),
                      ))
                  .toList()
              : uModel.league.divisions[divCode].teams
                  .map((team) => InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.only(bottom: 15),
                          child: _rowBuilder(team, 'div'),
                        ),
                      ))
                  .toList()),
    );
  }

  Widget _divHeader(String name, UserModel uModel){
    int divCode = uModel.league.divisions.indexWhere((division) => division.name == name);

    return StickyHeader(
      header: Container(
        color: Colors.grey.shade300,
        height: 30,
        child:_secHeader(standType: name)
      ),
      content: Column(
        children: uModel.league.divisions[divCode].teams
          .map((team) => InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.only(bottom: 15),
              child: _rowBuilder(team, 'div'),
            ),
          ))
          .toList() 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, uModel) {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Standings"),
              bottom: TabBar(
                tabs: [
                  Tab(text: "Divison"),
                  Tab(text: "Conference"),
                  Tab(text: 'League')
                ],
              ),
            ),
            body: TabBarView(children: [
              ListView(
                  children: (uModel.currentTeam.conf == 'Eastern')
                      ? ((uModel.currentTeam.div == 'Atlantic')
                          ? [
                              _confListHeader('Eastern', uModel, true, 'Atlantic'),
                              _divHeader('Metropolitan', uModel),
                              _confListHeader('Western', uModel, true),
                              _divHeader('Pacific', uModel),
                            ]
                          : [
                              _confListHeader('Eastern', uModel, true),
                              _divHeader('Atlantic', uModel),
                              _confListHeader('Western', uModel, true),
                              _divHeader('Pacific', uModel),
                            ])
                      : ((uModel.currentTeam.div == 'Pacific')
                          ? [
                              _confListHeader('Western', uModel, true, 'Pacific'),
                              _divHeader('Central', uModel),
                              _confListHeader('Eastern', uModel, true),
                              _divHeader('Atlantic', uModel),

                            ]
                          : [
                              _confListHeader('Western', uModel, true),
                              _divHeader('Pacific', uModel),
                              _confListHeader('Eastern', uModel, true),
                              _divHeader('Atlantic', uModel),
                            ])
              ),
              ListView(
                  children: (uModel.currentTeam.conf == 'Eastern')
                      ? [
                          _confListHeader('Eastern', uModel),
                          _confListHeader('Western', uModel)
                        ]
                      : [
                          _confListHeader('Western', uModel),
                          _confListHeader('Eastern', uModel)
                        ]),
              CustomScrollView(
                slivers: <Widget>[
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _ListHeader(
                        Container(
                            color: Colors.grey.shade300, child: _secHeader()),
                        30,
                        45),
                  ),
                  SliverFixedExtentList(
                    itemExtent: 45,
                    delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            _rowBuilder(uModel.league.teams[index], 'league'),
                        childCount: uModel.league.teams.length),
                  )
                ],
              ),
            ])),
      );
    });
  }
}
