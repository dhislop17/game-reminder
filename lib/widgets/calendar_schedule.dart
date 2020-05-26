import 'package:flutter/material.dart';
import 'package:sports_game_reminder/screens/reminder_form.dart';

import 'package:table_calendar/table_calendar.dart';

import 'package:sports_game_reminder/models/calendar_model.dart';
import 'package:sports_game_reminder/models/theme_model.dart';
import 'package:sports_game_reminder/widgets/game_card.dart';

class CalendarSchedule extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CalendarScheduleState();
}

class CalendarScheduleState extends State<CalendarSchedule> {
  DateTime day;
  List<String> games;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Column(
        children: <Widget>[
          new CustomCalendar(null),
          SizedBox(
              height: 18,
              child: Container(color: ThemeModel.of(context).teamPrimaryColor)),
          new GameCardList(),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          Expanded(
              child: CustomCalendar(MediaQuery.of(context).size.height * .10)),
          GameCardList()
        ],
      );
    }
  }
}

///Class for the game card object that
///is displayed under the calendar
class GameCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
          children: CalendarModel.of(context)
              .gamesOnDay
              .map((event) => Container(
                height: 100,
                  child: Card(
                      borderOnForeground: false,
                      elevation: 5,
                      child: (event is String)
                          ? Center(
                              child: Text(event,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18)))
                          : (event.status != 'Preview')
                              ? GameCard(event)
                              : ListTile(
                                  title: Text(event.toString()),
                                  subtitle: Text(event.getNormalTime()),
                                  leading: Icon(Icons.add_alert),
                                  enabled: true,
                                  onTap: () async {
                                    final text = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return CreateReminderPage(event);
                                            },
                                            fullscreenDialog: true));
                                    if (text != null)
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(content: Text(text)));
                                  },
                                  onLongPress: () {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                            'Tap to add a reminder for this game')));
                                  },
                                ))))
              .toList()),
    );
  }
}


///Class for the calendar widget
class CustomCalendar extends StatefulWidget {
  final size;
  const CustomCalendar(this.size);

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

//TODO: Possibly Make Stateless
class _CustomCalendarState extends State<CustomCalendar> {
  Color _colorPicker() {
    Color result;
    if (ThemeModel.of(context).teamSecondaryColor == Colors.white) {
      result = Colors.blueGrey;
    } else if (ThemeModel.of(context).teamSecondaryColor == Colors.black) {
      result = Colors.grey;
    } else {
      result = ThemeModel.of(context).teamSecondaryColor;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      selectedDay: CalendarModel.of(context).selectedDay,
      rowHeight: widget.size,
      events: CalendarModel.of(context).schedule.gamesList,
      headerVisible: true,
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonShowsNext: false,
      ),
      calendarStyle: CalendarStyle(
        markersColor: ThemeModel.of(context).teamPrimaryColor,
        selectedColor: _colorPicker(),
      ),
      onDaySelected: (day, games) {
        CalendarModel.of(context).updateDay(day, games);
      },
    );
  }
}
