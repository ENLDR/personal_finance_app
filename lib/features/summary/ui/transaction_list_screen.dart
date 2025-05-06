import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_app/features/finances/models/transaction_model.dart';

class TransactionListScreen extends StatelessWidget {
  final String type;
  final List<TransactionModel> transactions;

  const TransactionListScreen({
    super.key,
    required this.type,
    required this.transactions,
  });

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${type[0].toUpperCase()}${type.substring(1)} Transactions',
        ),
      ),
      body:
          transactions.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, size: 60, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'No $type transactions found.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final txn = transactions[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      // onTap: () {},
                      leading: CircleAvatar(
                        backgroundColor:
                            type == 'income'
                                ? Colors.green[100]
                                : Colors.red[100],
                        child: Icon(
                          type == 'income'
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: type == 'income' ? Colors.green : Colors.red,
                        ),
                      ),
                      title: Text(
                        txn.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(formatDate(txn.date)),
                      trailing: Text(
                        'Rs. ${txn.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: type == 'income' ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
