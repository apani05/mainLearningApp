import 'package:bfootlearn/adminProfile/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'firebase_auth_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  UserCredential,
  User,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot
])
void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockUser = MockUser();
  });

  test('User adds data to ConversationTypes and Conversations collections',
      () async {
    // Setup mock data for ConversationTypes collection
    final mockConversationTypesCollection =
        MockCollectionReference<Map<String, dynamic>>();
    final mockConversationTypeDocument =
        MockDocumentReference<Map<String, dynamic>>();

    final categoryModel = CategoryModel(
      categoryId: 'category-1',
      timestamp: '2024-07-27T12:00:00Z',
      categoryName: 'Greeting',
      iconImage: 'icon.png',
    );

    when(mockFirestore.collection('conversationTypes'))
        .thenReturn(mockConversationTypesCollection);
    when(mockConversationTypesCollection.doc(any))
        .thenReturn(mockConversationTypeDocument);
    when(mockConversationTypeDocument.set(any)).thenAnswer((_) async => null);

    // Setup mock data for Conversations collection
    final mockConversationsCollection =
        MockCollectionReference<Map<String, dynamic>>();
    final mockConversationDocument =
        MockDocumentReference<Map<String, dynamic>>();

    when(mockFirestore.collection('conversations'))
        .thenReturn(mockConversationsCollection);
    when(mockConversationsCollection.doc(any))
        .thenReturn(mockConversationDocument);
    when(mockConversationDocument.set(any)).thenAnswer((_) async => null);

    // Test adding data to ConversationTypes collection
    final categoryData = {
      'categoryId': categoryModel.categoryId,
      'timestamp': categoryModel.timestamp,
      'categoryName': categoryModel.categoryName,
      'iconImage': categoryModel.iconImage,
    };

    await mockFirestore
        .collection('conversationTypes')
        .doc(categoryModel.categoryId)
        .set(categoryData);

    // Test adding data to Conversations collection
    final conversationData = {
      'englishText': 'Hello',
      'blackfootText': 'hello',
      'blackfootAudio': 'hello.mp3',
      'seriesName': categoryModel.categoryName,
    };

    await mockFirestore
        .collection('conversations')
        .doc('conversation-1')
        .set(conversationData);

    // Verify data was added to ConversationTypes collection
    verify(mockFirestore.collection('conversationTypes')).called(1);
    verify(mockConversationTypesCollection.doc(categoryModel.categoryId))
        .called(1);
    verify(mockConversationTypeDocument.set(categoryData)).called(1);

    // Verify data was added to Conversations collection
    verify(mockFirestore.collection('conversations')).called(1);
    verify(mockConversationsCollection.doc('conversation-1')).called(1);
    verify(mockConversationDocument.set(conversationData)).called(1);
  });
}
