import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';

class Input {
  static List<Function(double, double)> receivers = List();

  static void init() {
    Flame.util.addGestureRecognizer(TapGestureRecognizer()
      ..onTapDown =
          (TapDownDetails evt) => _handleInput(evt.globalPosition.dx, evt.globalPosition.dy));
  }

  static void addTapReceiver(Function(double, double) f) {
    receivers.add(f);
  }

  static void removeTapReceiver(Function(double, double) f) {
    receivers.remove(f);
  }

  static _handleInput(double dx, double dy) {
    for (Function(double, double) receiver in receivers) receiver(dx, dy);
  }

  static void removeAllTapReceivers() {
    receivers.clear();
  }
}