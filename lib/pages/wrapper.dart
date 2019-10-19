import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inf_sim/util/ads.dart';

import 'games/balloon_pop.dart';
import 'games/like_tiles.dart';
import 'games/space_ship.dart';
import 'home.dart';

class Wrapper extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WrapperState();
}

class WrapperState extends State<Wrapper> {
  static const int HOME = 0;
  static const int LIKE_TILES = 1;
  static const int BALLOON_POP = 2;
  static const int SPACE_SHIP = 3;

  Home home;

  BannerAd adBanner;

  int index = HOME;

  WrapperState() {
    adBanner = BannerAd(
      adUnitId: getAdmobBannerAdUnitId(),
      size: AdSize.banner
    );
    adBanner.load();
    adBanner.show(anchorType: AnchorType.top, anchorOffset: 4);

    home = Home(this);
  }

  @override
  void dispose() {
    super.dispose();
    adBanner.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Stack(children: [
      Column(children: [
        Padding(padding: EdgeInsets.only(top: 58)),
        Expanded(child: getWidgetFromIndex())
      ]),
      Container(
          color: Colors.white,
          height: 58),
    ])));
  }

  Widget getWidgetFromIndex() {
    switch (index) {
      case HOME:
        return home;
      case LIKE_TILES:
        return LikeTiles(this);
      case BALLOON_POP:
        return BalloonPop(this);
      case SPACE_SHIP:
        return SpaceShip(this);
      default:
        throw "invalid index: $index";
    }
  }

  switchToIndex(int index) {
    this.index = index;
    setState(() {});
  }
}
