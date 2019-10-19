import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:inf_sim/data/pojo/daily_statistic.dart';
import 'package:inf_sim/data/pojo/post.dart';
import 'package:inf_sim/logic/game_logic.dart';
import 'package:inf_sim/logic/upgrade.dart';
import 'package:inf_sim/util/localization.dart';

import 'preferences.dart';
import 'sqlite.dart';

///
/// - Holds data that is being worked with while the app is running
/// - Data gets saved to storage when the app is closed
///

class Data {
  // PREFERENCES
  static bool firstStart;
  static double followers;
  static double money;
  static int postPrice;
  static List<int> upgradeLevels;
  static List<bool> upgradeUnlocked;
  static int tick;
  static int lastPost;
  static int highestUnlockedUpgrade;
  static int likeTilesHighscore;
  static int balloonPopHighscore;
  static int spaceShipHighscore;

  // SQLITE
  static List<Post> posts;
  static HashMap<int, DailyStatistic> dailyStatistics;

  // CUSTOM
  static List<Upgrade> upgrades;

  static Future saveToStorage() async {
    await _savePreferences();
    await _saveSQLite();
  }

  static Future loadFromStorage(BuildContext c) async {
    // Load from storage
    await _loadPreferences();
    await _loadSQLite();
    await _loadCustom(c);
  }

  static _loadCustom(BuildContext c) {
    loadUpgrades(c);
  }

  static Future _loadPreferences() async {
    await Preferences.getFirstStart().then((value) {
      firstStart = value;
    });
    await Preferences.getFollowers().then((value) {
      followers = value;
    });
    await Preferences.getMoney().then((value) {
      money = value;
    });
    await Preferences.getPostPrice().then((value) {
      postPrice = value;
    });
    upgradeLevels = List();
    for (int i = 0; i < GameLogic.UPGRADES_COUNT; i++) {
      await Preferences.getUpgradeLevel(i).then((value) {
        upgradeLevels.add(value);
      });
    }
    upgradeUnlocked = List();
    for (int i = 0; i < GameLogic.UPGRADES_COUNT; i++) {
      await Preferences.getUpgradeUnlocked(i).then((value) {
        upgradeUnlocked.add(value);
      });
    }
    await Preferences.getTick().then((value) {
      tick = value;
    });
    await Preferences.getLastPost().then((value) {
      lastPost = value;
    });
    await Preferences.getHighestUnlockedUpgrade().then((value) {
      highestUnlockedUpgrade = value;
    });
    await Preferences.getLikeTilesHighscore().then((value) {
      likeTilesHighscore = value;
    });
    await Preferences.getBalloonPopHighscore().then((value) {
      balloonPopHighscore = value;
    });
    await Preferences.getSpaceShipHighscore().then((value) {
      spaceShipHighscore = value;
    });
  }

  static Future _savePreferences() async {
    await Preferences.setFirstStart(firstStart);
    await Preferences.setFollowers(followers);
    await Preferences.setMoney(money);
    await Preferences.setPostPrice(postPrice);
    for (int i = 0; i < GameLogic.UPGRADES_COUNT; i++) {
      await Preferences.setUpgradeLevel(i, upgradeLevels[i]);
    }
    for (int i = 0; i < GameLogic.UPGRADES_COUNT; i++) {
      await Preferences.setUpgradeUnlocked(i, upgradeUnlocked[i]);
    }
    await Preferences.setTick(tick);
    await Preferences.setLastPost(lastPost);
    await Preferences.setHighestUnlockedUpgrade(highestUnlockedUpgrade);
    await Preferences.setLikeTilesHighscore(likeTilesHighscore);
    await Preferences.setBalloonPopHighscore(balloonPopHighscore);
    await Preferences.setSpaceShipHighscore(spaceShipHighscore);
  }

  static Future _loadSQLite() async {
    posts = List<Post>();
    await SQLite.getPosts().then((List<Post> value) {
      if (value != null) {
        posts.addAll(value);
      }
    });
    dailyStatistics = HashMap();
    await SQLite.getDailyStatistics().then((value) {
      value.forEach((e) {
        dailyStatistics[e.day] = e;
      });
    });
  }

  static Future _saveSQLite() async {
    await SQLite.insertOrUpdatePosts(posts);
    await SQLite.insertOrUpdateDailyStatistics(dailyStatistics.values.toList());
  }

