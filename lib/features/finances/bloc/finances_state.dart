import 'package:equatable/equatable.dart';
import 'package:personal_finance_app/features/finances/models/transaction_model.dart';

abstract class FinanceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FinanceInitial extends FinanceState {}

class FinanceLoading extends FinanceState {}

class FinanceLoaded extends FinanceState {
  final List<TransactionModel> transactions;

  FinanceLoaded(this.transactions);

  double get totalIncome => transactions
      .where((t) => t.type == 'income')
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => transactions
      .where((t) => t.type == 'expense')
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  @override
  List<Object?> get props => [transactions];
}

class FinanceError extends FinanceState {
  final String message;

  FinanceError(this.message);

  @override
  List<Object?> get props => [message];
}
