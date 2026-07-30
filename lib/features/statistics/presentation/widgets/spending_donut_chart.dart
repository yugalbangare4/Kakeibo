import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kakeibo/features/categories/domain/entities/category.dart';
import 'package:kakeibo/core/theme/app_colors.dart';

class SpendingDonutChart extends StatefulWidget {
  final Map<int, double> categoryTotals;
  final List<Category> categories;
  final double total;

  const SpendingDonutChart({
    super.key,
    required this.categoryTotals,
    required this.categories,
    required this.total,
  });

  @override
  State<SpendingDonutChart> createState() => _SpendingDonutChartState();
}

class _SpendingDonutChartState extends State<SpendingDonutChart> {
  int touchedIndex = -1;



  @override
  Widget build(BuildContext context) {
    if (widget.categoryTotals.isEmpty || widget.total == 0) {
      return const Center(child: Text('No data'));
    }

    final sections = <PieChartSectionData>[];
    int index = 0;
    
    // Sort to make chart look consistent
    final sortedEntries = widget.categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (var entry in sortedEntries) {
      if (entry.value <= 0) continue;
      
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 16.0 : 0.0;
      final radius = isTouched ? 60.0 : 50.0;
      
      final category = widget.categories.firstWhere(
        (c) => c.id == entry.key,
        orElse: () => Category(name: 'Unknown', iconName: 'circle', colorIndex: 0, sortOrder: 0, createdAt: DateTime.now()),
      );
      
      final color = AppColors.categoryColors[category.colorIndex % AppColors.categoryColors.length];
      final percentage = (entry.value / widget.total) * 100;

      sections.add(
        PieChartSectionData(
          color: color,
          value: entry.value,
          title: isTouched ? '${percentage.toStringAsFixed(1)}%' : '',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      index++;
    }

    if (sections.isEmpty) {
      return const Center(child: Text('No data'));
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
            borderData: FlBorderData(show: false),
            sectionsSpace: 2,
            centerSpaceRadius: 60,
            sections: sections,
          ),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Total',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              '₹${widget.total.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ),
      ],
    );
  }
}
