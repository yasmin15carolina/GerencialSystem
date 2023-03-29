import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PeriodSinceUntil extends StatefulWidget {
  final String? restorationId = 'main';
  final DateTime since;
  final DateTime until;
  final Function(DateTime since) setSince;
  final Function(DateTime until) setUntil;
  final Function() search;
  PeriodSinceUntil({
    super.key,
    required this.since,
    required this.until,
    required this.setSince,
    required this.setUntil,
    required this.search,
  });

  @override
  State<PeriodSinceUntil> createState() => _PeriodSinceUntilState();
}

class _PeriodSinceUntilState extends State<PeriodSinceUntil>
    with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2021),
          lastDate: DateTime.now(),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        if (isStart) {
          widget.setSince(newSelectedDate);
          since = newSelectedDate;
          isStart = false;
          Future.delayed(const Duration(milliseconds: 200), () {
            _restorableDatePickerRouteFuture.present();
          });
        } else {
          widget.setUntil(newSelectedDate);
          until = newSelectedDate;
          isStart = true;
          widget.search();
        }
        setState(() {});
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(
        //       'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        // ));
      });
    }
  }

  DateTime since = DateTime.now();
  DateTime until = DateTime.now();
  @override
  void initState() {
    since = widget.since;
    until = widget.until;
    super.initState();
  }

  //     .copyWith(day: DateTime.now().day - 7); //DateTime(DateTime.now().year,);
  bool isStart = true;

  String formatDate(DateTime t) {
    String month = "";
    switch (t.month) {
      case 1:
        month = "Jan";
        break;
      case 2:
        month = "Fev";
        break;
      case 3:
        month = "Mar";
        break;
      case 4:
        month = "Abr";
        break;
      case 5:
        month = "Mai";
        break;
      case 6:
        month = "Jun";
        break;
      case 7:
        month = "Jul";
        break;
      case 8:
        month = "Ago";
        break;
      case 9:
        month = "Set";
        break;
      case 10:
        month = "Out";
        break;
      case 11:
        month = "Nov";
        break;
      case 12:
        month = "Dez";
        break;
      default:
    }

    return "$month,${t.day} ${t.year}";
  }

  search() async {}
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(child: Text("${formatDate(since)} - ${formatDate(until)}")),
          IconButton(
            onPressed: () => _restorableDatePickerRouteFuture.present(),
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),
    );
  }
}
