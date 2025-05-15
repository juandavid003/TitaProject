import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:odontobb/models/diagnosis_model.dart';

class DiagnosisLineChart extends StatelessWidget {
  final List<DiagnosisModel> diagnosisList;

  DiagnosisLineChart({required this.diagnosisList});

  final Map<String, Color> classColors = {
    'Calculo': Colors.indigo,
    'Carie': Colors.red,
    'Gingivitis': Colors.orange,
    'Hipodoncia': Colors.pink,
    'Placa': Colors.blue,
    'Ulcera': Colors.deepPurple,
  };

  @override
@override
Widget build(BuildContext context) {
  final Map<String, List<FlSpot>> seriesMap = {
    for (var key in classColors.keys) key: [],
  };

  final sortedList = diagnosisList
      .where((d) => d.predictions != null)
      .toList()
    ..sort((a, b) => a.predictionDate!.compareTo(b.predictionDate!));

  for (int i = 0; i < sortedList.length; i++) {
    final diagnosis = sortedList[i];
    final Map<String, double> confidenceMap = {
      for (var className in classColors.keys) className: 0.0
    };

    for (var pred in diagnosis.predictions!) {
      String className = pred['class_name'];
      double confidence = (pred['confidence'] as num).toDouble();

      // Guardar el mayor valor para cada clase (si hay varios)
      if (confidenceMap[className] != null) {
        confidenceMap[className] =
            confidence > confidenceMap[className]! ? confidence : confidenceMap[className]!;
      }
    }

    // Añadir un punto para cada clase (aunque sea 0)
    confidenceMap.forEach((className, confidence) {
      seriesMap[className]!.add(FlSpot(i.toDouble(), confidence));
    });
  }

  final lines = seriesMap.entries.map((entry) {
    return LineChartBarData(
      spots: entry.value,
      isCurved: false,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      color: classColors[entry.key] ?? Colors.grey,
      barWidth: 3,
    );
  }).toList();

return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: sortedList.length * 45, // ← puedes ajustar esto para más o menos espacio
        height: 275,
        child: LineChart(
          LineChartData(
            lineBarsData: lines,
           titlesData: FlTitlesData(
  bottomTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        int index = value.toInt();
        if (index >= 0 && index < sortedList.length) {
          final date = DateFormat("d MMMM y H:mm:ss", 'es').parse(sortedList[index].predictionDate ?? '');
          return SideTitleWidget(
            axisSide: meta.axisSide,
            child: Text(
              DateFormat.Md().format(date ?? DateTime.now()),
              style: const TextStyle(fontSize: 10, color: Colors.black), // ← color negro
            ),
          );
        }
        return const Text('');
      },
    ),
  ),
  leftTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text(
          value.toInt().toString(),
            style: const TextStyle(fontSize: 10, color: Colors.black), // ← color negro
          ),
        );
      },
    ),
  ),
),
borderData: FlBorderData(show: true),
            gridData: FlGridData(show: true),
          ),
        ),
      ),
    ),
    const SizedBox(height: 5),
    buildLegend(classColors),
  ],
);
}

   Widget buildLegend(Map<String, Color> colors) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: colors.entries.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: entry.value,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              entry.key,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black, // <- Texto en negro
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
