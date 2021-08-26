import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:numus/constants/languages.dart';
import 'package:numus/ui/wizard/language_picker.dart';

class GetStartedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 150, left: 40, right: 40),
                child: Image.asset('assets/logo.png'),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Text(AppLocalizations.of(context).getStartedTitle, style: TextStyle(
                    fontSize: 24
                  ),),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: Text(AppLocalizations.of(context).getStartedBody,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    fontSize: 18,
                  ),),
                ),
              ),
            ],
          )
        ),
        Center(
          child: Container(
            margin: EdgeInsets.all(40),
            child: ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15)),
              ),
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LanguagePickerWidget(languages, true)))
              },
              child: Text(
                AppLocalizations.of(context).getStartedAction,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
