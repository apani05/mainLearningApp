import 'package:bfootlearn/adminProfile/widgets/admin_searchbar.dart';
import 'package:bfootlearn/components/text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void showGrantAccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      String query = '';
      TextEditingController searchController = TextEditingController();
      Future<void> grantAdminAccess(String userId) async {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .update({
            'role': 'admin',
          });
        } catch (e) {
          print('Error updating user role: $e');
        }
      }

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            backgroundColor: Colors.white,
            title: Text(
              'Grant Admin Access',
              style: dialogBoxTitleTextStyle.copyWith(color: Colors.black),
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 5),
                    AdminSearchBar(
                      hintText: 'Search user...',
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          query = value.toLowerCase();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('role', isEqualTo: 'user')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final users = snapshot.data!.docs.where((user) {
                          final userName =
                              user['name'].toString().toLowerCase();
                          final userEmail =
                              user['email'].toString().toLowerCase();
                          return userName.contains(query) ||
                              userEmail.contains(query);
                        }).toList();

                        return Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              final userId = user.id;
                              return ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: const Icon(
                                  Icons.person_2_rounded,
                                  color: Colors.amber,
                                  size: 30,
                                ),
                                title: Text(
                                  user['name'],
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  user['email'],
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    grantAdminAccess(userId);
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(
                                    Icons.add_circle_outline_rounded,
                                    color: Colors.green,
                                    size: 25,
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

void showDialogRemoveAdminAccess({
  required BuildContext context,
  required VoidCallback onPressedDelete,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xff6562df),
        content: Text(
          'Do you want to remove admin access for this account?',
          style: dialogBoxContentTextStyle,
        ),
        actions: [
          TextButton(
            child: Text(
              'No',
              style: actionButtonTextStyle,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(
              'Remove',
              style: actionButtonTextStyle.copyWith(color: Colors.red),
            ),
            onPressed: () {
              onPressedDelete();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
