import 'package:flutter/material.dart';

class FieldValidationStatus extends StatelessWidget {
  final bool field;
  final bool validationBy;
  final String text;

  FieldValidationStatus({
    required this.field,
    required this.validationBy,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    String status = 'default';
    if (field) {
      status = validationBy ? 'success' : 'error';
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: TextStyle(
          color: status == 'success'
              ? Colors.green
              : status == 'error'
              ? Colors.red
              : Colors.black,
        ),
      ),
    );
  }
}
