import 'package:bfootlearn/adminProfile/models/category_model.dart';
import 'package:bfootlearn/adminProfile/pages/admin_access.dart';
import 'package:bfootlearn/adminProfile/services/show_dialog_category.dart';
import 'package:bfootlearn/adminProfile/widgets/admin_searchbar.dart';
import 'package:bfootlearn/adminProfile/widgets/existing_categories_listview.dart';
import 'package:bfootlearn/components/custom_appbar.dart';
import 'package:bfootlearn/login/views/change_password.dart';
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
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: const Color(0xffbdbcfd),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: PopupMenuButton<int>(
              onSelected: (value) {
                if (value == 1) {
                  FirebaseAuth.instance.signOut();
                } else if (value == 2) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AdminAccessPage()));
                } else if (value == 3) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PasswordChangePage()));
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.admin_panel_settings_rounded),
                      SizedBox(width: 10),
                      Text('Admin Access', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 3,
                  child: Row(
                    children: [
                      Icon(Icons.password_rounded),
                      SizedBox(width: 10),
                      Text('Change Password', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded),
                      SizedBox(width: 10),
                      Text('Sign Out', style: TextStyle(fontSize: 16)),
                    ],
                  ),
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
        backgroundColor: Color(0xFFcccbff),
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
