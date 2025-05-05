import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_finance_app/features/finances/models/transaction_model.dart';

class FirebaseAPIs {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> addTransaction(TransactionModel txn) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .doc(txn.id)
        .set(txn.toMap());
  }

  Future<List<TransactionModel>> getTransactions(String uid) async {
    final snapshot =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('transactions')
            .orderBy('date', descending: true)
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return TransactionModel.fromMap(data);
    }).toList();
  }

  Future<void> updateTransaction(TransactionModel txn) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .doc(txn.id)
        .update(txn.toMap());
  }

  Future<void> deleteTransaction(String id) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .doc(id)
        .delete();
  }
}
