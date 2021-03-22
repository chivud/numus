import 'package:experiment/entities/settings.dart';
import 'package:experiment/services/SharedPreferencesService.dart';
import 'package:experiment/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartOfMonthPickerWidget extends StatefulWidget {
  @override
  _StartOfMonthPickerWidgetState createState() =>
      _StartOfMonthPickerWidgetState();
}

class _StartOfMonthPickerWidgetState extends State<StartOfMonthPickerWidget> {
  final _formKey = GlobalKey<FormState>();
  final _textFiledController = TextEditingController();

  void saveValue(Settings settings) {
    if (_formKey.currentState.validate()) {
      int parsedValue = int.parse(_textFiledController.text);
      SharedPreferencesService()
          .setStartOfMonth(parsedValue)
          .then((value) {
            settings.setStartOfMonth(parsedValue);
            return Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter start of month'),
      ),
      body: Container(
        margin: EdgeInsets.only(
          top: 60,
          left: 10,
          right: 10,
        ),
        child: Column(
          children: [
            Center(
              child: Text(
                'Enter first day of the month',
                style: TextStyle(fontSize: 24),
              ),
            ),
            Center(
              child: Text(
                'It is usually the day you receive your salary',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Center(
              child: Container(
                width: 250,
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _textFiledController,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                    onEditingComplete: () => saveValue(settings),
                    validator: (value) {
                      try {
                        int intValue = int.parse(value);
                        if (intValue < 1 || intValue > 30) {
                          return 'Value must be between 1 and 30';
                        }
                        return null;
                      } catch (FormatException) {
                        return 'Value must be between 1 and 30';
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
