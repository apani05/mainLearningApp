import 'package:bfootlearn/Phrases/models/quiz_model.dart';
import 'package:bfootlearn/components/color_file.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}

class QuizBarData {
  // Function to calculate the score for each series type
  static Map<String, double> calculateSeriesTypeScore(List<Quiz> quizResults) {
    // Initialize a map to store correct answers and total questions by series type
    Map<String, int> correctAnswersMap = {};
    Map<String, int> totalQuestionsMap = {};

    // Populate the maps with the count of correct answers and total questions for each series type
    for (var quizResult in quizResults) {
      for (var question in quizResult.questionSet) {
        String seriesType = question.seriesType;
        bool isCorrect = question.selectedAnswer == question.correctAnswer;

        if (!correctAnswersMap.containsKey(seriesType)) {
          correctAnswersMap[seriesType] = 0;
          totalQuestionsMap[seriesType] = 0;
        }

        if (isCorrect) {
          correctAnswersMap[seriesType] = correctAnswersMap[seriesType]! + 1;
        }
        totalQuestionsMap[seriesType] = totalQuestionsMap[seriesType]! + 1;
      }
    }

    // Calculate the score for each series type as a percentage out of 10
    Map<String, double> seriesTypeScores = {};
    correctAnswersMap.forEach((seriesType, correctAnswers) {
      int totalQuestions = totalQuestionsMap[seriesType]!;
      double score = (correctAnswers / totalQuestions) * 10;
      seriesTypeScores[seriesType] = double.parse(score.toStringAsFixed(1));
    });

    return seriesTypeScores;
  }

  // Function to build the bar graph
  static Widget buildBarGraph(Map<String, double> seriesTypeScores) {
    final List<ChartData> chartData = seriesTypeScores.entries
        .map((entry) => ChartData(entry.key, entry.value))
        .toList();

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        labelRotation: 70,
        labelStyle: TextStyle(
          fontSize: 12,
        ),
      ),
      series: <CartesianSeries<ChartData, String>>[
        ColumnSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          dataLabelSettings: DataLabelSettings(isVisible: true),
          color: purpleDark,
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}
