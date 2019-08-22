import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:sports_game_reminder/models/calendar_model.dart';
import 'package:sports_game_reminder/screens/reminder_form.dart';

class ReminderPage extends StatelessWidget {
  //Pick a day and then something comes up and says set reminder or
//Just make cards tappable
  _buildReminderCard(Reminder reminder) {
    return Builder(
      builder: (context) => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 15,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(reminder.game.toString(),
                  style: Theme.of(context).textTheme.subtitle),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Reminder set for " +
                    DateFormat.yMd().format(reminder.remindDate).toString() +
                    " at " +
                    reminder.remindTime.format(context),
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .merge(TextStyle(fontStyle: FontStyle.italic)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Text(
                "Scheduled start at " +
                    DateFormat.yMd().add_jm().format(reminder.game.startTime),
                style: Theme.of(context).textTheme.body2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(CalendarModel.of(context).reminders.length);
    return Scaffold(
        appBar: AppBar(
          title: Text("Reminders"),
        ),
        body: ScopedModelDescendant<CalendarModel>(
            builder: (context, child, model) {
          if (CalendarModel.of(context).reminders.length == 0) {
            return Container(
                child: Center(
                    child: Text('No set reminders',
                        style: Theme.of(context).textTheme.title)));
          } else {
            if (MediaQuery.of(context).orientation == Orientation.portrait) {
              return ListView.builder(
                  itemCount: CalendarModel.of(context).reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = CalendarModel.of(context).reminders[index];
                    return Dismissible(
                        key: Key(reminder.toString()),
                        background: Container(color: Colors.red),
                        onDismissed: (direction) {
                          CalendarModel.of(context).removeReminder(reminder);
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Deleted ${reminder.toString()}")));
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: _buildReminderCard(
                                CalendarModel.of(context).reminders[index])));
                  });
            } else {
              return Padding(
                  padding: EdgeInsets.only(left: 100, right: 100),
                  child: ListView.builder(
                    itemCount: CalendarModel.of(context).reminders.length,
                    itemBuilder: (context, index) => _buildReminderCard(
                        CalendarModel.of(context).reminders[index]),
                  ));
            }
          }
        }));
  }
}
