import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inf_sim/data/data.dart';
import 'package:inf_sim/logic/game_logic.dart';
import 'package:inf_sim/ui/image_with_drop_shadow.dart';
import 'package:inf_sim/util/custom_colors.dart';
import 'package:inf_sim/util/formatting.dart';
import 'package:inf_sim/util/localization.dart';
import 'package:inf_sim/util/time_utils.dart';

import '../wrapper.dart';

class Games extends StatefulWidget {
  WrapperState wrapper;

  Games(this.wrapper);

  @override
  _Games createState() => _Games();
}

class _Games extends State<Games> {
  @override
  Widget build(BuildContext c) {
    return SingleChildScrollView(
        key: PageStorageKey("retainScrollPosition_Games"),
        child: Container(
            padding: EdgeInsets.fromLTRB(8, 12, 8, 8),
            child: Column(children: [
              Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 16, left: 8, right: 8),
                  child: Row(children: [
                    Text(CL.of(c).l.gamesExplanation, style: TextStyle(fontStyle: FontStyle.italic))
                  ])),
              GameCard(widget.wrapper, "assets/images/heart_filled.png", likeTilesColor,
                  CL.of(c).l.likeTiles, WrapperState.LIKE_TILES, 0),
              Padding(padding: EdgeInsets.all(4)),
              GameCard(widget.wrapper, "assets/images/balloon_yellow.png", balloonPopColor,
                  CL.of(c).l.balloonPop, WrapperState.BALLOON_POP, 10000000),
              Padding(padding: EdgeInsets.all(4)),
              GameCard(widget.wrapper, "assets/images/spaceship.png", spaceShipColor,
                  CL.of(c).l.spaceShip, WrapperState.SPACE_SHIP, 10000000000),
              Padding(padding: EdgeInsets.all(4)),
              /*Row(children: [
                Expanded(
                    child: Card(
                        elevation: 4,
                        child: Container(
                            padding: EdgeInsets.all(16),
                            child: Column(children: [
                              Text("MAX MONEY",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Padding(padding: EdgeInsets.all(16)),
                              RaisedButton(
                                  onPressed: () {
                                    GameLogic.increaseMoney(10000000000, TimeUtils.todayAsDay());
                                  },
                                  child: Text("#"))
                            ])))),
                Expanded(
                    child: Card(
                        elevation: 4,
                        child: Container(
                            padding: EdgeInsets.all(16),
                            child: Column(children: [
                              Text("Money * 2",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Padding(padding: EdgeInsets.all(16)),
                              RaisedButton(
                                  onPressed: () {
                                    GameLogic.increaseMoney(Data.money, TimeUtils.todayAsDay());
                                  },
                                  child: Text("#"))
                            ])))),
                Expanded(
                    child: Card(
                        elevation: 4,
                        child: Container(
                            padding: EdgeInsets.all(16),
                            child: Column(children: [
                              Text("WTF BUTTON",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Padding(padding: EdgeInsets.all(16)),
                              RaisedButton(
                                  onPressed: () {
                                    GameLogic.increaseLikes(Data.posts[0], 10000000000000000000,
                                        TimeUtils.todayAsDay());
                                    GameLogic.increaseFollowers(
                                        10000000000000000000, TimeUtils.todayAsDay());
                                  },
                                  child: Text("#"))
                            ])))),
                Expanded(
                    child: Card(
                        elevation: 4,
                        child: Container(
                            padding: EdgeInsets.all(16),
                            child: Column(children: [
                              Text("RESET",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Padding(padding: EdgeInsets.all(16)),
                              RaisedButton(
                                  onPressed: () {
                                    Data.reset(c);
                                  },
                                  child: Text("#"))
                            ])))),
                Expanded(
                    child: Card(
                        elevation: 4,
                        child: Container(
                            padding: EdgeInsets.all(16),
                            child: Column(children: [
                              Text("toggle ui thing",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Padding(padding: EdgeInsets.all(16)),
                              RaisedButton(
                                  onPressed: () {
                                    debugPaintSizeEnabled = !debugPaintSizeEnabled;
                                  },
                                  child: Text("#"))
                            ])))),
                Expanded(
                    child: Card(
                        elevation: 4,
                        child: Container(
                            padding: EdgeInsets.all(16),
                            child: Column(children: [
                              Text("skip 10 min",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Padding(padding: EdgeInsets.all(16)),
                              RaisedButton(
                                  onPressed: () {
                                    for (int i = 0; i < GameLogic.TICKS_PER_SECOND * 60 * 10; i++) {
                                      GameLogic.tick();
                                    }
                                  },
                                  child: Text("#"))
                            ])))),
                Expanded(
                    child: Card(
                        elevation: 4,
                        child: Container(
                            padding: EdgeInsets.all(16),
                            child: Column(children: [
                              Text("game with score 300",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Padding(padding: EdgeInsets.all(16)),
                              RaisedButton(
                                  onPressed: () {
                                    int score = 300;
                                    int today = TimeUtils.todayAsDay();
                                    GameLogic.increaseMoneyFromScore(score, today);
                                    GameLogic.increaseFollowersFromScore(score, today);
                                  },
                                  child: Text("#"))
                            ])))),
                Expanded(child: Text("${Data.tick}")),
              ])*/
            ])));
  }
}

class GameCard extends StatelessWidget {
  WrapperState wrapper;

  Color color;

  String imagePath;

  String title;

  int wrapperIndex;

  int unlockedAtFollowerCount;

  GameCard(this.wrapper, this.imagePath, this.color, this.title, this.wrapperIndex,
      this.unlockedAtFollowerCount);

  @override
  Widget build(BuildContext c) {
    bool unlocked = Data.followers >= unlockedAtFollowerCount;
    Color textColor = unlocked ? Colors.black : Colors.white;
    String buttonText = unlocked
        ? CL.of(c).l.play
        : "${compactFormat.format(unlockedAtFollowerCount)} ${CL.of(c).l.followers}";
    double textSize = unlocked ? 18 : 12;

    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Row(children: [
        Expanded(
            child: Card(
                color: color,
                elevation: 4,
                child: Container(
                    padding: EdgeInsets.all(16),
                    child: Row(children: [
                      Expanded(child: ImageWithDropShadow(imagePath, unlocked), flex: 1),
                      Padding(padding: EdgeInsets.all(16)),
                      Expanded(
                          child: Text(unlocked ? title : CL.of(c).l.unknown,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                          flex: 2),
                      Padding(padding: EdgeInsets.all(16)),
                      Expanded(
                          child: RaisedButton(
                              color: Colors.white,
                              onPressed:
                                  unlocked ? ()=>wrapper.switchToIndex(wrapperIndex) : null,
                              child: Row(children: [
                                unlocked
                                    ? Padding(padding: EdgeInsets.all(0))
                                    : Image.asset("assets/images/unlock.png",
                                        width: 24, height: 24),
                                Expanded(
                                    child: Text(
                                      buttonText,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: textSize, color: textColor),
                                    ),
                                    flex: 1)
                              ])),
                          flex: 2)
                    ]))))
      ]);
    });
  }
}
