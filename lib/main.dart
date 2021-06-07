import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:numus/entities/settings.dart';
import 'package:numus/services/AdState.dart';
import 'package:numus/services/DatabaseProvider.dart';
import 'package:numus/services/SharedPreferencesService.dart';
import 'package:numus/ui/home/home_screen.dart';
import 'package:numus/ui/wizard/get_started.dart';
import 'package:provider/provider.dart';

import 'constants/application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
  await DatabaseProvider().database;
  Settings settings = await SharedPreferencesService().getSettings();
  Widget first;
  if (settings.startOfMonth != null && settings.currency != null) {
    first = HomeScreen();
  } else {
    first = GetStartedWidget();
  }
  runApp(MyApp(
    first,
    settings: settings,
  ));
}

class MyApp extends StatelessWidget {
  final Widget first;
  final Settings settings;

  MyApp(this.first, {this.settings});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    FirebaseAnalytics analytics = FirebaseAnalytics();
    final initFuture = MobileAds.instance.initialize();
    final adState = AdState(initFuture);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => settings),
        Provider(
          create: (_) => adState,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: first,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
      ),
    );
  }
}
