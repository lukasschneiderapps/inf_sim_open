import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inf_sim/ui/horizontal_divider.dart';
import 'package:inf_sim/util/formatting.dart';
import 'package:inf_sim/util/input.dart';
import 'package:inf_sim/util/localization.dart';

class GameScaffold extends StatefulWidget {
  Widget gameWidget;
  Color appBarColor;

  int Function() getScore;
  int Function() getHighscore;

  AppBar appBar;

  String title;

  GameScaffold(this.gameWidget, this.title, this.appBarColor, this.getScore, this.getHighscore);

  @override
  _GameScaffold createState() => _GameScaffold();
}

class _GameScaffold extends State<GameScaffold> {
  @override
  Widget build(BuildContext c) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: widget.appBar = AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: widget.appBarColor,
                title: Row(
                  children: [
                    Expanded(
                        child: Container(
                            child: Text(widget.title,
                                style: TextStyle(fontFamily: 'Ruthscr', fontSize: 30)),
                            padding: EdgeInsets.only(top: 8)),
                        flex: 1),
                    Expanded(
                        child: Text("${CL.of(c).l.score}: ${widget.getScore()}",
                            textAlign: TextAlign.center),
                        flex: 1),
                    Expanded(
                        child: Text("${CL.of(c).l.highscore}: ${widget.getHighscore()}",
                            textAlign: TextAlign.end),
                        flex: 1),
                  ],
                )),
            body: Container(child: Stack(children: [Container(child: widget.gameWidget)]))));
  }
}

showGameFinishedDialog(BuildContext c, int score, bool highscore, int moneyScore, int followerScore,
    Function() onRetry, Function() onBack) {
  showDialog(
    context: c,
    barrierDismissible: false,
    builder: (BuildContext c) {
      // return object of type Dialog
      return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(CL.of(c).l.gameFinished),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                        child: Text("${CL.of(c).l.score}: $score", style: TextStyle(fontSize: 23)),
                        flex: 1),
                    Expanded(
                        child: Text(highscore ? "${CL.of(c).l.newHighscore}" : "",
                            style: TextStyle(fontSize: 20, color: Colors.red),
                            textAlign: TextAlign.end),
                        flex: 1)
                  ]),
                  Padding(padding: EdgeInsets.all(8)),
                  HorizontalDivider(),
                  Padding(padding: EdgeInsets.all(8)),
                  Text(
                    "${CL.of(c).l.reward}:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Text("${CL.of(c).l.money}: ${currencyFormat.format(moneyScore)}"),
                  Text("${CL.of(c).l.followers}: ${compactFormat.format(followerScore)}")
                ]),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: Text(CL.of(c).l.playAgain),
                onPressed: () {
                  Navigator.of(c).pop();
                  onRetry();
                },
              ),
              FlatButton(
                child: Text(CL.of(c).l.back),
                onPressed: () {
                  Input.removeAllTapReceivers();
                  Navigator.of(c).pop();
                  onBack();
                },
              ),
            ],
          ));
    },
  );
}
