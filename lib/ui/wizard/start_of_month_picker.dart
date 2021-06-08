import 'package:numus/entities/settings.dart';
import 'package:numus/services/SharedPreferencesService.dart';
import 'package:numus/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StartOfMonthPickerWidget extends StatefulWidget {
  final bool isInWizard;

  StartOfMonthPickerWidget({this.isInWizard = true});

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
      SharedPreferencesService().setStartOfMonth(parsedValue).then((value) {
        settings.setStartOfMonth(parsedValue);
        if (widget.isInWizard) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false);
        } else {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).startOfMonthTitle),
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
                AppLocalizations.of(context).startOfMonthSubtitle,
                style: TextStyle(fontSize: 24),
              ),
            ),
            Center(
              child: Text(
                AppLocalizations.of(context).startOfMonthBody,
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
                          return AppLocalizations.of(context).startOfMonthError;
                        }
                        return null;
                      } catch (FormatException) {
                        return AppLocalizations.of(context).startOfMonthError;
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
