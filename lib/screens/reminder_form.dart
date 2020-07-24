import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import 'package:sports_game_reminder/data/schedule.dart';
import 'package:sports_game_reminder/models/calendar_model.dart';

class Reminder {
  Game game;
  DateTime remindDate; //possibly multiple
  TimeOfDay remindTime;
  String remindText;
  bool inPast;
  //int id;

  Reminder(this.game, this.remindDate, this.remindTime, this.remindText);

  @override
  String toString() {
    return "Reminder set for " +
        DateFormat.yMd().format(remindDate).toString() +
        " at " +
        remindTime.toString();
  }
/*
  void incID(){
    id++;
  }
  */
}

class CreateReminderPage extends StatefulWidget {
  final Game toRemind;

  CreateReminderPage(this.toRemind);

  @override
  _CreateReminderPageState createState() => _CreateReminderPageState();
}

class _CreateReminderPageState extends State<CreateReminderPage> {
  final _formKey = GlobalKey<FormState>();
  FlutterLocalNotificationsPlugin notify;
  Reminder temp = new Reminder(null, null, null, null);

  @override
  void initState() {
    super.initState();

    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var settings = new InitializationSettings(android, iOS);
    notify = new FlutterLocalNotificationsPlugin();
    notify.initialize(settings /*, onSelectNotification: selectNotif*/);
  }

  Future schedNotif() async {
    var time = temp.remindDate;
    var rTime = temp.remindTime;
    var time2 =
        new DateTime(time.year, time.month, time.day, rTime.hour, rTime.minute);
    print(time2.toLocal().toString());
    var channelSpecs = new AndroidNotificationDetails(
        'hockey_remind',
        "Hockey Reminder Notifications",
        'A notification for when a reminder is triggered',
        autoCancel: false,
        importance: Importance.Max,
        priority: Priority.High,
        ticker: "ticker",
        enableLights: true,
        enableVibration: true,
        channelShowBadge: true);
    var iOS = new IOSNotificationDetails();
    NotificationDetails details = NotificationDetails(channelSpecs, iOS);
    await notify.schedule(
        0, temp.game.toString(), temp.remindText, time2, details);
  }

  Future showNotif() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'hockey_remind',
        'Hockey Reminder Notifications',
        'A notification for when a reminder is triggered',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await notify.show(0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future check() async {
    var pending = await notify.pendingNotificationRequests();
    for (var req in pending) {
      print(req.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create New Reminder"),
        ),
        body: ReminderForm(game: widget.toRemind, formKey: _formKey, inp: temp),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              final FormState state = _formKey.currentState;
              state.save();
              CalendarModel.of(context).addReminder(temp);
              schedNotif();
              check();
              //showNotif();
              Navigator.of(context).pop('Successfully created reminder');
            },
          ),
        ));
  }
}

class DateFormField extends FormField<DateTime> {
  DateFormField(
      {@required BuildContext context,
      @required Game game,
      FormFieldSetter<DateTime> onSaved,
      FormFieldValidator<DateTime> validator,
      DateTime initialValue,
      bool autoValidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autoValidate,
            builder: (FormFieldState<DateTime> state) {
              return ListTile(
                leading: Icon(Icons.calendar_today),
                title: InkWell(
                  onTap: () async {
                    final val = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        initialDate: DateTime.now(),
                        lastDate: game.startTime);
                    if (val != null) {
                      state.didChange(val);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(DateFormat.yMd().format(state.value)),
                  ),
                ),
              );
            });
}

class TimeFormField extends FormField<TimeOfDay> {
  TimeFormField(
      {@required BuildContext context,
      @required Game game,
      FormFieldSetter<TimeOfDay> onSaved,
      FormFieldValidator<TimeOfDay> validator,
      TimeOfDay initialValue,
      bool autovalidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autovalidate,
            builder: (FormFieldState<TimeOfDay> state) {
              return ListTile(
                leading: Icon(Icons.access_time),
                title: InkWell(
                  onTap: () async {
                    final val = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: 0, minute: 0));
                    if (val != null) {
                      state.didChange(val);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(state.value.format(context)),
                  ),
                ),
              );
            });
}

class ReminderForm extends StatefulWidget {
  final Game game;
  final Key formKey;
  final Reminder inp;

  const ReminderForm({this.game, this.formKey, this.inp});

  @override
  _ReminderFormState createState() => _ReminderFormState(game, formKey, inp);
}

class _ReminderFormState extends State<ReminderForm> {
  final _textController = TextEditingController();
  final formKey;
  final Game toRemind;
  final Reminder inp;

  _ReminderFormState(this.toRemind, this.formKey, this.inp);

  double convertTime(dynamic time) {
    return time.hour + time.minute / 60;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(toRemind.toString()),
            subtitle: Text('Scheduled start at ' +
                DateFormat.yMd()
                    .add_jm()
                    .format(toRemind.startTime)
                    .toString()),
          ),
          Divider(),
          DateFormField(
            context: context,
            game: toRemind,
            initialValue: DateTime.now(),
            onSaved: (date) {
              inp.remindDate = date;
              inp.game = toRemind;
            },
          ),
          TimeFormField(
            context: context,
            game: toRemind,
            initialValue: TimeOfDay.fromDateTime(DateTime.now()),
            onSaved: (time) => inp.remindTime = time,
            /*validator: (time) {
              double start = convertTime(toRemind.startTime);
              double setTime = convertTime(time);              

              if (setTime > start)
                return 'Please select a time before the game start time';
              
            },*/
          ),
          Divider(),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Optional Reminder Text",
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan)),
            ),
            controller: _textController,
            onSaved: (text) => inp.remindText = text,
          ),
        ],
      ),
    );
  }
}
