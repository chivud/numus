import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numus/constants/currencies.dart';
import 'package:numus/constants/languages.dart';
import 'package:numus/entities/settings.dart';
import 'package:numus/ui/wizard/currency_picker.dart';
import 'package:numus/ui/wizard/language_picker.dart';
import 'package:numus/ui/wizard/start_of_month_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String mailToUrl =
    'mailto:office@themachine.dev?subject=Feedback%20for%20Numus';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settingsTitle),
      ),
      body: Container(
        child: ListView(
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context).settingsCurrency),
              leading: Icon(Icons.payments),
              trailing: Text(
                settings.currency.symbol,
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CurrencyPickerWidget(
                              currencies,
                              isInWizard: false,
                            )));
              },
            ),
            Divider(),
            ListTile(
              title: Text(AppLocalizations.of(context).settingsFirstDay),
              leading: Icon(Icons.calendar_today),
              trailing: Text(
                settings.startOfMonth.toString(),
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StartOfMonthPickerWidget(
                              isInWizard: false,
                            )));
              },
            ),
            Divider(),
            ListTile(
              title: Text(AppLocalizations.of(context).settingsLanguage),
              leading: Icon(Icons.language),
              trailing: Text(
                settings.language.name,
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LanguagePickerWidget(languages, false)));
              },
            ),
            Divider(),
            ListTile(
              title: Text(AppLocalizations.of(context).settingsFeedback),
              leading: Icon(Icons.mail),
              onTap: () async {
                if (await canLaunch(mailToUrl)) {
                  await launch(mailToUrl);
                }
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
