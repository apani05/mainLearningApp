import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreOperations {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('collectionName');

  // Create
  Future<void> createDocument(Map<String, dynamic> data) {
    return _collection.add(data);
  }

  // Read
  Future<DocumentSnapshot> readDocument(String docId) {
    return _collection.doc(docId).get();
  }

  // Update
  Future<void> updateDocument(String docId, Map<String, dynamic> data) {
    return _collection.doc(docId).update(data);
  }

  // Delete
  Future<void> deleteDocument(String docId) {
    return _collection.doc(docId).delete();
  }

  // Listen
  void listenToDocument(String docId) {
    _collection.doc(docId).snapshots().listen((snapshot) {
      print('Document data: ${snapshot.data()}');
    });
  }

  streamDocument(String uid) {
    return _collection.doc(uid).snapshots();
  }
}