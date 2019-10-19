import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inf_sim/pages/splash.dart';
import 'package:inf_sim/util/ads.dart';
import 'package:inf_sim/util/localization.dart';

import 'data/data.dart';

void main() {
  FirebaseAdMob.instance.initialize(appId: getAdmobAppId());
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  runApp(App());
}

class App extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext c) {
    return MaterialApp(
        title: "Influencer Simulator",
        theme: ThemeData(primaryColor: Color(0xff039be5)),
        localizationsDelegates: [
          const CustomLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('de'),
        ],
        home: Splash());
  }

  @override
  void initState() {
    super.initState();

    // Save on exit
    WidgetsBinding.instance.addObserver(LifecycleEventHandler(suspendingCallBack: () async {
      await Data.saveToStorage();
    }));
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({this.suspendingCallBack});

  final AsyncCallback suspendingCallBack;

  bool mutex = false;

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.suspending:
        if (!mutex) {
          mutex = true;
          await suspendingCallBack();
          mutex = false;
        }
        break;
      case AppLifecycleState.resumed:
        break;
    }
  }
}
