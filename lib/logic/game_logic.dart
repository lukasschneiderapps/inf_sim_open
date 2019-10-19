import 'dart:math';

import 'package:inf_sim/data/data.dart';
import 'package:inf_sim/data/pojo/daily_statistic.dart';
import 'package:inf_sim/data/pojo/post.dart';
import 'package:inf_sim/logic/upgrade.dart';
import 'package:inf_sim/util/audio.dart';
import 'package:inf_sim/util/time_utils.dart';

class GameLogic {
  static const int POST_COOLDOWN = TICKS_PER_SECOND * 10;

  static const int TICKS_PER_SECOND = 8;

  static const double DOLLARS_PER_LIKE = 0.1;

  static const int UPGRADES_COUNT = 20;

  static const int MIN_POST_PRICE = 9;

  static Random ran = Random();

  static double moneyAddedThroughUpgradesInLastSecond = 0;
  static double _moneyAddedThroughUpgradesInCurrentTick = 0;

  static double followersAddedThroughUpgradesInLastSecond = 0;
  static double _followersAddedThroughUpgradesInCurrentTick = 0;

  static void tick() {
    int today = TimeUtils.millisToDays(TimeUtils.nowTimestamp());

    ensureHasDailyStatisticForDay(today);

    ///
    /// POSTS
    ///
    for (int i = 0; i < Data.posts.length; i++) {
      Post post = Data.posts[i];
      double secondsSinceCreation = (Data.tick - post.createdAt) / TICKS_PER_SECOND;

      // info: changed from 1.2 to 1.3
      double likesToAdd =
          1.3 * Data.followers / (4 * (secondsSinceCreation + 1)) / TICKS_PER_SECOND;
      increaseLikes(post, likesToAdd, today);
      double followersToAdd = likesToAdd / 250.0;
      increaseFollowers(followersToAdd, today);
    }

    ///
    /// UPGRADES
    ///

    _moneyAddedThroughUpgradesInCurrentTick = 0;
    _followersAddedThroughUpgradesInCurrentTick = 0;
    for (Upgrade upgrade in Data.upgrades) if (upgrade.isBought()) upgrade.tick(ran, today);
    moneyAddedThroughUpgradesInLastSecond =
        _moneyAddedThroughUpgradesInCurrentTick * GameLogic.TICKS_PER_SECOND;
    followersAddedThroughUpgradesInLastSecond =
        _followersAddedThroughUpgradesInCurrentTick * GameLogic.TICKS_PER_SECOND;

    /// INCREASE TICK
    Data.tick++;
  }

  static void increaseFollowers(double amount, int today) {
    Data.followers += amount;
    Data.dailyStatistics[today].followers += amount;

    _followersAddedThroughUpgradesInCurrentTick += amount;
  }

  static const double BALANCE_GAME_REWARD_MONEY = 12;

  static int increaseMoneyFromScore(int score, int today) {
    int moneyScore = max(
        (score ~/ 4 * max(1, moneyAddedThroughUpgradesInLastSecond * 4) / BALANCE_GAME_REWARD_MONEY)
            .floor(),
        score ~/ 12);
    increaseMoney(moneyScore.toDouble(), today);
    return moneyScore;
  }

  static int increaseFollowersFromScore(int score, int today) {
    int followerScore =
        (score ~/ 18 * max(1, followersAddedThroughUpgradesInLastSecond * 2)).floor();
    increaseFollowers(followerScore.toDouble(), today);
    return followerScore;
  }

  static void increaseMoney(double amount, int today) {
    Data.dailyStatistics[today].money += amount;
    Data.money += amount;

    _moneyAddedThroughUpgradesInCurrentTick += amount;
  }

  static void increaseLikes(Post post, double amount, int today) {
    post.likes += amount;
    Data.dailyStatistics[today].likes += amount;
    increaseMoney(amount * DOLLARS_PER_LIKE, today);
  }

  static void ensureHasDailyStatisticForDay(int day) {
    if (!Data.dailyStatistics.containsKey(day)) {
      Data.dailyStatistics[day] = DailyStatistic(day, 0, 0, 0);
    }
  }

  static bool canBuy(int price) => Data.money >= price;

  static bool buyIfPossible(int price) {
    if (canBuy(price)) {
      Data.money -= price;
      return true;
    }
    return false;
  }

  static void createNewPost() {
    audioPlayer.play("sounds/create_post.mp3");

    int previousPostImage = Data.posts.length > 0 ? Data.posts.first.image : -1;
    int postImage = previousPostImage;
    while (postImage == previousPostImage) {
      postImage = ran.nextInt(Post.POST_IMAGE_COUNT);
    }
    Data.posts.insert(0, Post.toDb(0, Data.tick, postImage));
    Data.lastPost = Data.tick;
  }

  static void incrementUpgrade(int upgradeIndex) {
    Data.upgradeLevels[upgradeIndex]++;
    Data.upgradeUnlocked[upgradeIndex] = true;
    if (upgradeIndex > Data.highestUnlockedUpgrade) {
      Data.highestUnlockedUpgrade = upgradeIndex;
    }
  }

  static bool isPostCooldownFinished() => getPostCooldownProgress() >= 1.0;

  static double getPostCooldownProgress() => (Data.tick - Data.lastPost) / POST_COOLDOWN;
}