  static reset(BuildContext c) async {
    await SQLite.deleteAll();
    await Preferences.clearAll();
    Data.loadFromStorage(c);
  }

  static void loadUpgrades(BuildContext c) {
    upgrades = List();
    int index = 0;
    // Like 4 Like
    addLikesUpgrade(c, index++, CL.of(c).l.like4Like, valueBase: 2, priceBase: 5);
    // Deliver Newspaper
    addMoneyUpgrade(c, index++, CL.of(c).l.deliverNewspaper, valueBase: 2, priceBase: 30);
    // Spam Comments
    addFollowersUpgrade(c, index++, CL.of(c).l.commentSpamming, valueBase: 1, priceBase: 300);
    // Image Editing
    addLikesUpgrade(c, index++, CL.of(c).l.imageEditing, valueBase: 40, priceBase: 600);
    // Ads
    addFollowersUpgrade(c, index++, CL.of(c).l.ads, valueBase: 15, priceBase: 20000);
    // Bot
    addLikesUpgrade(c, index++, CL.of(c).l.bot, valueBase: 1200, priceBase: 100000);
    // Affiliate
    addMoneyUpgrade(c, index++, CL.of(c).l.affiliate, valueBase: 999, priceBase: 200000);
    // Photographer
    addLikesUpgrade(c, index++, CL.of(c).l.photographer, valueBase: 50000, priceBase: 2000000);
    // Collaborations
    addFollowersUpgrade(c, index++, CL.of(c).l.collaborations,
        valueBase: 1500, priceBase: 10000000);
    // Product Placements
    addMoneyUpgrade(c, index++, CL.of(c).l.productPlacements,
        valueBase: 120000, priceBase: 100000000);
    // Viral Marketing
    addLikesUpgrade(c, index++, CL.of(c).l.viralMarketing,
        valueBase: 5000000, priceBase: 300000000);
    // Merchandise
    addMoneyUpgrade(c, index++, CL.of(c).l.merchandise, valueBase: 8000000, priceBase: 2000000000);
    // Marketing Manager
    addFollowersUpgrade(c, index++, CL.of(c).l.marketingManager,
        valueBase: 1000000, priceBase: 50000000000);
    // AI Bot
    addLikesUpgrade(c, index++, CL.of(c).l.aiBot, valueBase: 2000000000, priceBase: 250000000000);
    // Real Estate
    addMoneyUpgrade(c, index++, CL.of(c).l.realEstate,
        valueBase: 1000000000, priceBase: 1000000000000);
    // Hacking
    addFollowersUpgrade(c, index++, CL.of(c).l.hacking,
        valueBase: 100000000, priceBase: 19000000000000);
    // Crypto Trading
    addMoneyUpgrade(c, index++, CL.of(c).l.cryptoTrading,
        valueBase: 1000000000000, priceBase: 200000000000000);
    // Magic
    addLikesUpgrade(c, index++, CL.of(c).l.magic,
        valueBase: 100000000000000, priceBase: 2000000000000000);
  }

  static const double UPGRADE_PRICE_MULTIPLIER = 1.2;

  static addLikesUpgrade(BuildContext c, int index, String name,
      {@required int valueBase, @required double priceBase}) {
    upgrades.add(Upgrade(c, index,
        category: Upgrade.CATEGORY_LIKES,
        name: name,
        upgradePriceEquation: UpgradeEquation(priceBase, UPGRADE_PRICE_MULTIPLIER),
        upgradeValueBase: valueBase));
  }

  static addFollowersUpgrade(BuildContext c, int index, String name,
      {@required int valueBase, @required double priceBase}) {
    upgrades.add(Upgrade(c, index,
        category: Upgrade.CATEGORY_FOLLOWERS,
        name: name,
        upgradePriceEquation: UpgradeEquation(priceBase,UPGRADE_PRICE_MULTIPLIER),
        upgradeValueBase: valueBase));
  }

  static addMoneyUpgrade(BuildContext c, int index, String name,
      {@required int valueBase, @required double priceBase}) {
    upgrades.add(Upgrade(c, index,
        category: Upgrade.CATEGORY_MONEY,
        name: name,
        upgradePriceEquation: UpgradeEquation(priceBase, UPGRADE_PRICE_MULTIPLIER),
        upgradeValueBase: valueBase));
  }
}
