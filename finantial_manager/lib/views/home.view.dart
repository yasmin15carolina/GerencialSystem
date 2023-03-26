import 'package:dio/dio.dart';
import 'package:finantial_manager/Repositories/user.repository.dart';
import 'package:finantial_manager/controllers/transaction.controller.dart';
import 'package:finantial_manager/helpers/constantes.dart';
import 'package:finantial_manager/views/input.view.dart';
import 'package:finantial_manager/views/profile.view.dart';
import 'package:finantial_manager/views/transaction.view.dart';
import 'package:flutter/material.dart';

import '../Models/transaction.model.dart';
import '../Repositories/transaction.repository.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      transactions = await TransactionController.getAll();
    });
    TransactionRepository.setMiddleware();
  }

  List<TransactionModel> transactions = [];
  @override
  Widget build(BuildContext context) {
    final screens = [
      // const CadastrosPage(),
      // GridSaida(
      //   gastos: const [],
      // ),
      // GridEntrada(
      //   entrada: const [],
      // ),
      // const ResultsPage()
      InputView(),
      TransactionsView(
        transactions: transactions,
      ),
      ProfileView()
      // Icon(Icons.grid_3x3),
    ];
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            // indicatorColor: Colors.white,
            labelTextStyle: MaterialStateProperty.all(const TextStyle())),
        child: NavigationBar(
          height: 60,
          // backgroundColor: Colors.red,
          selectedIndex: index,
          onDestinationSelected: (index) async {
            if (index == 1) {
              transactions = await TransactionController.getAll();
            }
            setState(() {
              this.index = index;
            });
          },
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.attach_money), label: "Input"),
            NavigationDestination(
                icon: Icon(
                  Icons.grid_on_outlined,
                ),
                label: "Transactions"),
            // NavigationDestination(
            //     icon: Icon(Icons.grid_on_rounded, color: Colors.green),
            //     label: "Entrada"),
            NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
