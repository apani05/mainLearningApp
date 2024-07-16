import 'package:bfootlearn/components/color_file.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CircularGraph extends StatelessWidget {
  final int quizScore;
  final int totalQuestions;

  CircularGraph({
    required this.quizScore,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Correct', quizScore.toDouble(), green),
      ChartData('Incorrect', (totalQuestions - quizScore).toDouble(), red),
    ];

    return Container(
      height: 300,
      child: SfCircularChart(
        series: <CircularSeries>[
          // Render pie chart
          PieSeries<ChartData, String>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            pointColorMapper: (ChartData data, _) => data.color,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String x;
  final double y;
  final Color? color;

  ChartData(this.x, this.y, [this.color]);
}
