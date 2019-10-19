import 'package:inf_sim/logic/game_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const String _FIRST_START = "first_start";
  static const String _FOLLOWERS = "followers";
  static const String _MONEY = "money";
  static const String _POST_PRICE = "post_price";
  static const String _UPGRADE_LEVEL = "upgrade_level";
  static const String _UPGRADE_UNLOCKED= "upgrade_unlocked";
  static const String _TICK = "tick";
  static const String _LAST_POST = "last_post";
  static const String _HIGHEST_UNLOCKED_UPGRADE = "highest_unlocked_ugprade";
  static const String _LIKE_TILES_HIGHSCORE = "like_tiles_highscore";
  static const String _BALLOON_POP_HIGHSCORE = "balloon_pop_highscore";
  static const String _SPACE_SHIP_HIGHSCORE = "space_ship_highscore";

  static Future<bool> setSpaceShipHighscore(int value) async => _setInt(_SPACE_SHIP_HIGHSCORE, value);

  static Future<int> getSpaceShipHighscore() async => _getInt(_SPACE_SHIP_HIGHSCORE, 0);

  static Future<bool> setBalloonPopHighscore(int value) async => _setInt(_BALLOON_POP_HIGHSCORE, value);

  static Future<int> getBalloonPopHighscore() async => _getInt(_BALLOON_POP_HIGHSCORE, 0);

  static Future<bool> setLikeTilesHighscore(int value) async => _setInt(_LIKE_TILES_HIGHSCORE, value);

  static Future<int> getLikeTilesHighscore() async => _getInt(_LIKE_TILES_HIGHSCORE, 0);

  static Future<bool> setHighestUnlockedUpgrade(int value) async => _setInt(_HIGHEST_UNLOCKED_UPGRADE, value);

  static Future<int> getHighestUnlockedUpgrade() async => _getInt(_HIGHEST_UNLOCKED_UPGRADE, 0);

  static Future<bool> setLastPost(int value) async => _setInt(_LAST_POST, value);

  static Future<int> getLastPost() async => _getInt(_LAST_POST, -1000);

  static Future<bool> setTick(int value) async => _setInt(_TICK, value);

  static Future<int> getTick() async => _getInt(_TICK, 0);

  static Future<bool> setUpgradeUnlocked(int index, bool value) async => _setBool(_UPGRADE_UNLOCKED+index.toString(), value);

  static Future<bool> getUpgradeUnlocked(int index) async => _getBool(_UPGRADE_UNLOCKED+index.toString(), false);

  static Future<bool> setUpgradeLevel(int index, int value) async => _setInt(_UPGRADE_LEVEL+index.toString(), value);

  static Future<int> getUpgradeLevel(int index) async => _getInt(_UPGRADE_LEVEL+index.toString(), 0);

  static Future<bool> setPostPrice(int value) async => _setInt(_POST_PRICE, value);

  static Future<int> getPostPrice() async => _getInt(_POST_PRICE, GameLogic.MIN_POST_PRICE);

  static Future<bool> setMoney(double value) async => _setDouble(_MONEY, value);

  static Future<double> getMoney() async => _getDouble(_MONEY, 15);

  static Future<bool> setFirstStart(bool value) async => _setBool(_FIRST_START, value);

  static Future<bool> getFirstStart() async => _getBool(_FIRST_START, true);

  static Future<bool> setFollowers(double value) async => _setDouble(_FOLLOWERS, value);

  static Future<double> getFollowers() async => _getDouble(_FOLLOWERS, 10);

  static Future<double> _getDouble(String param, double def) async =>
      (await SharedPreferences.getInstance()).getDouble(param) ?? def;

  static Future<int> _getInt(String param, int def) async =>
      (await SharedPreferences.getInstance()).getInt(param) ?? def;

  static Future<String> _getString(String param, String def) async =>
      (await SharedPreferences.getInstance()).getString(param) ?? def;

  static Future<bool> _getBool(String param, bool def) async =>
      (await SharedPreferences.getInstance()).getBool(param) ?? def;

  static Future<bool> _setDouble(String param, double value) async =>
      (await SharedPreferences.getInstance()).setDouble(param, value);

  static Future<bool> _setInt(String param, int value) async =>
      (await SharedPreferences.getInstance()).setInt(param, value);

  static Future<bool> _setString(String param, String value) async =>
      (await SharedPreferences.getInstance()).setString(param, value);

  static Future<bool> _setBool(String param, bool value) async =>
      (await SharedPreferences.getInstance()).setBool(param, value);

  static Future<bool> clearAll() async =>
    (await SharedPreferences.getInstance()).clear();
}
