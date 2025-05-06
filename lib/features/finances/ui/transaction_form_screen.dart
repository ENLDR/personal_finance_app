import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_app/features/finances/bloc/finances_bloc.dart';
import 'package:personal_finance_app/features/finances/bloc/finances_event.dart';
import 'package:personal_finance_app/features/finances/models/transaction_model.dart';
import 'package:uuid/uuid.dart';

class TransactionFormScreen extends StatefulWidget {
  final TransactionModel? txn;
  const TransactionFormScreen({super.key, this.txn});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0;
  String _type = 'expense';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.txn != null) {
      _title = widget.txn!.title;
      _amount = widget.txn!.amount;
      _type = widget.txn!.type;
      _selectedDate = widget.txn!.date;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newTxn = TransactionModel(
        id: widget.txn?.id ?? const Uuid().v4(),
        title: _title,
        amount: _amount,
        date: _selectedDate,
        type: _type,
      );

      final bloc = context.read<FinanceBloc>();
      if (widget.txn == null) {
        bloc.add(AddTransactionEvent(newTxn));
      } else {
        bloc.add(UpdateTransactionEvent(newTxn));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.txn == null
                ? 'Transaction added successfully!'
                : 'Transaction updated successfully!',
          ),
        ),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.txn == null ? "Add Transaction" : "Edit Transaction",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onSaved: (value) => _title = value!,
                validator:
                    (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _amount != 0 ? _amount.toString() : '',
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onSaved: (value) => _amount = double.parse(value!),
                validator:
                    (value) =>
                        value!.isEmpty || double.tryParse(value) == null
                            ? 'Enter a valid amount'
                            : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'expense', child: Text('Expense')),
                  DropdownMenuItem(value: 'income', child: Text('Income')),
                ],
                onChanged: (value) => setState(() => _type = value!),
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  "Date: ${_selectedDate.toLocal().toString().split(' ')[0]}",
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
