import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/models/bar_chart_model.dart';

class BarChartGraph extends StatelessWidget {
  final List<BarChartModel> data;

  const BarChartGraph({super.key, required this.data});

  @override
@override
Widget build(BuildContext context) {
  return SizedBox(
    height: 200, 
    child: Column(
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              barGroups: _buildBarGroups(),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: _getBottomTitles,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}

  List<BarChartGroupData> _buildBarGroups() {
    return data.asMap().entries.map((entry) {
      int index = entry.key;
      BarChartModel model = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (model.cant?? 0).toDouble(),
            color: kButtonColor,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    int index = value.toInt();
    if (index < 0 || index >= data.length) return Container();

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        data[index].weekday ?? '',
        style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
      ),
    );
  }
}
