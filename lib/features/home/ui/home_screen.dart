import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_app/core/common/bloc/theme_bloc.dart';
import 'package:personal_finance_app/core/common/bloc/theme_event.dart';
import 'package:personal_finance_app/features/summary/widget/summary_card.dart';
import 'package:personal_finance_app/features/auth/bloc/auth_bloc.dart';
import 'package:personal_finance_app/features/auth/bloc/auth_event.dart';
import 'package:personal_finance_app/features/auth/bloc/auth_state.dart';
import 'package:personal_finance_app/features/auth/ui/login_screen.dart';

import 'package:personal_finance_app/features/finances/bloc/finances_bloc.dart';
import 'package:personal_finance_app/features/finances/bloc/finances_event.dart';
import 'package:personal_finance_app/features/finances/bloc/finances_state.dart';
import 'package:personal_finance_app/features/summary/ui/summary_chart_screen.dart';
import 'package:personal_finance_app/features/finances/ui/transaction_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("My Finances")),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('Settings', style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text('Toggle Theme'),
                onTap: () {
                  context.read<ThemeBloc>().add(ToggleThemeEvent());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.pie_chart),
                title: const Text('Chart Summary'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SummaryChartScreen(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),

        body: BlocBuilder<FinanceBloc, FinanceState>(
          builder: (context, state) {
            if (state is FinanceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FinanceLoaded) {
              return Column(
                children: [
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.transactions.length,
                      itemBuilder: (context, index) {
                        final txn = state.transactions[index];
                        return ListTile(
                          leading: Icon(
                            txn.type == 'income'
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color:
                                txn.type == 'income'
                                    ? Colors.green
                                    : Colors.red,
                          ),
                          title: Text(txn.title),
                          subtitle: Text(
                            txn.date.toLocal().toString().split(' ')[0],
                          ),
                          trailing: SizedBox(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '\$${txn.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color:
                                        txn.type == 'income'
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => TransactionFormScreen(
                                                txn: state.transactions[index],
                                              ),
                                        ),
                                      );
                                      if (result == true) {
                                        context.read<FinanceBloc>().add(
                                          LoadTransactionsEvent(),
                                        );
                                      }
                                    } else if (value == 'delete') {
                                      context.read<FinanceBloc>().add(
                                        DeleteTransactionEvent(txn.id),
                                      );
                                    }
                                  },
                                  itemBuilder:
                                      (context) => const [
                                        PopupMenuItem(
                                          value: 'edit',
                                          child: Text("Edit"),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Text("Delete"),
                                        ),
                                      ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is FinanceError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text("No transactions found."));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TransactionFormScreen()),
            );
            if (result == true) {
              context.read<FinanceBloc>().add(LoadTransactionsEvent());
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
