import 'package:finantial_manager/Models/transaction.model.dart';
import 'package:finantial_manager/controllers/transaction.controller.dart';
import 'package:finantial_manager/widgets/dropdownbutton.dart';
import 'package:finantial_manager/widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/dialogs.dart';

class InputView extends StatefulWidget {
  const InputView({super.key});

  @override
  State<InputView> createState() => _InputViewState();
}

class _InputViewState extends State<InputView> {
  TextEditingController reasonController = TextEditingController(text: "aa");
  TextEditingController valueController = TextEditingController(text: "9.99");
  bool isFixed = false;

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      // Thumb icon when the switch is selected.
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );
  List<String> tipos = TransactionType.values.map((e) => e.name).toList();
  String value = 'Expense';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Transaction"),
        leading: const Center(),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyDropDownButton(
              options: tipos,
              value: value,
              labelText: "Tipos",
              onChanged: (newValue) {
                setState(() {
                  value = newValue;
                });
              },
            ),
            TextInputField(
              controller: reasonController,
              label: "Description",
            ),
            TextInputField(
              controller: valueController,
              label: "Value",
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Fixed",
                  style: TextStyle(fontSize: 15),
                ),
                Switch(
                  thumbIcon: thumbIcon,
                  value: isFixed,
                  onChanged: (bool value) {
                    setState(() {
                      isFixed = value;
                    });
                  },
                ),
              ],
            ),
            FilledButton(
                onPressed: () {
                  TransactionController.create(TransactionModel(
                      description: reasonController.text,
                      value: double.parse(valueController.text),
                      type: value == TransactionType.Expense.name
                          ? TransactionType.Expense.code
                          : TransactionType.Income.code,
                      isFixed: isFixed));
                  Dialogs.showSucess(
                    context: context,
                    title: "Sucess!",
                    content: "Transaction saved!",
                  );
                },
                child: const Text("Register")),
            // FilledButton(
            //     onPressed: () async {
            //       List<Saida> list = await SaidaController.readAll();
            //       // await ManagerDatabase.instance.readAllGastos();
            //       print(list.first.dateTime);
            //     },
            //     child: const Text("show data")),
            // FilledButton(
            //     onPressed: () async {
            //       await Arquivo.saveFile();
            //     },
            //     child: const Text("save data")),
            // FilledButton(
            //     onPressed: () async {
            //       await SaidaController.getRows();
            //     },
            //     child: const Text("save data")),
          ],
        ),
      ),
    );
  }
}
