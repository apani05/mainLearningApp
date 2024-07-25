import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([
  FirebaseAuth,
  UserCredential,
  User,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot
])
import 'firebase_auth_test.mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockUser = MockUser();
  });

  test('registers user and creates user collection in Firestore', () async {
    // Existing setup code for user registration

    // Setup mock data for Conversations collection
    final mockConversationsCollection =
        MockCollectionReference<Map<String, dynamic>>();
    final mockConversationDocument =
        MockDocumentReference<Map<String, dynamic>>();
    final mockConversationSnapshot =
        MockDocumentSnapshot<Map<String, dynamic>>();

    when(mockFirestore.collection('conversations'))
        .thenReturn(mockConversationsCollection);
    when(mockConversationsCollection.doc(any))
        .thenReturn(mockConversationDocument);
    when(mockConversationDocument.get())
        .thenAnswer((_) async => mockConversationSnapshot);
    when(mockConversationSnapshot.exists).thenReturn(true);
    when(mockConversationSnapshot.data()).thenReturn({
      'englishText': 'Hello',
      'blackfootText': 'hello',
      'blackfootAudio': 'hello.mp3',
      'seriesName': 'Greeting',
    });

    // Test retrieval of conversation data
    final conversationDoc = await mockFirestore
        .collection('conversations')
        .doc('conversation-id')
        .get();
    expect(conversationDoc.exists, isTrue);
    expect(conversationDoc.data()?['englishText'], 'Hello');
    expect(conversationDoc.data()?['blackfootText'], 'hello');
    expect(conversationDoc.data()?['blackfootAudio'], 'hello.mp3');
    expect(conversationDoc.data()?['seriesName'], 'Greeting');

    verify(mockFirestore.collection('conversations')).called(1);
    verify(mockConversationDocument.get()).called(1);
  });
}
