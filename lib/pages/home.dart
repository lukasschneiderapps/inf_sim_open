import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:inf_sim/data/data.dart';
import 'package:inf_sim/logic/game_logic.dart';
import 'package:inf_sim/pages/wrapper.dart';
import 'package:inf_sim/util/localization.dart';
import 'package:inf_sim/util/formatting.dart';

import 'home/games.dart';
import 'home/profile.dart';
import 'home/shop.dart';
import 'home/stats.dart';

class Home extends StatefulWidget {
  WrapperState wrapper;

  Home(this.wrapper);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<Home> {
  static const int GAMES = 0;
  static const int SHOP = 1;
  static const int POST = 2;
  static const int STATS = 3;
  static const int PROFILE = 4;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  Timer timer;

  int _currentPageIndex;

  @override
  initState() {
    super.initState();

    _currentPageIndex = PROFILE;

    startGameTimer();

    if (Data.firstStart) {
      Future.delayed(Duration.zero, () => showFirstStartDialog(context));
    }
  }

  void startGameTimer() {
    const tickDuration = Duration(milliseconds: 1000 ~/ GameLogic.TICKS_PER_SECOND);
    timer = Timer.periodic(tickDuration, (Timer t) {
      GameLogic.tick();
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  _onBottomItemTapped(int index) {
    if (index == POST) {
      Future.delayed(Duration.zero, () {
        showDialog(context: context, barrierDismissible: true, builder: (_) => CreatePostDialog());
      });
    } else {
      setState(() {
        _currentPageIndex = index;
      });
    }
  }

  Widget getCurrentPage() {
    switch (_currentPageIndex) {
      case GAMES:
        return Games(widget.wrapper);
      case SHOP:
        return Shop();
      case STATS:
        return Stats();
      case PROFILE:
        return Profile();
      default:
        return Text("-/-");
    }
  }

  @override
  Widget build(BuildContext c) {
    // Automatically save data every 60 seconds
    if(Data.tick % (60 * GameLogic.TICKS_PER_SECOND) == 0) {
      Data.saveToStorage();
    }

    return Scaffold(
      body: Container(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            AppBar(
                title: Row(
              children: [
                Text(getCurrentPageTitle(c)),
                Expanded(
                    child: Text(
                      "${simpleCurrencyFormat.format(Data.money.toInt())}",
                      textAlign: TextAlign.end,
                    ),
                    flex: 1)
              ],
            )),
            Expanded(child: Container(child: getCurrentPage())),
          ])),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentPageIndex,
          onTap: _onBottomItemTapped,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.videogame_asset), title: Padding(padding: EdgeInsets.all(0))),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), title: Padding(padding: EdgeInsets.all(0))),
            BottomNavigationBarItem(
                icon: Icon(Icons.add), title: Padding(padding: EdgeInsets.all(0))),
            BottomNavigationBarItem(
                icon: Icon(Icons.trending_up), title: Padding(padding: EdgeInsets.all(0))),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Padding(padding: EdgeInsets.all(0))),
          ]),
    );
  }

  String getCurrentPageTitle(BuildContext c) {
    switch (_currentPageIndex) {
      case GAMES:
        return CL.of(c).l.gamesTitle;
      case SHOP:
        return CL.of(c).l.shopTitle;
      case STATS:
        return CL.of(c).l.statsTitle;
      case PROFILE:
        return CL.of(c).l.profileTitle;
      default:
        return CL.of(c).l.error;
    }
  }

  void showFirstStartDialog(BuildContext c) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => WillPopScope(
            child: AlertDialog(
              title: Text(CL.of(c).l.welcome),
              content: Text(CL.of(c).l.firstStartMessage),
              actions: [
                // usually buttons at the bottom of the dialog
                FlatButton(
                  child: Text(CL.of(c).l.letsGo),
                  onPressed: () {
                    Data.firstStart = false;
                    Navigator.of(c).pop();
                  },
                ),
              ],
            ),
            onWillPop: () async => true));
  }
}

class CreatePostDialog extends StatefulWidget {
  @override
  State<CreatePostDialog> createState() => _CreatePostDialog();
}

class _CreatePostDialog extends State<CreatePostDialog> {
  Timer timer;

  _CreatePostDialog() {
    const tickDuration = Duration(milliseconds: 1000 ~/ GameLogic.TICKS_PER_SECOND);
    timer = Timer.periodic(tickDuration, (Timer t) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext c) {
    bool canCreatePost = GameLogic.canBuy(Data.postPrice) && GameLogic.isPostCooldownFinished();
    return WillPopScope(
        child: AlertDialog(
          title: Text(CL.of(c).l.createPost),
          content: Container(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(children: [Text("Preis: ${simpleCurrencyFormat.format(Data.postPrice.abs())}")]),
            GameLogic.isPostCooldownFinished()
                ? Padding(padding: EdgeInsets.all(0))
                : Column(children: [
                    Padding(padding: EdgeInsets.all(8)),
                    LinearProgressIndicator(value: GameLogic.getPostCooldownProgress()),
                    Padding(padding: EdgeInsets.all(4)),
                    Text(CL.of(c).l.postCooldownMsg, style: TextStyle(fontSize: 12)),
                  ])
          ])),
          actions: [
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(CL.of(c).l.close),
              onPressed: () {
                Navigator.of(c).pop();
              },
            ),
            FlatButton(
                onPressed: canCreatePost
                    ? () {
                        if (GameLogic.buyIfPossible(Data.postPrice)) {
                          Navigator.pop(c);
                          GameLogic.createNewPost();
                          Data.postPrice = (max(
                                  GameLogic.moneyAddedThroughUpgradesInLastSecond * 10,
                                  GameLogic.MIN_POST_PRICE))
                              .toInt();
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
                child: Text("Post erstellen"))
          ],
        ),
        onWillPop: () async => true);
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}
