import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageWithDropShadow extends StatelessWidget {

  String imagePath;
  bool unlocked;

  ImageWithDropShadow(this.imagePath, this.unlocked);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(children: [
          Opacity(child: Padding(padding: EdgeInsets.all(4), child :Image.asset(imagePath, color: Colors.black)), opacity: 0.2),
          ClipRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Padding(padding: EdgeInsets.all(4), child :unlocked
                      ? Image.asset(imagePath)
                      : Image.asset(imagePath, color: Colors.black54))))
        ]));
  }

}