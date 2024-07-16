import 'package:bfootlearn/adminProfile/services/show_dialog_grant_access.dart';
import 'package:bfootlearn/components/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminAccessPage extends StatelessWidget {
  const AdminAccessPage({super.key});

  Future<void> _removeAdmin(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'role': 'user',
      });
    } catch (e) {
      print('Error updating user role: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: customAppBar(context: context, title: 'Admin Access Settings'),
      floatingActionButton: FloatingActionButton.extended(
        label: const Row(
          children: [
            Icon(
              Icons.grid_view_rounded,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(width: 5),
            Text(
              'Grant Access',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
        onPressed: () => showGrantAccessDialog(context),
        backgroundColor: Color(0xFFcccbff),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'admin')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final admins = snapshot.data!.docs;

          if (admins.isEmpty) {
            return const Center(child: Text('No admins found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(10),
            itemCount: admins.length,
            itemBuilder: (context, index) {
              final admin = admins[index];
              return ListTile(
                leading: const Icon(
                  Icons.person_2_rounded,
                  color: Colors.amber,
                  size: 35,
                ),
                title: Text(
                  admin['name'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  admin['email'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () => showDialogRemoveAdminAccess(
                    context: context,
                    onPressedDelete: () => _removeAdmin(admin.id),
                  ),
                  icon: const Icon(
                    Icons.remove_circle_outline_rounded,
                    color: Colors.red,
                    size: 25,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
        },
      ),
    );
  }
}
