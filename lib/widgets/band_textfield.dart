import 'package:flutter/material.dart';

class BandTextField extends StatelessWidget {
  final String hint;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextEditingController controller;

  const BandTextField({
    super.key,
    required this.hint,
    required this.label,
    required this.validator,
    required this.keyboardType,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hint,
        labelText: label,
        alignLabelWithHint: true,
      ),
    );
  }
}