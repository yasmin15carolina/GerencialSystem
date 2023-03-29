import 'package:finantial_manager/Models/transaction.model.dart';
import 'package:finantial_manager/Repositories/transaction.repository.dart';

class TransactionController {
  static Future<List<TransactionModel>> getAll(
      DateTime since, DateTime until) async {
    final res = await TransactionRepository.getAll(since, until);
    List<TransactionModel> transactions = [];
    for (var i = 0; i < res.data.length; i++) {
      transactions.add(TransactionModel.fromJson(res.data[i]));
    }
    return transactions;
  }

  static Future<List<TransactionModel>> filterByType(
      int? type, DateTime since, DateTime until) async {
    final res = await TransactionRepository.filterByType(type, since, until);
    List<TransactionModel> transactions = [];
    for (var i = 0; i < res.data.length; i++) {
      transactions.add(TransactionModel.fromJson(res.data[i]));
    }
    return transactions;
  }

  static Future<TransactionModel> create(TransactionModel transaction) async {
    final res = await TransactionRepository.create(transaction);

    return TransactionModel.fromJson(res.data);
  }

  static Future<String> createFromList(
      List<TransactionModel> transactions) async {
    final res = await TransactionRepository.createFromList(transactions);

    return res.data;
  }

  static Future<TransactionModel> update(TransactionModel transaction) async {
    final res = await TransactionRepository.update(transaction);

    return TransactionModel.fromJson(res.data);
  }

  static Future<TransactionModel> delete(int id) async {
    final res = await TransactionRepository.delete(id);

    return TransactionModel.fromJson(res.data);
  }
}
