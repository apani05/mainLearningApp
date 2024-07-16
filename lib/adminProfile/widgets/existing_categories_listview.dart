import 'package:bfootlearn/adminProfile/models/category_model.dart';
import 'package:bfootlearn/adminProfile/pages/edit_category_page.dart';
import 'package:bfootlearn/adminProfile/services/show_dialog_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExistingCategoriesListview extends StatelessWidget {
  final List<CategoryModel> categoriesToDisplay;
  const ExistingCategoriesListview({
    super.key,
    required this.categoriesToDisplay,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = screenHeight * 0.1;

    return ListView.builder(
      itemCount: categoriesToDisplay.length + 1,
      itemBuilder: (context, index) {
        if (index == categoriesToDisplay.length) {
          return SizedBox(height: bottomPadding);
        }

        final category = categoriesToDisplay[index];

        return CategoryListTileItem(
          category: category,
        );
      },
    );
  }
}

class CategoryListTileItem extends ConsumerStatefulWidget {
  final CategoryModel category;

  const CategoryListTileItem({
    super.key,
    required this.category,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoryListTileItemState();
}

class _CategoryListTileItemState extends ConsumerState<CategoryListTileItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      onTap: () {
        // navigates to List of conversations present in this category
        setState(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditCategoryPage(category: widget.category),
            ),
          );
        });
      },
      title: Text(widget.category.categoryName),

      // more options button (category edit and delete buttons included)
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_circle_right_outlined, color: Color(0xff6562df)),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (String result) {
              switch (result) {
                case 'edit':
                  // Handle edit action
                  print('Edit selected');
                  showDialogUpdateCategory(
                    context: context,
                    oldCategory: widget.category,
                  );
                  break;
                case 'delete':
                  // Handle delete action
                  showDialogDeleteCategory(
                    context: context,
                    categoryData: widget.category,
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit_rounded),
                  title: Text('Edit'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: ListTile(
                  leading: Icon(
                    Icons.delete_rounded,
                    color: Colors.red,
                  ),
                  title: Text('Delete'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
