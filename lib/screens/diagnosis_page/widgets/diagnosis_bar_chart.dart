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

  // Función para convertir fechas como "14 mayo 2025 13:31:38"
  DateTime parseSpanishDate(String input) {
    final months = {
      'enero': '01',
      'febrero': '02',
      'marzo': '03',
      'abril': '04',
      'mayo': '05',
      'junio': '06',
      'julio': '07',
      'agosto': '08',
      'septiembre': '09',
      'octubre': '10',
      'noviembre': '11',
      'diciembre': '12',
    };

    final parts = input.split(' ');
    if (parts.length < 4) return DateTime.now(); // fallback por seguridad

    final day = parts[0];
    final month = months[parts[1].toLowerCase()] ?? '01';
    final year = parts[2];
    final time = parts[3];

    final formatted = "$day/$month/$year $time";
    return DateFormat("d/MM/yyyy HH:mm:ss").parse(formatted);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<FlSpot>> seriesMap = {
      for (var key in classColors.keys) key: [],
    };

    final sortedList = diagnosisList
        .where((d) => d.predictions != null)
        .toList()
      ..sort((a, b) => parseSpanishDate(a.predictionDate ?? '')
          .compareTo(parseSpanishDate(b.predictionDate ?? '')));

    for (int i = 0; i < sortedList.length; i++) {
      final diagnosis = sortedList[i];
      final Map<String, double> confidenceMap = {
        for (var className in classColors.keys) className: 0.0
      };

      for (var pred in diagnosis.predictions!) {
        String className = pred['class_name'];
        double confidence = (pred['confidence'] as num).toDouble();

        if (confidenceMap[className] != null) {
          confidenceMap[className] = confidence > confidenceMap[className]!
              ? confidence
              : confidenceMap[className]!;
        }
      }

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
            width: sortedList.length * 45,
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
                          final date = parseSpanishDate(
                              sortedList[index].predictionDate ?? '');
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              DateFormat("MM/dd").format(date),
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.black),
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
                            style: const TextStyle(
                                fontSize: 10, color: Colors.black),
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
                color: Colors.black,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
