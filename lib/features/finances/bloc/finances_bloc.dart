import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_app/features/finances/bloc/finances_event.dart';
import 'package:personal_finance_app/features/finances/bloc/finances_state.dart';
import '../../../apis/firebase_api.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  final FirebaseAPIs _api;

  FinanceBloc(this._api) : super(FinanceInitial()) {
    on<LoadTransactionsEvent>(_onLoadTransactions);

    on<AddTransactionEvent>((event, emit) async {
      try {
        await _api.addTransaction(event.txn);
        add(LoadTransactionsEvent()); // Refresh list
      } catch (e) {
        emit(FinanceError(e.toString()));
      }
    });
    on<UpdateTransactionEvent>((event, emit) async {
      try {
        await _api.updateTransaction(event.txn);
        add(LoadTransactionsEvent());
      } catch (e) {
        emit(FinanceError(e.toString()));
      }
    });

    on<DeleteTransactionEvent>((event, emit) async {
      try {
        await _api.deleteTransaction(event.id);
        add(LoadTransactionsEvent());
      } catch (e) {
        emit(FinanceError(e.toString()));
      }
    });
  }
  Future<void> _onLoadTransactions(
    LoadTransactionsEvent event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final transactions = await _api.getTransactions(uid);
      emit(FinanceLoaded(transactions));
    } catch (e) {
      emit(FinanceError('Failed to load transactions: $e'));
    }
  }
}
