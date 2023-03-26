import 'dart:convert';

enum TransactionType {
  Expense(1),
  Income(2);

  final int code;
  const TransactionType(this.code);
}

class TransactionModel {
  int? id;
  String? description;
  int? type;
  double? value;
  String? dateTime;
  bool? isFixed;

  TransactionModel(
      {this.id,
      this.description,
      this.type,
      this.value,
      this.dateTime,
      this.isFixed});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    type = json['type'];
    value = json['value'];
    dateTime = json['dateTime'];
    isFixed = json['isFixed'];
  }

  Map<String, dynamic> toJson() {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['description'] = description;
    data['type'] = type;
    data['value'] = value;
    data['isFixed'] = isFixed;
    return data;
  }
}

class Transactions {
  List<TransactionModel>? transactions;

  Transactions({this.transactions});

  Transactions.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      transactions = [];
      json[''].forEach((t) {
        transactions!.add(TransactionModel.fromJson(t));
      });
    }
  }

  List<Map<String, dynamic>> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    // if (transactions != null) {
    //   data = transactions!.map((t) => t.toJson()).toList();
    // }
    return transactions!.map((t) => t.toJson()).toList();
  }
}
