import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:sports_game_reminder/models/calendar_model.dart';
import 'package:sports_game_reminder/screens/reminder_form.dart';

///Class for the page that displays all current and past reminders
class ReminderPage extends StatelessWidget {
  _buildReminderCard(Reminder reminder) {
    return Builder(
      builder: (context) => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 15,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(1),
              child: Text(reminder.game.getHome(),
                  style: Theme.of(context).textTheme.subtitle2),
            ),
            Padding(
              padding: const EdgeInsets.all(1),
              child: Text(reminder.game.getAway(),
                  style: Theme.of(context).textTheme.subtitle2),
            ),
            Divider(height: 10),
            Padding(
              padding: const EdgeInsets.all(1),
              child: (reminder.remindText.isEmpty)
                  ? Text("No Reminder Text", style: Theme.of(context).textTheme.bodyText2)
                  : Text(reminder.remindText, style: Theme.of(context).textTheme.bodyText2),
            ),
            Padding(
              padding: const EdgeInsets.all(2),
              child: Text(
                "Reminder set for " +
                    DateFormat.yMd().format(reminder.remindDate).toString() +
                    " at " +
                    reminder.remindTime.format(context),
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    //.merge(TextStyle(fontStyle: FontStyle.italic)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2),
              child: Text(
                "Scheduled start at " +
                    DateFormat.yMd().add_jm().format(reminder.game.startTime),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .merge(TextStyle(color: Colors.black.withOpacity(.4))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Reminders"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.clear_all),
              onPressed: () {
               CalendarModel.of(context).removeAllReminders();
              },
              tooltip: "Delete All Reminders",
            ),
            IconButton(
              icon: Icon(Icons.alarm_on),
              onPressed: () {},
              tooltip: "View Completed Reminders",
            ),
          ],
        ),
        body: ScopedModelDescendant<CalendarModel>(
            builder: (context, child, model) {
          if (CalendarModel.of(context).reminders.length == 0) {
            return Container(
                child: Center(
                    child: Text('No set reminders',
                        style: Theme.of(context).textTheme.headline6)));
          } else {
            if (MediaQuery.of(context).orientation == Orientation.portrait) {
              return ListView.builder(
                  itemCount: CalendarModel.of(context).reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = CalendarModel.of(context).reminders[index];
                    return Dismissible(
                        key: UniqueKey(),//Key(reminder.toString()),
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
