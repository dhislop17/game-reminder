import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_game_reminder/data/requests.dart';
import 'package:sports_game_reminder/data/schedule.dart';
import 'package:sports_game_reminder/screens/reminder_form.dart';


class CalendarModel extends Model {
  static CalendarModel of(BuildContext context) =>
      ScopedModel.of<CalendarModel>(context);

  DateTime _selectedDay;
  List _gamesOnDay;
  Schedule _schedule;
  bool _schedLoaded = false;
  String gameScore = "";
  List<Reminder> _reminders;

  CalendarModel(){
    _loadData();
  }

  DateTime get selectedDay => _selectedDay;
  List get gamesOnDay => _gamesOnDay;
  Schedule get schedule => _schedule;
  bool get schedLoaded => _schedLoaded;
  List get reminders => _reminders;

  void _loadData() async {
    print("Loading Reminder Data");
    final sp = await SharedPreferences.getInstance();

    int length = sp.getInt('rlength') ?? 0;
    _reminders = List();

    for (int i = 0; i < length; i++){
      Game game = Game.deserializeGame(sp.getString('game$i'));
      DateTime date = DateTime.parse(sp.getString('date$i'));
      String tempTime = sp.getString('time$i').substring(10,14);
      List temp = tempTime.split(':');
      TimeOfDay time = TimeOfDay(hour: int.parse(temp[0]), minute: int.parse(temp[1]));
      String msg = sp.getString("text$i");

      Reminder r = Reminder(game, date, time, msg);
      _reminders.add(r);
    }

  }

  void _saveData() async{
    print("Saving Reminder Data");
    final sp = await SharedPreferences.getInstance();
    sp.setInt('rlength', _reminders.length);
    for (int i = 0; i < _reminders.length; i++) {
      sp.setString('game$i', _reminders[i].game.serializeGame());
      sp.setString('date$i', _reminders[i].remindDate.toString());
      sp.setString('time$i', _reminders[i].remindTime.toString());
      sp.setString('text$i', _reminders[i].remindText.toString());
    }

  }

  ///Get the schedule from the API and convert it
  ///for use in the app
  void getSched(int id) {
    Requests.fetchSched(id).then((Schedule s) {
      _schedule = s;
      _schedule.gamesMap();  

      _selectedDay = new DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 0, 0);
      _gamesOnDay = _schedule.gamesList[_selectedDay] ?? ['No Games Today'];
      _schedLoaded = true;
      notifyListeners();
    });
  }

  ///Update the currently selected day in the calendar model
  void updateDay(DateTime day, List games) {
    _selectedDay = day;
    _gamesOnDay = _schedule.gamesList[_selectedDay] ?? ['No Games Today'];
    Game temp = schedule.getGame(_selectedDay);
    if (temp != null) {
      gameScore = temp.getScore();
    }
    else {
      gameScore = "";
    }
    notifyListeners();
  }

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    _reminders.sort((a,b) => a.toString().compareTo(b.toString()));
    _saveData();
    notifyListeners();
  }

  void removeReminder(Reminder reminder) {
    _reminders.remove(reminder);
    _reminders.sort((a,b) => a.toString().compareTo(b.toString()));
    _saveData();
    notifyListeners();
  }

  void removeAllReminders(){
    _reminders.clear();
    _saveData();
    notifyListeners();
  }

 /* Future selectNotif(String payload) async{
    
  }*/
}
