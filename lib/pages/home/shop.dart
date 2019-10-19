import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:inf_sim/data/data.dart';
import 'package:inf_sim/logic/game_logic.dart';
import 'package:inf_sim/logic/upgrade.dart';
import 'package:inf_sim/ui/horizontal_divider.dart';
import 'package:inf_sim/ui/image_with_drop_shadow.dart';
import 'package:inf_sim/util/audio.dart';
import 'package:inf_sim/util/localization.dart';
import 'package:inf_sim/util/formatting.dart';

class Shop extends StatefulWidget {
  @override
  _Shop createState() => _Shop();
}

class _Shop extends State<Shop> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext c) {
    return Container(child: ListView.builder(
        key: PageStorageKey("retainScrollPosition_Shop"),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: min(Data.highestUnlockedUpgrade + 3, Data.upgrades.length),
        itemBuilder: (c, position) =>
            Column(children: [UpgradeCard(c, Data.upgrades[position]), HorizontalDivider()])));
  }
}

class UpgradeCard extends StatelessWidget {
  Upgrade upgrade;

  String name;
  String level;
  String performance;
  String buttonText;
  String imagePath;
  String buttonImagePath;

  bool upgradable;
  bool buttonEnabled;

  int upgradePrice;

  UpgradeCard(BuildContext c, this.upgrade) {
    int upgradeLevel = upgrade.getUpgradeLevel();

    buttonEnabled = upgrade.canBuy() && !upgrade.isMaxLevel();
    upgradePrice = upgrade.getUpgradePrice();
    performance = "${compactFormat.format(upgrade.getUpgradeValue())} ${upgrade.currency}";
    imagePath = "assets/images/upgrade${upgrade.index}.png";
    buttonText = "${currencyFormat.format(upgradePrice)}";

    if (upgrade.isUnlocked()) {
      name = upgrade.name;
      if (upgradeLevel < 1) {
        // Unlock
        level = "";
        buttonImagePath = "assets/images/unlock.png";
      } else if (upgrade.isMaxLevel()) {
        // Max
        level = "${CL.of(c).l.level}$upgradeLevel";
        buttonText = "${CL.of(c).l.max}";
        buttonImagePath = "assets/images/max.png";
      } else {
        // Upgrade
        level = "${CL.of(c).l.level}$upgradeLevel";
        buttonImagePath = "assets/images/upgrade.png";
      }
    } else {
      name = CL.of(c).l.unknown;
      performance = CL.of(c).l.unknown;
      level = "";
      buttonImagePath = "assets/images/unlock.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext c, StateSetter setState) {
      return Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(children: [
            Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 8, 16, 8),
                  child: ImageWithDropShadow(imagePath, upgrade.isUnlocked()),
                ),
                flex: 1),
            Expanded(
                child: Column(children: [
                  Row(children: [
                    Expanded(
                        child:
                            Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        flex: 1),
                    Expanded(
                        child: Text(
                          level,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          textAlign: TextAlign.end,
                        ),
                        flex: 1),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              performance,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black54, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            )
                          ],
                        ),
                        flex: 3),
                    Padding(padding: EdgeInsets.only(right: 16)),
                    Expanded(
                        child: RaisedButton(
                            color: Color.fromRGBO(156, 255, 140, 1),
                            onPressed: buttonEnabled
                                ? () {
                                    if (GameLogic.buyIfPossible(upgradePrice)) {
                                      audioPlayer.play("sounds/upgrade.mp3", volume: 0.8);
                                      GameLogic.incrementUpgrade(upgrade.index);
                                    } else {
                                      showDialog(
                                          context: c,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: Text(CL.of(c).l.notEnoughMoney),
                                                actions: [
                                                  FlatButton(
                                                      child: Text(CL.of(c).l.okay),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      })
                                                ]);
                                          });
                                    }
                                  }
                                : null,
                            child: Row(children: [
                              Image.asset(buttonImagePath, width: 24, height: 24),
                              Padding(padding: EdgeInsets.all(4)),
                              Expanded(child: Text(buttonText, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),), flex: 1)
                            ])),
                        flex: 3)
                  ])
                ]),
                flex: 3)
          ]));
    });
  }
}
