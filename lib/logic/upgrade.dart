import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:inf_sim/data/data.dart';
import 'package:inf_sim/util/localization.dart';

import 'game_logic.dart';

class Upgrade {
  static const MAX_LEVEL = 100;

  // Upgrade categories
  static const CATEGORY_LIKES = 0;
  static const CATEGORY_FOLLOWERS = 1;
  static const CATEGORY_MONEY = 2;

  int index;
  int category;
  String name;
  String currency;

  Function(Random ran, int today) tick;
  UpgradeEquation upgradePriceEquation;
  int upgradeValueBase;

  Upgrade(BuildContext c, this.index,
      {@required this.category,
      @required this.name,
      @required this.upgradeValueBase,
      @required this.upgradePriceEquation}) {
    currency = getCurrencyFromCategory(c);
    tick = getTickFromCategory();
  }

  int getUpgradeLevel() => Data.upgradeLevels[index];

  bool isMaxLevel() => getUpgradeLevel() >= MAX_LEVEL;

  bool isUnlocked() => Data.upgradeUnlocked[index] || canBuy();

  bool isBought() => getUpgradeLevel() > 0;

  int getUpgradeValue() => (upgradeValueBase * max(1, getUpgradeLevel())).toInt();

  int getUpgradePrice() =>
      (upgradePriceEquation.base * pow(upgradePriceEquation.multiplier, getUpgradeLevel())).toInt();

  String getCurrencyFromCategory(BuildContext c) {
    switch (category) {
      case CATEGORY_LIKES:
        return CL.of(c).l.likesPerSecond;
      case CATEGORY_FOLLOWERS:
        return CL.of(c).l.followersPerSecond;
      case CATEGORY_MONEY:
        return CL.of(c).l.moneyPerSecond;
      default:
        throw "invalid category: $category";
    }
  }

  Function(Random ran, int today) getTickFromCategory() {
    switch (category) {
      case CATEGORY_LIKES:
        return (Random ran, int today) {
          if (Data.posts.length > 0) {
            GameLogic.increaseLikes(Data.posts[ran.nextInt(min(Data.posts.length, 5))],
                getUpgradeValue() / GameLogic.TICKS_PER_SECOND, today);
          }
        };
      case CATEGORY_FOLLOWERS:
        return (Random ran, int today) =>
            GameLogic.increaseFollowers(getUpgradeValue() / GameLogic.TICKS_PER_SECOND, today);
      case CATEGORY_MONEY:
        return (Random ran, int today) =>
            GameLogic.increaseMoney(getUpgradeValue() / GameLogic.TICKS_PER_SECOND, today);
      default:
        throw "invalid category: $category";
    }
  }

  bool canBuy() => Data.money >= getUpgradePrice();
}

class UpgradeEquation {
  double base;
  double multiplier;

  UpgradeEquation(this.base, this.multiplier);
}
