import 'package:flutter/material.dart';
import 'package:personal_finance_app/features/finances/models/transaction_model.dart';

class TransactionListScreen extends StatelessWidget {
  final String type;
  final List<TransactionModel> transactions;

  const TransactionListScreen({
    super.key,
    required this.type,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$type Transactions')),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final txn = transactions[index];
          return ListTile(
            leading: Icon(
              type == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
              color: type == 'income' ? Colors.green : Colors.red,
            ),
            title: Text(txn.title),
            subtitle: Text(txn.date.toLocal().toString().split(' ')[0]),
            trailing: Text('Rs. ${txn.amount.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
