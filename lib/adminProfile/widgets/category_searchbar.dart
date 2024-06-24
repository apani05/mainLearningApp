import 'package:bfootlearn/adminProfile/services/category_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorySearchBar extends ConsumerStatefulWidget {
  final TextEditingController controller;
  const CategorySearchBar({super.key, required this.controller});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategorySearchBarState();
}

class _CategorySearchBarState extends ConsumerState<CategorySearchBar> {
  @override
  Widget build(BuildContext context) {
    final CategoryFunctions categoryFunctions = CategoryFunctions();
    return TextField(
      controller: widget.controller,
      // onChanged: (value) => categoryFunctions.filterCategories(value),
      decoration: InputDecoration(
        labelText: 'Search Categories',
        floatingLabelBehavior: FloatingLabelBehavior.never,
        constraints: const BoxConstraints(maxHeight: 55),
        prefixIcon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Icon(Icons.search),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
      ),
    );
  }
}
