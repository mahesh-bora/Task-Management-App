import 'package:flutter/material.dart';
import 'package:task_manager_app/presentation/widgets/primary_container.dart';

class NeumorphicDropdownField extends StatelessWidget {
  final String hintText;
  final String? value;
  final List<DropdownMenuItem<String>>? items;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const NeumorphicDropdownField({
    Key? key,
    required this.hintText,
    this.value,
    this.items,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      child: DropdownButtonFormField<String>(
        value: value,
        items: items,
        onChanged: onChanged,
        validator: validator,
        style: const TextStyle(fontSize: 16, color: Colors.black45),
        decoration: InputDecoration(
          filled: false,
          contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 3),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
        dropdownColor: Colors.white,
      ),
    );
  }
}
