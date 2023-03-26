// ignore_for_file: unnecessary_null_comparison, await_only_futures, unused_local_variable

import 'dart:async';
import 'dart:io';
// ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html;
import 'package:finantial_manager/Models/transaction.model.dart';
import 'package:finantial_manager/controllers/transaction.controller.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class Excelfile {
  var excel = Excel.createExcel();
  late String name;
  Excelfile();
  final f = DateFormat('dd/MM/yyyy\nhh:mm');
  final formatFromJson = DateFormat('yyyy-MM-ddThh:mm:ss');

  Future<String> exportTransactions() async {
    excel.rename('Sheet1', "Transactions");
    Sheet sheetObject = excel["Transactions"];

    List<String> dataList = [
      "id",
      "Description",
      "Value",
      "Date",
      "Fixed",
    ];

    sheetObject.insertRowIterables(dataList, 0);

    sheetObject.updateCell(CellIndex.indexByString('A1'), "Id",
        cellStyle: CellStyle(horizontalAlign: HorizontalAlign.Center));
    sheetObject.updateCell(CellIndex.indexByString('B1'), "Tipo",
        cellStyle: CellStyle(horizontalAlign: HorizontalAlign.Center));
    sheetObject.updateCell(CellIndex.indexByString('C1'), "Description",
        cellStyle: CellStyle(horizontalAlign: HorizontalAlign.Center));
    sheetObject.updateCell(CellIndex.indexByString('D1'), "Value",
        cellStyle: CellStyle(horizontalAlign: HorizontalAlign.Center));
    sheetObject.updateCell(CellIndex.indexByString('E1'), "Date",
        cellStyle: CellStyle(horizontalAlign: HorizontalAlign.Center));
    sheetObject.updateCell(CellIndex.indexByString('F1'), "Fixed",
        cellStyle: CellStyle(horizontalAlign: HorizontalAlign.Center));

    List<TransactionModel> transactions = await TransactionController.getAll();

    for (var transaction in transactions) {
      List<dynamic> rowList = [];

      rowList.add(transaction.id);
      rowList.add(transaction.description);
      rowList.add(transaction.value);
      rowList.add(f.format(formatFromJson.parse(transaction.dateTime!)));
      rowList.add(transaction.isFixed! ? "True" : "False");

      sheetObject.insertRowIterables(
          rowList, transactions.indexOf(transaction) + 1);

      sheetObject.updateCell(
          CellIndex.indexByString('A${transactions.indexOf(transaction) + 2}'),
          transaction.id,
          cellStyle: CellStyle(horizontalAlign: HorizontalAlign.Center));
      sheetObject.updateCell(
          CellIndex.indexByString('B${transactions.indexOf(transaction) + 2}'),
          transaction.type,
          cellStyle: CellStyle(horizontalAlign: HorizontalAlign.Center));
      sheetObject.updateCell(
          CellIndex.indexByString('C${transactions.indexOf(transaction) + 2}'),
          transaction.description,
          cellStyle: CellStyle(horizontalAlign: HorizontalAlign.Center));
      sheetObject.updateCell(
          CellIndex.indexByString('D${transactions.indexOf(transaction) + 2}'),
          transaction.value,
          cellStyle: CellStyle(horizontalAlign: HorizontalAlign.Center));
      sheetObject.updateCell(
          CellIndex.indexByString('E${transactions.indexOf(transaction) + 2}'),
          f.format(formatFromJson.parse(transaction.dateTime!)),
          cellStyle: CellStyle(horizontalAlign: HorizontalAlign.Center));
      sheetObject.updateCell(
          CellIndex.indexByString('F${transactions.indexOf(transaction) + 2}'),
          transaction.isFixed! ? "True" : "False",
          cellStyle: CellStyle(horizontalAlign: HorizontalAlign.Center));
    }
    excel.setDefaultSheet("Transactions");
    var fileBytes = excel.save(fileName: "Teste.xlsx");
    Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
    var directory = await getApplicationDocumentsDirectory();

    File(join("${generalDownloadDir.path}/Teste.xlsx"))
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    return "${generalDownloadDir.path}/Teste.xlsx";
  }

  readTransactions(String path) {
    // Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
    // var bytes =
    //     File("${generalDownloadDir.path}/saidas.xlsx").readAsBytesSync();
    var bytes = File(path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    for (var table in excel.tables.keys) {
      List<List<Data?>> x = excel.tables[table]!.rows;
      x.removeAt(0);
      List<TransactionModel> list = [];
      for (var row in x) {
        list.add(
          TransactionModel(
              type: int.parse(row[1]!.value.toString()),
              description: row[2]!.value.toString(),
              value: double.parse(row[3]!.value.toString()),
              dateTime: f.parse(row[4]!.value.toString()).toString(),
              isFixed: row[5]!.value.toString() == 'false' ? false : true),
        );
      }
      TransactionController.createFromList(list);
    }
  }

  // Future<String> exportEntradaData() async {
  //   excel.rename('Sheet1', "Entrada");
  //   Sheet sheetObject = excel["Entrada"];

  //   List<String> dataList = [
  //     "id",
  //     "Origem",
  //     "Valor",
  //     "Data",
  //     "Fixo",
  //   ];

  //   sheetObject.insertRowIterables(dataList, 0);
  //   List<Entrada> entradas = await EntradaController.readAll();

  //   for (var element in entradas) {
  //     List<dynamic> rowList = [];

  //     rowList.add(element.id);
  //     rowList.add(element.origin);
  //     rowList.add(element.value);
  //     rowList.add(f.format(element.dateTime));
  //     rowList.add(element.isFixed ? "True" : "False");

  //     sheetObject.insertRowIterables(rowList, entradas.indexOf(element) + 1);
  //   }
  //   excel.setDefaultSheet("Entrada");
  //   var fileBytes = excel.save(fileName: "entradas.xlsx");
  //   Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
  //   var directory = await getApplicationDocumentsDirectory();

  //   File(join("${generalDownloadDir.path}/entradas.xlsx"))
  //     ..createSync(recursive: true)
  //     ..writeAsBytesSync(fileBytes!);
  //   return "${generalDownloadDir.path}/entradas.xlsx";
  // }

  // readEntrada(String path) {
  //   // Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
  //   // var bytes =
  //   //     File("${generalDownloadDir.path}/saidas.xlsx").readAsBytesSync();
  //   var bytes = File(path).readAsBytesSync();
  //   var excel = Excel.decodeBytes(bytes);
  //   for (var table in excel.tables.keys) {
  //     List<List<Data?>> x = excel.tables[table]!.rows;
  //     x.removeAt(0);
  //     List<Entrada> list = [];
  //     for (var row in x) {
  //       list.add(
  //         Entrada(
  //             id: int.parse(row[0]!.value.toString()),
  //             origin: row[1]!.value.toString(),
  //             value: double.parse(row[2]!.value.toString()),
  //             dateTime: f.parse(row[3]!.value.toString()),
  //             isFixed: row[3]!.value.toString() == 'False' ? false : true),
  //       );
  //     }
  //     EntradaController.fromList(list);
  //   }
  // }
}
