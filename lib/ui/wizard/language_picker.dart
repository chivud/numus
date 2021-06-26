import 'package:flutter/material.dart';
import 'package:numus/constants/currencies.dart';
import 'package:numus/entities/language.dart';
import 'package:numus/entities/settings.dart';
import 'package:numus/services/SharedPreferencesService.dart';
import 'package:numus/ui/wizard/currency_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguagePickerWidget extends StatefulWidget {
  final List<Language> languages;
  final bool isInWizard;

  const LanguagePickerWidget(this.languages, this.isInWizard);

  @override
  _LanguagePickerWidgetState createState() => _LanguagePickerWidgetState();
}

class _LanguagePickerWidgetState extends State<LanguagePickerWidget> {
  List<Language> filteredList;

  void filterList({String search}) {
    if (search != null) {
      filteredList = widget.languages
          .where((Language language) =>
              language.name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    } else {
      filteredList = widget.languages;
    }
  }

  @override
  void initState() {
    super.initState();
    filterList();
  }

  selectLanguage(index, Settings settings) {
    SharedPreferencesService()
        .setSelectedLanguage(filteredList[index])
        .then((value) {
      settings.setLanguage(filteredList[index]);
      AppLocalizations.delegate.load(Locale(filteredList[index].code));
      if (widget.isInWizard) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CurrencyPickerWidget(currencies)));
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).languagePickerSelect),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15), hintText: AppLocalizations.of(context).languageSearch + '...'),
            onChanged: (value) {
              setState(() {
                filterList(search: value);
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              key: Key('currency_list'),
              shrinkWrap: true,
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: SvgPicture.asset(
                    'assets/flags/${filteredList[index].flag}',
                    width: 40,
                  ),
                  title: Text(filteredList[index].name),
                  onTap: () => selectLanguage(index, settings),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
