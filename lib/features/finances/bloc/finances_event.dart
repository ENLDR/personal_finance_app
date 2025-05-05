import 'package:equatable/equatable.dart';
import 'package:personal_finance_app/features/finances/models/transaction_model.dart';

abstract class FinanceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTransactionsEvent extends FinanceEvent {}


class AddTransactionEvent extends FinanceEvent {
  final TransactionModel txn;

  AddTransactionEvent(this.txn);

  @override
  List<Object?> get props => [txn];
}

class UpdateTransactionEvent extends FinanceEvent {
  final TransactionModel txn;
  UpdateTransactionEvent(this.txn);
  @override
  List<Object?> get props => [txn];
}

class DeleteTransactionEvent extends FinanceEvent {
  final String id;
  DeleteTransactionEvent(this.id);
  @override
  List<Object?> get props => [id];
}
