import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:kakeibo/features/categories/presentation/providers/category_provider.dart';
import 'package:kakeibo/features/statistics/presentation/providers/statistics_provider.dart';
import 'package:kakeibo/features/statistics/presentation/widgets/spending_donut_chart.dart';
import 'package:kakeibo/features/statistics/presentation/widgets/monthly_trend_chart.dart';
import 'package:kakeibo/features/statistics/presentation/widgets/category_breakdown_list.dart';
import 'package:kakeibo/features/statistics/presentation/widgets/stat_summary_card.dart';
import 'package:kakeibo/features/statistics/presentation/widgets/year_selector.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Statistics', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w600)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(text: 'Monthly'),
            Tab(text: 'Yearly'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMonthlyTab(context, ref),
          _buildYearlyTab(context, ref),
        ],
      ),
    );
  }

  Widget _buildMonthlyTab(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedStatsMonthProvider);
    final statsAsync = ref.watch(monthlyStatsProvider);
    final categoriesAsync = ref.watch(allCategoriesProvider);

    return Column(
      children: [
        YearSelector(
          value: DateFormat('MMMM yyyy').format(selectedDate),
          onPrevious: () {
            ref.read(selectedStatsMonthProvider.notifier).state = DateTime(selectedDate.year, selectedDate.month - 1);
          },
          onNext: () {
            ref.read(selectedStatsMonthProvider.notifier).state = DateTime(selectedDate.year, selectedDate.month + 1);
          },
        ),
        Expanded(
          child: statsAsync.when(
            loading: () => Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)),
            error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(color: Theme.of(context).colorScheme.error))),
            data: (stats) {
              return categoriesAsync.when(
                loading: () => Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)),
                error: (err, stack) => Center(child: Text('Error: $err')),
                data: (categories) {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          StatSummaryCard(label: 'Total Spent', value: '₹${stats.totalSpent.toStringAsFixed(0)}', icon: Icons.account_balance_wallet_outlined),
                          StatSummaryCard(label: 'Daily Average', value: '₹${stats.dailyAverage.toStringAsFixed(0)}', icon: Icons.show_chart),
                          StatSummaryCard(label: 'No-Spend Days', value: '${stats.noSpendDays}', icon: Icons.event_available_outlined),
                          StatSummaryCard(label: 'Transactions', value: '${stats.totalTransactions}', icon: Icons.receipt_outlined),
                        ].animate(interval: 100.ms).fade().slideY(begin: 0.2),
                      ),
                      const SizedBox(height: 24),
                      if (stats.totalSpent > 0) ...[
                        Text('Spending Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface))
                            .animate().fade(delay: 400.ms),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 250,
                          child: SpendingDonutChart(
                            categoryTotals: stats.categoryTotals,
                            categories: categories,
                            total: stats.totalSpent,
                          ).animate().fade(delay: 500.ms).scale(duration: 400.ms, curve: Curves.easeOutBack),
                        ),
                        const SizedBox(height: 24),
                        Text('Daily Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface))
                            .animate().fade(delay: 600.ms),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: MonthlyTrendChart(
                            data: stats.dailyTotals,
                            isYearly: false,
                          ).animate().fade(delay: 700.ms),
                        ),
                        const SizedBox(height: 24),
                        Text('Category Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface))
                            .animate().fade(delay: 800.ms),
                        const SizedBox(height: 16),
                        CategoryBreakdownList(
                          categoryTotals: stats.categoryTotals,
                          categories: categories,
                          total: stats.totalSpent,
                        ).animate().fade(delay: 900.ms),
                      ] else ...[
                        const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Center(
                            child: Text('No spending for this month', style: TextStyle(color: Colors.grey, fontSize: 16)),
                          ),
                        )
                      ],
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildYearlyTab(BuildContext context, WidgetRef ref) {
    final selectedYear = ref.watch(selectedStatsYearProvider);
    final statsAsync = ref.watch(yearlyStatsProvider);
    final categoriesAsync = ref.watch(allCategoriesProvider);

    return Column(
      children: [
        YearSelector(
          value: selectedYear.toString(),
          onPrevious: () => ref.read(selectedStatsYearProvider.notifier).state--,
          onNext: () => ref.read(selectedStatsYearProvider.notifier).state++,
        ),
        Expanded(
          child: statsAsync.when(
            loading: () => Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)),
            error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(color: Theme.of(context).colorScheme.error))),
            data: (stats) {
              return categoriesAsync.when(
                loading: () => Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)),
                error: (err, stack) => Center(child: Text('Error: $err')),
                data: (categories) {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          StatSummaryCard(label: 'Total Spent', value: '₹${stats.totalSpent.toStringAsFixed(0)}', icon: Icons.account_balance_wallet_outlined),
                          StatSummaryCard(label: 'Monthly Average', value: '₹${stats.monthlyAverage.toStringAsFixed(0)}', icon: Icons.calendar_month_outlined),
                          StatSummaryCard(label: 'Transactions', value: '${stats.totalTransactions}', icon: Icons.receipt_outlined),
                          StatSummaryCard(label: 'Top Month', value: stats.highestMonth != null ? DateFormat('MMM').format(DateTime(stats.year, stats.highestMonth!)) : '-', icon: Icons.trending_up),
                        ].animate(interval: 100.ms).fade().slideY(begin: 0.2),
                      ),
                      const SizedBox(height: 24),
                      if (stats.totalSpent > 0) ...[
                        Text('Monthly Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface))
                            .animate().fade(delay: 400.ms),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: MonthlyTrendChart(
                            data: stats.monthlyTotals,
                            isYearly: true,
                          ).animate().fade(delay: 500.ms),
                        ),
                        const SizedBox(height: 24),
                        Text('Category Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface))
                            .animate().fade(delay: 600.ms),
                        const SizedBox(height: 16),
                        CategoryBreakdownList(
                          categoryTotals: stats.categoryTotals,
                          categories: categories,
                          total: stats.totalSpent,
                        ).animate().fade(delay: 700.ms),
                      ] else ...[
                        const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Center(
                            child: Text('No spending for this year', style: TextStyle(color: Colors.grey, fontSize: 16)),
                          ),
                        )
                      ],
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
