import 'package:bfootlearn/adminProfile/models/category_model.dart';
import 'package:bfootlearn/adminProfile/pages/admin_access.dart';
import 'package:bfootlearn/adminProfile/services/show_dialog_category.dart';
import 'package:bfootlearn/adminProfile/widgets/admin_searchbar.dart';
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
  final TextEditingController _searchController = TextEditingController();
  List<CategoryModel> _categories = [];
  List<CategoryModel> _filteredCategories = [];

  String? _selectedItem;
  final List<String> _dropdownItems = ['Sign Out'];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_filterCategories);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCategories);
    _searchController.dispose();
    super.dispose();
  }

  void _filterCategories() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCategories = _categories.where((category) {
        return category.categoryName.toLowerCase().contains(query) ||
            category.categoryId.toLowerCase().contains(query) ||
            category.timestamp.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Manage Categories'),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: PopupMenuButton<int>(
              onSelected: (value) {
                if (value == 1) {
                  FirebaseAuth.instance.signOut();
                } else if (value == 2) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AdminAccessPage(),
                  ));
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 1,
                  child: Text('Sign out', style: TextStyle(fontSize: 16)),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text('Admin access', style: TextStyle(fontSize: 16)),
                ),
              ],
              child: const Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      // floatingbutton for adding new category
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialogAddCategory(context),
        backgroundColor: Colors.purple.shade300,
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
            AdminSearchBar(
                hintText: 'Search category', controller: _searchController),
            const SizedBox(height: 20),
            const Text(
              'Existing Categories:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
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
                  _categories = List.from(
                    snapshot.data!.docs.map(
                      (doc) => CategoryModel(
                        categoryId: doc.id,
                        timestamp: doc['timestamp'],
                        categoryName: doc['seriesName'],
                        iconImage: doc['iconImage'],
                      ),
                    ),
                  );

                  _filteredCategories = _categories.where((conversation) {
                    String query = _searchController.text.toLowerCase();
                    return conversation.categoryName
                            .toLowerCase()
                            .contains(query) ||
                        conversation.categoryName
                            .toLowerCase()
                            .contains(query) ||
                        conversation.timestamp.toLowerCase().contains(query);
                  }).toList();

                  return ExistingCategoriesListview(
                      categoriesToDisplay: _filteredCategories);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
