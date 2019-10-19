import 'package:flutter/material.dart';
import 'package:inf_sim/data/data.dart';
import 'package:inf_sim/data/pojo/daily_statistic.dart';
import 'package:inf_sim/ui/horizontal_divider.dart';
import 'package:inf_sim/util/formatting.dart';
import 'package:inf_sim/util/localization.dart';
import 'package:inf_sim/util/time_utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Stats extends StatefulWidget {
  @override
  _Stats createState() => _Stats();
}

class _Stats extends State<Stats> {
  @override
  Widget build(BuildContext c) {
    int likesToday = Data.dailyStatistics[TimeUtils.todayAsDay()].likes.toInt();
    int followersToday = Data.dailyStatistics[TimeUtils.todayAsDay()].followers.toInt();
    int revenueToday = Data.dailyStatistics[TimeUtils.todayAsDay()].money.toInt();

    List<DailyStatistic> dailyStatistics = getDailyStatisticsOfLast7DaysIncludingToday();

    return SingleChildScrollView(
        key: PageStorageKey("retainScrollPosition_Stats"),
        child: Column(children: [
          HorizontalDivider(),
          Container(
              color: Colors.white,
              padding: EdgeInsets.all(24),
              child: Column(children: [
                Row(children: [
                  Text(CL.of(c).l.today,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                ]),
                Padding(
                  padding: EdgeInsets.all(4),
                ),
                Row(children: [
                  Expanded(
                      child: Column(children: [
                    Row(children: [Text(CL.of(c).l.revenue, style: TextStyle(fontSize: 13))]),
                    Padding(
                      padding: EdgeInsets.all(2),
                    ),
                    Row(children: [
                      Text("+" + currencyFormat.format(revenueToday),
                          style: TextStyle(fontSize: 25, color: Color.fromARGB(255, 110, 110, 110)))
                    ]),
                  ])),
                ]),
                Padding(
                  padding: EdgeInsets.all(4),
                ),
                Row(children: [
                  Expanded(
                      child: Column(children: [
                        Row(children: [Text(CL.of(c).l.likes, style: TextStyle(fontSize: 13))]),
                        Padding(
                          padding: EdgeInsets.all(2),
                        ),
                        Row(children: [
                          Text("+" + compactFormat.format(likesToday.toInt()),
                              style: TextStyle(
                                  fontSize: 25, color: Color.fromARGB(255, 110, 110, 110)))
                        ]),
                      ]),
                      flex: 1),
                  Expanded(
                      child: Column(children: [
                        Row(children: [Text(CL.of(c).l.followers, style: TextStyle(fontSize: 13))]),
                        Padding(
                          padding: EdgeInsets.all(2),
                        ),
                        Row(children: [
                          Text("+" + compactFormat.format(followersToday.toInt()),
                              style: TextStyle(
                                  fontSize: 25, color: Color.fromARGB(255, 110, 110, 110)))
                        ]),
                      ]),
                      flex: 1)
                ]),
                Padding(padding: EdgeInsets.all(8)),
                Row(children: [
                  Flexible(
                      child: Text(CL.of(c).l.statsHint,
                          style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic)))
                ])
              ])),
          HorizontalDivider(),
          Container(
              color: Colors.white,
              padding: EdgeInsets.all(24),
              child: Column(children: [
                Row(children: [
                  Text(CL.of(c).l.sevenDays,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                ]),
                Padding(padding: EdgeInsets.all(8)),
                Row(children: [Text(CL.of(c).l.revenue)]),
                Padding(
                    padding: EdgeInsets.all(0),
                    child: SizedBox(
                      height: 200.0,
                      child: TimeSeriesLineAnnotationChart(getRevenueStatistics(dailyStatistics)),
                    )),
                Padding(padding: EdgeInsets.all(12)),
                Row(children: [Text(CL.of(c).l.likes)]),
                Padding(
                    padding: EdgeInsets.all(0),
                    child: SizedBox(
                      height: 200.0,
                      child: TimeSeriesLineAnnotationChart(getLikeStatistics(dailyStatistics)),
                    )),
                Padding(padding: EdgeInsets.all(12)),
                Row(children: [Text(CL.of(c).l.followers)]),
                Padding(
                    padding: EdgeInsets.all(0),
                    child: SizedBox(
                      height: 200.0,
                      child: TimeSeriesLineAnnotationChart(getFollowerStatistics(dailyStatistics)),
                    ))
              ])),
          HorizontalDivider(),
          Padding(padding: EdgeInsets.all(16))
        ]));
  }

  List<charts.Series<TimeSeriesContainer, DateTime>> getRevenueStatistics(
      List<DailyStatistic> dailyStatistics) {
    List<TimeSeriesContainer> data = List();
    for (DailyStatistic dailyStatistic in dailyStatistics) {
      data.add(TimeSeriesContainer(
          DateTime.fromMillisecondsSinceEpoch(dailyStatistic.day * 86400000),
          dailyStatistic.money.toInt()));
    }
    return [
      charts.Series<TimeSeriesContainer, DateTime>(
        id: 'likes',
        domainFn: (TimeSeriesContainer sales, _) => sales.time,
        measureFn: (TimeSeriesContainer sales, _) => sales.value,
        data: data,
      )
    ];
  }

  List<charts.Series<TimeSeriesContainer, DateTime>> getFollowerStatistics(
      List<DailyStatistic> dailyStatistics) {
    List<TimeSeriesContainer> data = List();
    for (DailyStatistic dailyStatistic in dailyStatistics) {
      data.add(TimeSeriesContainer(
          DateTime.fromMillisecondsSinceEpoch(dailyStatistic.day * 86400000),
          dailyStatistic.followers.toInt()));
    }
    return [
      charts.Series<TimeSeriesContainer, DateTime>(
        id: 'likes',
        domainFn: (TimeSeriesContainer sales, _) => sales.time,
        measureFn: (TimeSeriesContainer sales, _) => sales.value,
        data: data,
      )
    ];
  }

  List<charts.Series<TimeSeriesContainer, DateTime>> getLikeStatistics(
      List<DailyStatistic> dailyStatistics) {
    List<TimeSeriesContainer> data = List();
    for (DailyStatistic dailyStatistic in dailyStatistics) {
      data.add(TimeSeriesContainer(
          DateTime.fromMillisecondsSinceEpoch(dailyStatistic.day * 86400000),
          dailyStatistic.likes.toInt()));
    }
    return [
      charts.Series<TimeSeriesContainer, DateTime>(
        id: 'likes',
        domainFn: (TimeSeriesContainer sales, _) => sales.time,
        measureFn: (TimeSeriesContainer sales, _) => sales.value,
        data: data,
      )
    ];
  }

  List<DailyStatistic> getDailyStatisticsOfLast7DaysIncludingToday() {
    List<DailyStatistic> statistics = List();
    int today = TimeUtils.todayAsDay();
    for (int i = 0; i < 7; i++) {
      int dayBeforeToday = today - i;
      if (Data.dailyStatistics.containsKey(dayBeforeToday)) {
        statistics.add(Data.dailyStatistics[dayBeforeToday]);
      } else {
        statistics.add(DailyStatistic(dayBeforeToday, 0, 0, 0));
      }
    }
    return statistics;
  }
}

class TimeSeriesLineAnnotationChart extends StatelessWidget {
  final List<charts.Series> seriesList;

  TimeSeriesLineAnnotationChart(this.seriesList);

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(seriesList,
        animate: false,
        primaryMeasureAxis: charts.NumericAxisSpec(
            tickFormatterSpec: charts.BasicNumericTickFormatterSpec((i) => compactFormat.format(i)),
            tickProviderSpec: charts.BasicNumericTickProviderSpec(
                desiredMinTickCount: 5, desiredMaxTickCount: 5)),
        domainAxis:
            charts.DateTimeAxisSpec(tickProviderSpec: charts.DayTickProviderSpec(increments: [1])));
  }
}

/// Sample time series data type.
class TimeSeriesContainer {
  final DateTime time;
  final int value;

  TimeSeriesContainer(this.time, this.value);
}
