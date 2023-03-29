import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class TextInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  TextInputType? keyboardType = TextInputType.text;
  List<TextInputFormatter>? inputFormatters;
  FocusNode? focusNode;
  bool obscure;
  String? Function(String?)? validator;
  TextInputField(
      {super.key,
      required this.controller,
      required this.label,
      this.keyboardType,
      this.inputFormatters,
      this.obscure = false,
      this.validator});

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          validator: widget.validator,
          focusNode: widget.focusNode,
          obscureText: widget.obscure,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: const TextStyle(fontSize: 20),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).textTheme.titleSmall!.color!),
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            // focusedBorder: OutlineInputBorder(
            //   borderSide: BorderSide(
            //       width: 1, color: Theme.of(context).colorScheme.secondary),
            //   borderRadius: const BorderRadius.all(
            //     Radius.circular(10.0),
            //   ),
            // ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).textTheme.titleSmall!.color!),
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          )),
    );
  }
}
