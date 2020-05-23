import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sports_game_reminder/screens/home.dart';
import 'package:sports_game_reminder/screens/pick_favs_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Landing Page Build");
    //load saved data (if any)
      return FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              bool status = snapshot.data.getBool('introComplete');
              //if there is saved data then go to the default team's calendar
              if (status != null && status) {
                return HomePage();
              } else { //otherwise go to the team picker page
                return PickFavsPage();
              }
            } else {
              return PickFavsPage();
            }
          });
  }
  
}
