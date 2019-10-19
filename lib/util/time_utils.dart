class TimeUtils {
  static int nowTimestamp() => DateTime.now().millisecondsSinceEpoch;

  static int todayAsDay() => millisToDays(DateTime.now().millisecondsSinceEpoch);

  static int millisToDays(int millis) => millis ~/ (1000 * 60 * 60 * 24);

  static Future<void> waitAsync(final int seconds) async {
    return Future.delayed(Duration(seconds: seconds), () => "");
  }

}
