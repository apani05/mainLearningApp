import 'package:flutter/material.dart';

class AdminSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function(String)? onChanged;
  const AdminSearchBar(
      {super.key,
      required this.hintText,
      required this.controller,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (value) => onChanged!(value),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        constraints: const BoxConstraints(maxHeight: 55),
        prefixIcon: const Icon(Icons.search),
        enabledBorder: adminSearchBarInputBorder,
        focusedBorder: adminSearchBarInputBorder,
      ),
    );
  }
}

OutlineInputBorder adminSearchBarInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  borderSide: const BorderSide(
    color: Colors.black,
    width: 2,
  ),
);
