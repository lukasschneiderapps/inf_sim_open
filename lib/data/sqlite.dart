import 'dart:async';
import 'dart:io' as io;
import 'package:inf_sim/data/pojo/post.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:inf_sim/data/pojo/daily_statistic.dart';

import 'data.dart';

class SQLite {
  static Database _db;

  static Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  static initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "cache.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  static void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE posts(id INTEGER PRIMARY KEY, likes REAL, created_at INTEGER, image INTEGER);");
    await db.execute(
        "CREATE TABLE daily_statistics(day INTEGER PRIMARY KEY, likes REAL, money REAL, followers REAL);");
    // Add first post by default
    await db.execute("INSERT INTO posts(id, likes, created_at, image) VALUES(NULL, 0, 0, 0)");
  }

  static Future<List<DailyStatistic>> getDailyStatistics() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM daily_statistics ORDER BY day DESC');
    List<DailyStatistic> dailyStatistics = List();
    for (int i = 0; i < list.length; i++) {
      dailyStatistics.add(DailyStatistic(list[i]["day"], list[i]["likes"], list[i]["money"], list[i]["followers"]));
    }
    return dailyStatistics;
  }

  static insertOrUpdateDailyStatistics(List<DailyStatistic> dailyStatistics) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      for (DailyStatistic dailyStatistic in dailyStatistics) {
        await txn.rawInsert(
            "INSERT OR IGNORE INTO daily_statistics(day, likes, money, followers) VALUES(${dailyStatistic.day}, ${dailyStatistic.likes}, ${dailyStatistic.money}, ${dailyStatistic.followers});");
        await txn.rawUpdate(
            "UPDATE daily_statistics SET likes = ${dailyStatistic.likes}, money = ${dailyStatistic.money}, followers = ${dailyStatistic.followers} WHERE day = ${dailyStatistic.day}");
      }
    });
  }

  static insertOrUpdatePosts(List<Post> posts) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      for (Post post in posts) {
        await txn
            .rawInsert(
                "INSERT OR IGNORE INTO posts(id, likes, created_at, image) VALUES(${post.id == -1 ? "NULL" : post.id}, ${post.likes}, ${post.createdAt}, ${post.image})")
            .then((value) {
          if (post.id == -1 && value != -1) post.id = value;
        });
        await txn.rawUpdate("UPDATE posts SET likes = ${post.likes} WHERE id = ${post.id};");
      }
    });
  }

  static Future<List<Post>> getPosts() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM posts ORDER BY created_at DESC');
    List<Post> posts = List();
    for (int i = 0; i < list.length; i++) {
      posts.add(Post.fromDb(list[i]["id"], list[i]["likes"], list[i]["created_at"], list[i]["image"]));
    }
    return posts;
  }

  static deleteAll() async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      await txn.rawDelete("DELETE FROM posts");
      await txn.rawDelete("DELETE FROM daily_statistics");
    });
  }
}
