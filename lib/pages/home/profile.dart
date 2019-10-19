import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:inf_sim/data/data.dart';
import 'package:inf_sim/data/pojo/post.dart';
import 'package:inf_sim/util/localization.dart';
import 'package:inf_sim/util/formatting.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  @override
  Widget build(BuildContext c) {
    return SingleChildScrollView(
        key: PageStorageKey("retainScrollPosition_Profile"),
        child: Container(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Container(
                  padding: EdgeInsets.fromLTRB(4, 4, 4, 8),
                  child: Row(children: [
                    Container(
                        padding: EdgeInsets.all(8),
                        child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black12, width: 2),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage("assets/images/profile.png"))))),
                    Expanded(
                        child: Column(children: [
                          Text(
                            "${compactFormat.format(Data.posts.length)}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            CL.of(c).l.posts,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14),
                          )
                        ]),
                        flex: 2),
                    Expanded(
                        child: Column(children: [
                          Text(
                            "${compactFormat.format(Data.followers.toInt())}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            CL.of(c).l.followers,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14),
                          )
                        ]),
                        flex: 2),
                    Expanded(
                        child: FlatButton(
                            onPressed: () {
                              // About dialog
                              showDialog(
                                  context: c,
                                  barrierDismissible: true,
                                  builder: (c) {
                                    return WillPopScope(
                                        child: AlertDialog(
                                          title: Text(CL.of(c).l.appName),
                                            content: Linkify(onOpen: _openLink, text: "${CL.of(c).l.firstStartMessage}\n\n${CL.of(c).l.aboutText}"),
                                            actions: [
                                              FlatButton(
                                                  child: Text(CL.of(c).l.okay),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  })
                                            ]),
                                        onWillPop: () async => true);
                                  });
                            },
                            child: Icon(Icons.info_outline)),
                        flex: 1)
                  ])),
              Container(
                  height: 500,
                  child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                            // Where the linear gradient begins and ends
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            // Add one stop for each color. Stops should increase from 0 to 1
                            stops: [
                              0.0,
                              1.0
                            ],
                            colors: [
                              // Colors are easy thanks to Flutter's Colors class.
                              Colors.white.withOpacity(0),
                              Colors.white.withOpacity(1),
                            ]).createShader(bounds);
                      },
                      child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          childAspectRatio: 1.0,
                          padding: const EdgeInsets.all(4.0),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          children: getPostGridTiles())))
            ])));
  }

  List<GridTile> getPostGridTiles() {
    List<GridTile> gridTiles = List();
    // Maximum posts rendered = 50
    for (int i = 0; i < min(50, Data.posts.length); i++) {
      Post post = Data.posts[i];
      gridTiles.add(GridTile(
          footer: Container(
              color: Colors.white70,
              padding: EdgeInsets.all(4),
              alignment: Alignment.bottomCenter,
              child: Row(children: [
                Icon(Icons.favorite, size: 15),
                Expanded(
                    child: Text(
                  compactFormat.format(post.likes.toInt()),
                  textAlign: TextAlign.center,
                ))
              ])),
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/post${post.image}.png"),
                      fit: BoxFit.cover)))));
    }
    return gridTiles;
  }

  Future<void> _openLink(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'could not launch link $link';
    }
  }

}
