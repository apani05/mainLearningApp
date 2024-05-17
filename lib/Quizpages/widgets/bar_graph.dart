import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../../Phrases/provider/blogProvider.dart';

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}

class QuizBarData {
  // Function to calculate daily average quiz score considering multiple attempts per day
  static double calculateDailyAverage(List<Quiz> quizResults) {
    // Sort quizResults by dateSubmitted in ascending order
    quizResults.sort((a, b) => a.dateSubmitted.compareTo(b.dateSubmitted));

    // Initialize a map to store daily quiz scores
    Map<DateTime, List<int>> dailyScoresMap = {};

    // Populate dailyScoresMap with quiz scores grouped by date
    for (var quizResult in quizResults) {
      DateTime date = (quizResult.dateSubmitted).toDate();
      dailyScoresMap.putIfAbsent(date, () => []);
      dailyScoresMap[date]!.add(quizResult.quizScore);
    }

    // Calculate daily averages
    List<double> dailyAverages = [];
    dailyScoresMap.forEach((date, scores) {
      double dailyAverage = scores.isNotEmpty
          ? scores.reduce((a, b) => a + b) / scores.length
          : 0.0;
      dailyAverages.add(dailyAverage);
    });

    // Calculate the overall daily average
    double overallDailyAverage = dailyAverages.isNotEmpty
        ? dailyAverages.reduce((a, b) => a + b) / dailyAverages.length
        : 0.0;

    return overallDailyAverage;
  }

  // Function to calculate weekly average quiz score
  static double calculateWeeklyAverage(List<Quiz> quizResults) {
    // Sort quizResults by dateSubmitted in ascending order
    quizResults.sort((a, b) => a.dateSubmitted.compareTo(b.dateSubmitted));

    // Initialize a map to store weekly quiz scores
    Map<int, List<int>> weeklyScoresMap = {};

    // Populate weeklyScoresMap with quiz scores grouped by week
    for (var quizResult in quizResults) {
      DateTime date = (quizResult.dateSubmitted).toDate();
      int weekNumber = getWeekNumber(date);
      weeklyScoresMap.putIfAbsent(weekNumber, () => []);
      weeklyScoresMap[weekNumber]!.add(quizResult.quizScore);
    }

    // Calculate weekly averages
    List<double> weeklyAverages = [];
    weeklyScoresMap.forEach((week, scores) {
      double weeklyAverage = scores.isNotEmpty
          ? scores.reduce((a, b) => a + b) / scores.length
          : 0.0;
      weeklyAverages.add(weeklyAverage);
    });

    // Calculate the overall weekly average
    double overallWeeklyAverage = weeklyAverages.isNotEmpty
        ? weeklyAverages.reduce((a, b) => a + b) / weeklyAverages.length
        : 0.0;

    return overallWeeklyAverage;
  }

  // Function to calculate monthly average quiz score
  static double calculateMonthlyAverage(List<Quiz> quizResults) {
    // Sort quizResults by dateSubmitted in ascending order
    quizResults.sort((a, b) => a.dateSubmitted.compareTo(b.dateSubmitted));

    // Initialize a map to store monthly quiz scores
    Map<int, List<int>> monthlyScoresMap = {};

    // Populate monthlyScoresMap with quiz scores grouped by month
    for (var quizResult in quizResults) {
      DateTime date = (quizResult.dateSubmitted).toDate();
      int monthNumber = date.month;
      monthlyScoresMap.putIfAbsent(monthNumber, () => []);
      monthlyScoresMap[monthNumber]!.add(quizResult.quizScore);
    }

    // Calculate monthly averages
    List<double> monthlyAverages = [];
    monthlyScoresMap.forEach((month, scores) {
      double monthlyAverage = scores.isNotEmpty
          ? scores.reduce((a, b) => a + b) / scores.length
          : 0.0;
      monthlyAverages.add(monthlyAverage);
    });

    // Calculate the overall monthly average
    double overallMonthlyAverage = monthlyAverages.isNotEmpty
        ? monthlyAverages.reduce((a, b) => a + b) / monthlyAverages.length
        : 0.0;

    return overallMonthlyAverage;
  }

  // Function to build the bar graph
  static Widget buildBarGraph(
      double weeklyAverage, double dailyAverage, double monthlyAverage) {
    final List<ChartData> chartData = [
      ChartData('Daily', dailyAverage),
      ChartData('Weekly', weeklyAverage),
      ChartData('Monthly', monthlyAverage),
    ];

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <CartesianSeries<ChartData, String>>[
        ColumnSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ],
    );
  }

  static int getWeekNumber(DateTime date) {
    // Get the day of the year
    int dayOfYear = int.parse(DateFormat("D").format(date));

    // Calculate the week number based on the ISO 8601 standard
    int weekNumber = ((dayOfYear - date.weekday + 10) / 7).floor();

    // If the week number is 0, it means the week belongs to the previous year
    if (weekNumber == 0) {
      DateTime lastDayOfPreviousYear = DateTime(date.year - 1, 12, 31);
      int lastWeekOfPreviousYear =
          getWeekNumber(lastDayOfPreviousYear); // Recursive call
      weekNumber = lastWeekOfPreviousYear;
    }

    return weekNumber;
  }
}
