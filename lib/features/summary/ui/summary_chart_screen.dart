import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:personal_finance_app/features/summary/ui/transaction_list_screen.dart';
import 'package:personal_finance_app/features/summary/widget/summary_card.dart';
import 'package:personal_finance_app/features/finances/bloc/finances_bloc.dart';
import 'package:personal_finance_app/features/finances/bloc/finances_state.dart';

class SummaryChartScreen extends StatefulWidget {
  const SummaryChartScreen({super.key});

  @override
  State<SummaryChartScreen> createState() => _SummaryChartScreenState();
}

class _SummaryChartScreenState extends State<SummaryChartScreen> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Summary Chart")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<FinanceBloc, FinanceState>(
          builder: (context, state) {
            if (state is FinanceLoaded) {
              final income = state.totalIncome;
              final expense = state.totalExpense;

              return Column(
                children: [
                  const Text(
                    'Income vs Expenses',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          buildSummaryRow(
                            "Total Income",
                            state.totalIncome,
                            Colors.green,
                          ),
                          buildSummaryRow(
                            "Total Expenses",
                            state.totalExpense,
                            Colors.red,
                          ),
                          const Divider(),
                          buildSummaryRow(
                            "Balance",
                            state.balance,
                            state.balance >= 0 ? Colors.blue : Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AspectRatio(
                    aspectRatio: 1.3,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 6,
                        centerSpaceRadius: 50,
                        sections: showingSections(income, expense),
                        pieTouchData: PieTouchData(
                          touchCallback: (event, pieTouchResponse) {
                            final touchedSection =
                                pieTouchResponse?.touchedSection;
                            final index = touchedSection?.touchedSectionIndex;

                            setState(() {
                              touchedIndex = index;
                            });

                            // Only proceed if it's a tap and a valid section is touched
                            if (event is FlTapUpEvent &&
                                touchedSection != null &&
                                touchedSection.touchedSection != null) {
                              final section = touchedSection.touchedSection!;
                              final value = section.value;

                              // Ensure value is not zero (ignore empty slices or empty space)
                              if (value > 0) {
                                final selectedType =
                                    index == 0 ? 'income' : 'expense';
                                

                                final transactions =
                                    (context.read<FinanceBloc>().state
                                            as FinanceLoaded)
                                        .transactions
                                        .where(
                                          (txn) =>
                                              txn.type.toLowerCase() ==
                                              selectedType,
                                        )
                                        .toList();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => TransactionListScreen(
                                          type: selectedType,
                                          transactions: transactions,
                                        ),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (touchedIndex != null && touchedIndex != -1)
                    Column(
                      children: [
                        Text(
                          touchedIndex == 0 ? "Income" : "Expense",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          touchedIndex == 0
                              ? "Rs. ${income.toStringAsFixed(2)}"
                              : "Rs. ${expense.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                ],
              );
            } else if (state is FinanceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text("No data available."));
            }
          },
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(double income, double expense) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double radius = isTouched ? 90 : 80;
      final isIncome = i == 0;
      final value = isIncome ? income : expense;
      final color = isIncome ? Colors.green : Colors.red;
      final title = "${(value / (income + expense) * 100).toStringAsFixed(1)}%";

      return PieChartSectionData(
        color: color,
        value: value,
        title: title,
        radius: radius,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      );
    });
  }
}
