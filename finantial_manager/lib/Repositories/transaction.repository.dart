import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:finantial_manager/Models/transaction.model.dart';
import 'package:finantial_manager/Models/user.model.dart';
import 'package:finantial_manager/Repositories/user.repository.dart';

import '../helpers/constantes.dart';

class TransactionRepository {
  static Future<Response> getAll() async {
    String url = "$urlAPI/api/Transaction";
    return dio.get(url,
        options:
            Options(headers: {"Authorization": "bearer ${UserModel().token}"}));
  }

  static Future<Response> filterByType(int? type) async {
    String url = "$urlAPI/api/Transaction";
    return dio.get(url,
        options: Options(
          headers: type != null
              ? {
                  "type": type,
                  "Authorization": "bearer ${UserModel().token}",
                }
              : {"Authorization": "bearer ${UserModel().token}"},
        ));
  }

  static Future<Response> create(TransactionModel transactionModel) async {
    String url = "$urlAPI/api/Transaction/Add";
    print(jsonEncode(transactionModel.toJson()));
    return dio.post(url,
        data: transactionModel.toJson(),
        options:
            Options(headers: {"Authorization": "bearer ${UserModel().token}"}));
  }

  static Future<Response> createFromList(
      List<TransactionModel> _transactions) async {
    String url = "$urlAPI/api/Transaction/AddList";
    Transactions transactions = Transactions(transactions: _transactions);
    print(jsonEncode(transactions.toJson()));

    return dio.post(
      url,
      data: jsonEncode(transactions.toJson()),
      options:
          Options(headers: {"Authorization": "bearer ${UserModel().token}"}),
    );
  }

  static Future<Response> update(TransactionModel transactionModel) async {
    String url = "$urlAPI/api/Transaction/Update";
    return dio.post(url,
        data: jsonEncode(transactionModel.toJson()),
        options:
            Options(headers: {"Authorization": "bearer ${UserModel().token}"}));
  }

  static Future<Response> delete(int id) async {
    String url = "$urlAPI/api/Transaction/Delete/$id";
    return dio.delete(url,
        options:
            Options(headers: {"Authorization": "bearer ${UserModel().token}"}));
  }

  static setMiddleware() {
    dio.interceptors.add(InterceptorsWrapper(onError: (error, handler) async {
      if (error.response?.statusCode == 403 ||
          error.response?.statusCode == 401) {
        await UserRepository.verifyToken();
        await _retry(error.requestOptions);
      }
      // return error.response;
    }));
  }

  static Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = new Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }
}
