import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:inf_sim/data/data.dart';
import 'package:inf_sim/pages/wrapper.dart';
import 'package:inf_sim/util/flame_utils.dart';
import 'package:inf_sim/util/input.dart';
import 'package:inf_sim/util/localization.dart';
import 'package:inf_sim/util/time_utils.dart';

import 'home.dart';

class Splash extends StatelessWidget {
  static const DEBUG = false;

  int splashMinWaitTime = 3;

  @override
  Widget build(BuildContext c) {
    prepare();

    load(c);

    return Scaffold(
        body: Container(
            padding: EdgeInsets.all(24),
            child: Column(children: [
              Expanded(
                  child: Row(children: [
                    Expanded(
                        child: Text(
                      CL.of(c).l.infSim,
                      style: TextStyle(fontSize: 50.0),
                      textAlign: TextAlign.center,
                    ))
                  ]),
                  flex: 10),
              Expanded(child: Text(CL.of(c).l.createdBy, textAlign: TextAlign.start,), flex: 1)
            ])));
  }

  void prepare() {
    // Debug features
    if (DEBUG) {
      // Outline UI
      debugPaintSizeEnabled = true;
      // Zero splash waiting time
      splashMinWaitTime = 0;
    }

    // Set app to portrait only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Init input
    Input.init();
  }

  void load(BuildContext c) {
    /**
     * Splash gets shown for at least 3 seconds
     */
    var futures = <Future>[];
    futures.add(FlameUtils.loadAssets());
    futures.add(Data.loadFromStorage(c));
    futures.add(TimeUtils.waitAsync(splashMinWaitTime));
    Future.wait(futures).then((results) {
      Navigator.pushReplacement(
        c,
        MaterialPageRoute(builder: (context) => Wrapper()),
      );
    }, onError: (e) {
      print(e);
    });
  }
}
