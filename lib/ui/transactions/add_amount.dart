import 'package:experiment/constants/date.dart';
import 'package:experiment/entities/category.dart';
import 'package:experiment/entities/operation.dart';
import 'package:experiment/services/OperationsService.dart';
import 'package:experiment/ui/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AddAmountScreen extends StatelessWidget {
  final Category category;

  AddAmountScreen({this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add ${category.name} amount')),
      body: Container(
        child: AmountWidget(category),
      ),
    );
  }
}

class AmountWidget extends StatefulWidget {
  final Category category;

  AmountWidget(this.category);

  @override
  _AmountWidgetState createState() => _AmountWidgetState();
}

class _AmountWidgetState extends State<AmountWidget> {
  @override
  Widget build(BuildContext context) {
    return CalculatorWidget(widget.category);
  }
}

class CalculatorWidget extends StatefulWidget {
  final Category category;

  CalculatorWidget(this.category);

  @override
  _CalculatorWidgetState createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  String value = '0';
  DateTime selectedDate = DateTime.now();

  void onKeyPress(String character) {
    if (value.length > 10) {
      return;
    }

    if ((character == ',' || character == '.') &&
        (value.contains(',') || value.contains('.'))) {
      return;
    }

    if (character == 'AC') {
      setState(() {
        value = '0';
      });
    } else if (value == '0') {
      setState(() {
        value = character;
      });
    } else {
      setState(() {
        value = value + character;
      });
    }
  }

  void onBackspacePress() {
    if (value.length > 1) {
      setState(() {
        value = value.substring(0, value.length - 1);
      });
    } else {
      setState(() {
        value = '0';
      });
    }
  }

  void onDonePress() {
    if (value == '0') {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('The ammount cannot be 0')));
      return;
    }

    Operation operation = Operation(
        amount: double.parse(value),
        category: widget.category,
        createdAt: selectedDate.millisecondsSinceEpoch);

    OperationsService().persistOperation(operation).then((value) =>
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false));
  }

  void showDateTimePicker() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019),
      lastDate: DateTime(2025),
    );
    if (date != null) {
      TimeOfDay time =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      setSelectedDate(
          DateTime(date.year, date.month, date.day, time.hour, time.minute));
    }
  }

  void setSelectedDate(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
  }
  
  String formatDate(){
    final DateFormat dateFormatter = DateFormat(dateFormat);
    return dateFormatter.format(selectedDate);
  }

  String formatTime(){
    final DateFormat timeFormatter = DateFormat(timeFormat);
    return timeFormatter.format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            margin: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: 50),
                ),
                Text(
                  ' lei',
                  style: TextStyle(fontSize: 50),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    CalculatorKey(
                      character: '7',
                      onPress: onKeyPress,
                    ),
                    CalculatorKey(
                      character: '4',
                      onPress: onKeyPress,
                    ),
                    CalculatorKey(
                      character: '1',
                      onPress: onKeyPress,
                    ),
                    CalculatorKey(
                      character: ',',
                      onPress: onKeyPress,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    CalculatorKey(
                      character: '8',
                      onPress: onKeyPress,
                    ),
                    CalculatorKey(
                      character: '5',
                      onPress: onKeyPress,
                    ),
                    CalculatorKey(
                      character: '2',
                      onPress: onKeyPress,
                    ),
                    CalculatorKey(
                      character: '0',
                      onPress: onKeyPress,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    CalculatorKey(
                      character: '9',
                      onPress: onKeyPress,
                    ),
                    CalculatorKey(
                      character: '6',
                      onPress: onKeyPress,
                    ),
                    CalculatorKey(
                      character: '3',
                      onPress: onKeyPress,
                    ),
                    CalculatorKey(
                      character: '.',
                      onPress: onKeyPress,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CalculatorAction(
                      icon: Icon(Icons.backspace_outlined),
                      onPress: onBackspacePress,
                    ),
                    DateKey(
                      date: formatDate(),
                      time: formatTime(),
                      onPress: showDateTimePicker,
                    ),
                    CalculatorAction(
                      flex: 2,
                      icon: Icon(Icons.done),
                      onPress: onDonePress,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CalculatorKey extends StatelessWidget {
  final Function onPress;

  final String character;

  final int flex;

  CalculatorKey({this.character, this.onPress, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: EdgeInsets.all(5),
        child: OutlineButton(
          child: Text(
            character,
            style: TextStyle(fontSize: 30),
          ),
          onPressed: () {
            onPress(character);
          },
        ),
      ),
    );
  }
}

class DateKey extends StatelessWidget {
  final Function onPress;

  final String date;
  final String time;

  DateKey({this.date, this.time, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(5),
        child: OutlineButton(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                date,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                time,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          onPressed: onPress,
        ),
      ),
    );
  }
}

class CalculatorAction extends StatelessWidget {
  final Function onPress;

  final Icon icon;

  final int flex;

  CalculatorAction({this.icon, this.onPress, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: EdgeInsets.all(5),
        child: OutlineButton(
          disabledBorderColor: Colors.green,
          child: icon,
          onPressed: onPress,
        ),
      ),
    );
  }
}
