import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyDropDownButton extends StatefulWidget {
  FocusNode? focusNode = FocusNode();
  String? labelText = '';
  dynamic value;
  List options;
  Function(dynamic)? onChanged;
  MyDropDownButton({
    super.key,
    this.focusNode,
    this.labelText,
    this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  State<MyDropDownButton> createState() => _MyDropDownButtonState();
}

class _MyDropDownButtonState extends State<MyDropDownButton> {
  // List<String> tipos = ['Gasto', 'Entrada'];
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: DropdownButtonFormField<dynamic>(
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            labelText: widget.labelText,
            // labelStyle: TextStyle(
            //     color: focusNode.hasFocus
            //         ? Theme.of(context).colorScheme.secondary
            //         : Theme.of(context).textTheme.titleSmall!.color!,
            //     fontSize: SizeConfig.of(context).dynamicScaleSize(size: 25)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).textTheme.titleSmall!.color!),
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).textTheme.titleSmall!.color!),
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1, color: Theme.of(context).colorScheme.secondary),
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
          value: widget.value,
          items: widget.options
              .map<DropdownMenuItem<dynamic>>((dynamic value) =>
                  DropdownMenuItem<dynamic>(
                    value: value,
                    child: Text('$value',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.labelLarge!.color,
                        ),
                        overflow: TextOverflow.ellipsis),
                  ))
              .toList(),
          onChanged: widget.onChanged,
        ));
  }
}
