import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numus/constants/currencies.dart';
import 'package:numus/entities/settings.dart';
import 'package:numus/ui/wizard/currency_picker.dart';
import 'package:numus/ui/wizard/start_of_month_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

const String mailToUrl = 'mailto:office@themachine.dev?subject=Feedback%20for%20Numus';
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
        title: Text('Settings'),
      ),
      body: Container(
        // margin: EdgeInsets.all(10),
        child: ListView(
          children: [
            ListTile(
              title: Text('Currency'),
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
              title: Text('First day of the month'),
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
              title: Text('Leave Feedback'),
              leading: Icon(Icons.mail),
              onTap: () async {
                if(await canLaunch(mailToUrl)){
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
