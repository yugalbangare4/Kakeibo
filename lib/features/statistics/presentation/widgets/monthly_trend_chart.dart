import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthlyTrendChart extends StatelessWidget {
  final Map<int, double> data;
  final bool isYearly;

  const MonthlyTrendChart({
    super.key,
    required this.data,
    required this.isYearly,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No trend data'));
    }

    final maxKey = isYearly ? 12 : 31;
    final List<FlSpot> spots = [];
    double maxY = 0;

    for (int i = 1; i <= maxKey; i++) {
      final val = data[i] ?? 0.0;
      if (val > maxY) maxY = val;
      spots.add(FlSpot(i.toDouble(), val));
    }
    
    // Add some padding to maxY so line doesn't hit top
    maxY = maxY > 0 ? maxY * 1.2 : 10;

    final primaryColor = Theme.of(context).colorScheme.primary;

    if (isYearly) {
      // Bar Chart for yearly
      return BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Theme.of(context).colorScheme.secondary,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '₹${rod.toY.toStringAsFixed(0)}',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
                  if (value.toInt() < 1 || value.toInt() > 12) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(months[value.toInt() - 1], style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey)),
                  );
                },
                reservedSize: 28,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value == maxY) return const SizedBox.shrink();
                  return Text(
                    value >= 1000 ? '${(value / 1000).toStringAsFixed(1)}k' : value.toStringAsFixed(0),
                    style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 4,
            getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withValues(alpha: 0.2), strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          barGroups: spots.map((spot) {
            return BarChartGroupData(
              x: spot.x.toInt(),
              barRods: [
                BarChartRodData(
                  toY: spot.y,
                  color: primaryColor,
                  width: 12,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                )
              ],
            );
          }).toList(),
        ),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
      );
    }

    // Line Chart for monthly
    return LineChart(
      LineChartData(
        minX: 1,
        maxX: maxKey.toDouble(),
        minY: 0,
        maxY: maxY,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Theme.of(context).colorScheme.secondary,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '₹${spot.y.toStringAsFixed(0)}',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withValues(alpha: 0.2), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 5,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(value.toInt().toString(), style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey)),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: maxY / 4,
              getTitlesWidget: (value, meta) {
                if (value == maxY || value == 0) return const SizedBox.shrink();
                return Text(
                  value >= 1000 ? '${(value / 1000).toStringAsFixed(1)}k' : value.toStringAsFixed(0),
                  style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: primaryColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  primaryColor.withValues(alpha: 0.3),
                  primaryColor.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    );
  }
}
