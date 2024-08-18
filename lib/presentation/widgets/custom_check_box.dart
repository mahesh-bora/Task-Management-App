import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const CustomCheckbox(
      {Key? key, required this.isChecked, required this.onChanged})
      : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      visualDensity: const VisualDensity(
        horizontal: VisualDensity.maximumDensity,
        vertical: VisualDensity.maximumDensity,
      ),
      value: widget.isChecked,
      onChanged: widget.onChanged,
      checkColor: Colors.black38,
      activeColor: Colors.white70,
      side: BorderSide(
        color: widget.isChecked ? Colors.white : Colors.grey,
        width: 2.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}
