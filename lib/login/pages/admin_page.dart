import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _editCategoryController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  String? editingCategoryId;
  List<DocumentSnapshot> categories = [];
  List<DocumentSnapshot> filteredCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Existing Categories:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _searchController,
              onChanged: (value) {
                _filterCategories(value);
              },
              decoration: InputDecoration(
                labelText: 'Search Categories',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      40.0),
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('ConversationTypes')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  categories = snapshot.data!.docs; // Populate categories list

                  List<Widget> categoryWidgets = [];
                  var categoriesToDisplay = filteredCategories.isNotEmpty
                      ? filteredCategories
                      : categories;

                  for (var category in categoriesToDisplay) {
                    String categoryName = category['seriesName'];
                    String categoryId = category.id;

                    categoryWidgets.add(
                      ListTile(
                        title: editingCategoryId == categoryId
                            ? TextFormField(
                                controller: _editCategoryController,
                                decoration:
                                    InputDecoration(labelText: 'New Name'),
                              )
                            : Text(categoryName),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  editingCategoryId = categoryId;
                                  _editCategoryController.text = categoryName;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteCategory(categoryId);
                              },
                            ),
                            if (editingCategoryId == categoryId)
                              IconButton(
                                icon: Icon(Icons.check),
                                onPressed: () {
                                  _updateCategory(
                                      categoryId, _editCategoryController.text);
                                  setState(() {
                                    editingCategoryId = null;
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView(
                    children: categoryWidgets,
                  );
                },
              ),
            ),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Add a new category item'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _addCategory();
              },
              child: Text('Add Category'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Center(child: Text("Sign out")),
            ),
          ],
        ),
      ),
    );
  }

  // Function to filter categories based on the search query
  void _filterCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCategories
            .clear(); // Clearing the filtered list if the query is empty
      } else {
        // Use where to filter categories based on the search query
        filteredCategories = categories
            .where((category) => category['seriesName']
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // Function to add a new category to Firestore
  void _addCategory() {
    String categoryName = _categoryController.text.trim();
    if (categoryName.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('ConversationTypes')
          .doc(categoryName)
          .set({'seriesName': categoryName}).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Category added successfully.'),
          ),
        );
        _categoryController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add category. $error'),
          ),
        );
      });
    }
  }

  // Function to delete a category from Firestore
  void _deleteCategory(String categoryId) {
    FirebaseFirestore.instance
        .collection('ConversationTypes')
        .doc(categoryId)
        .delete()
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Category deleted successfully.'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete category. $error'),
        ),
      );
    });
  }

  // Function to update the name of a category in Firestore
  void _updateCategory(String categoryId, String newName) {
    FirebaseFirestore.instance
        .collection('ConversationTypes')
        .doc(categoryId)
        .update({'seriesName': newName}).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Category updated successfully.'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update category. $error'),
        ),
      );
    });
  }
}
