import 'package:bfootlearn/adminProfile/models/category_model.dart';
import 'package:bfootlearn/adminProfile/services/show_dialog_category.dart';
import 'package:bfootlearn/adminProfile/widgets/category_searchbar.dart';
import 'package:bfootlearn/adminProfile/widgets/existing_categories_listview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminPage extends ConsumerStatefulWidget {
  const AdminPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage> {
  final TextEditingController _editCategoryController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String? editingCategoryId;
  String? _selectedItem;
  List<String> _dropdownItems = ['Sign Out'];
  List<DocumentSnapshot> categories = [];
  List<DocumentSnapshot> filteredCategories = [];
  @override
  void dispose() {
    _editCategoryController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Manage Categories'),
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton<String>(
                value: _selectedItem,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedItem = newValue;
                  });
                },
                items: _dropdownItems.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                    onTap: () => FirebaseAuth.instance.signOut(),
                  );
                }).toList(),
                icon: const Icon(Icons.more_vert_rounded),
                iconSize: 30,
              ))
        ],
      ),
      // floatingbutton for adding new category
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialogAddCategory(context),
        child: const Icon(
          Icons.add_rounded,
          size: 30,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Existing Categories:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CategorySearchBar(controller: _searchController),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('ConversationTypes')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // populate categories in CategoryModel
                  List<CategoryModel> categories = List.from(
                    snapshot.data!.docs.map(
                      (doc) => CategoryModel(
                        categoryId: doc.id,
                        timestamp: doc['timestamp'],
                        categoryName: doc['seriesName'],
                        iconImage: doc['iconImage'],
                      ),
                    ),
                  );

                  // categories = snapshot.data!.docs; // Populate categories list

                  // List<Widget> categoryWidgets = [];
                  // var categoriesToDisplay = filteredCategories.isNotEmpty
                  //     ? filteredCategories
                  //     : categories;

                  return ExistingCategoriesListview(
                    categoriesToDisplay: categories,
                    editingController: _editCategoryController,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {
            //     FirebaseAuth.instance.signOut();
            //   },
            //   child: const Center(child: Text("Sign out")),
            // ),
          ],
        ),
      ),
    );
  }
}
