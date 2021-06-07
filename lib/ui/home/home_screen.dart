import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:numus/services/AdState.dart';
import 'package:numus/ui/charts/charts.dart';
import 'package:numus/ui/home/balance.dart';
import 'package:numus/ui/home/transaction_list.dart';
import 'package:numus/ui/settings/settings.dart';
import 'package:numus/ui/transactions/select_category.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final bool cameFromAddAmount;

  HomeScreen({this.cameFromAddAmount: false});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  InterstitialAd ad;
  bool isAdReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((value) => InterstitialAd.load(
        adUnitId: adState.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd adInstance) {
            setState(() {
              ad = adInstance;
              isAdReady = true;
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        )));
  }

  @override
  Widget build(BuildContext context) {
    print('cameFromAddAmount');
    print(widget.cameFromAddAmount);
    if (widget.cameFromAddAmount && isAdReady) {
      ad.show();
    }
    return Scaffold(
      appBar: AppBar(title: Text('Overview')),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BalanceWidget(),
              Expanded(
                child: TransactionListWidget(),
              )
            ],
          )),
      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectCategoryWidget()));
            },
            child: Icon(Icons.add)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10),
                  primary: Colors.black),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChartsWidget()));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.pie_chart), Text('Charts')],
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10),
                  primary: Colors.black),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsWidget()));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.settings),
                  Text('Settings'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
