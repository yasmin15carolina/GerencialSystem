import 'package:file_picker/file_picker.dart';
import 'package:finantial_manager/Models/transaction.model.dart';
import 'package:finantial_manager/helpers/excel.dart';
import 'package:finantial_manager/widgets/dialogs.dart';
import 'package:finantial_manager/widgets/period.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

import '../controllers/transaction.controller.dart';
import '../helpers/constantes.dart';

enum FilterTypes {
  All(0),
  Expense(1),
  Income(2);

  final int code;
  const FilterTypes(this.code);
}

DateTime since = DateTime.now().copyWith(day: DateTime.now().day - 7);
DateTime until = DateTime.now();

// ignore: must_be_immutable
class TransactionsView extends StatefulWidget {
  final List<TransactionModel> transactions;

  const TransactionsView({super.key, required this.transactions});

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  @override
  void initState() {
    super.initState();
    transactions = widget.transactions;
  }

  int? filter;

  List<TransactionModel> transactionsAll = [];
  List<TransactionModel> transactions = [];

  setSince(DateTime newSince) {
    since = newSince;
  }

  setUntil(DateTime newUntil) {
    until = newUntil;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TransactionController.filterByType(filter, since, until),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Error fetching data: ${snapshot.error}"),
          );
        }
        // List<TransactionModel> transactions =
        //     snapshot.data as List<TransactionModel>;
        return Scaffold(
          // floatingActionButton: FloatingActionButton(onPressed: () {
          //   print(since);
          //   print(until);
          // }),
          body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PeriodSinceUntil(
                  since: since,
                  until: until,
                  setSince: setSince,
                  setUntil: setUntil,
                  search: () async {
                    transactions = await TransactionController.filterByType(
                        filter, since, until);
                    setState(() {});
                  },
                ),
                Container(
                  // margin:
                  //     const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List<Widget>.generate(
                        3,
                        (int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ChoiceChip(
                              label: Text(FilterTypes.values[index].name),
                              selected:
                                  filter == FilterTypes.values[index].code,
                              onSelected: (bool selected) async {
                                if (selected) {
                                  filter = FilterTypes.values[index].code != 0
                                      ? FilterTypes.values[index].code
                                      : null;
                                }
                                transactions =
                                    await TransactionController.filterByType(
                                        filter, since, until);
                                setState(() {
                                  // nPagination = 6;
                                  // index = 0;
                                });
                              },
                            ),
                          );
                        },
                      ).toList()),
                ),
                TransactionList(
                  transactions: transactions,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class TransactionList extends StatefulWidget {
  final List<TransactionModel>? transactions;
  const TransactionList({super.key, this.transactions});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  List<TransactionModel> transactions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transactions = widget.transactions!;
  }

  int nPagination = 6;
  int index = 0;

  int getEndOFList(List<TransactionModel> transactions) {
    int i = (transactions.length - 1 - index * nPagination > nPagination)
        ? index * nPagination + nPagination
        : transactions.length;
    return i;
  }

  int? filter;

  final formatDay = DateFormat('dd/MM/yyyy');
  final formatHour = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                // headingRowColor: MaterialStateColor.resolveWith(
                //   (states) {
                //     return Color.fromARGB(255, 151, 44, 170);
                //   },
                // ),
                border: TableBorder.all(
                  width: 1.0,
                  color: Colors.black,
                ),
                dividerThickness: 5,
                headingRowHeight: 56,
                dataRowHeight: 56,
                columns: const [
                  // DataColumn(label: Text("Origem")),
                  DataColumn(label: Text("Valor")),
                  DataColumn(label: Text("Data")),
                  DataColumn(label: Text("")),
                  DataColumn(label: Text("")),
                ],
                rows: transactions
                    .sublist(index * nPagination, getEndOFList(transactions))
                    .map((e) => DataRow(cells: [
                          // DataCell(Text(e.origin)),
                          DataCell(
                            Container(
                              color: e.type == TransactionType.Expense.code
                                  ? Colors.red
                                  : Colors.green,
                              child: Text(e.value.toString()),
                            ),
                          ),
                          DataCell(Text(formatDay.format(
                              formatFromJson.parse(e.dateTime.toString())))),
                          DataCell(
                            const Icon(Icons.edit),
                            onTap: () async {
                              TextEditingController descriptionController =
                                  TextEditingController(text: e.description);
                              TextEditingController valueController =
                                  TextEditingController(
                                      text: e.value.toString());
                              Dialogs.showEdit(
                                context: context,
                                movimentacao: descriptionController,
                                valor: valueController,
                                isFixed: e.isFixed!,
                                onConfirm: () async {
                                  e.description = descriptionController.text;
                                  e.value = double.parse(valueController.text);
                                  await TransactionController.update(e);
                                  transactions =
                                      await TransactionController.getAll(
                                          since, until);
                                  setState(() {});
                                },
                              );
                            },
                          ),
                          DataCell(
                            const Icon(Icons.delete),
                            onTap: () async {
                              Dialogs.showDelete(
                                  context: context,
                                  onConfirm: () async {
                                    await TransactionController.delete(e.id!);
                                    transactions =
                                        await TransactionController.getAll(
                                            since, until);
                                    setState(() {});
                                  });
                            },
                          ),
                        ]))
                    .toList()),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              transactions.length == nPagination
                  ? "1/1"
                  : "${index + 1}/${transactions.length ~/ nPagination + 1}",
            ),
            IconButton(
              onPressed: () async {
                Excelfile e = Excelfile();
                String path = await e.exportTransactions();
                OpenFilex.open(path).then((value) => Dialogs.show(
                    context: context,
                    content: value.message,
                    title: "Abrir arquivo"));
              },
              icon: const Icon(Icons.download),
            ),
            IconButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                    allowedExtensions: ['xlsx'], type: FileType.custom);

                if (result != null) {
                  Excelfile e = Excelfile();
                  await e.readTransactions(result.files.single.path!);
                  setState(() {});
                  Dialogs.show(
                      context: context,
                      content: "Os dados foram importados!",
                      title: "Importar Dados");
                } else {
                  // User canceled the picker
                }
              },
              icon: const Icon(Icons.upload),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(const CircleBorder())),
              onPressed: index > 0
                  ? () => setState(() {
                        index--;
                      })
                  : null,
              child: const Icon(Icons.arrow_back),
            ),
            FilledButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(const CircleBorder())),
              onPressed: (index < transactions.length ~/ nPagination &&
                      nPagination != transactions.length)
                  ? () => setState(() {
                        index++;
                      })
                  : null,
              child: const Icon(Icons.arrow_forward),
            ),
          ],
        )
      ],
    );
  }
}
