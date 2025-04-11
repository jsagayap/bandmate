import 'package:flutter/material.dart';

class BandDropdownField extends StatefulWidget {
  final String labelText;
  final List<dynamic> items;
  final dynamic selectedItem;
  final Function(dynamic)? onChanged;

  const BandDropdownField({
    Key? key,
    required this.labelText,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<BandDropdownField> createState() => _BandDropdownFieldState();
}

class _BandDropdownFieldState extends State<BandDropdownField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16.0),
          border: const OutlineInputBorder(),
          labelText: widget.labelText,
          alignLabelWithHint: true,
        ),
        items: widget.items.asMap().entries.map((e) =>
          DropdownMenuItem(
            value: e.key,
            child: Text(e.value.toString()),
          ),
        ).toList(),
        value: widget.selectedItem,
        style: Theme.of(context).textTheme.bodyLarge,
        onChanged: widget.onChanged,
      ),
    );
  }
}