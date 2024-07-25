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
    const email = 'test123@example.com';
    const password = 'password123@123';

    final mockUserCredential = MockUserCredential();
    when(mockUser.uid).thenReturn('test-uid');
    when(mockUserCredential.user).thenReturn(mockUser);

    when(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).thenAnswer((_) async => mockUserCredential);

    final mockCollectionReference =
        MockCollectionReference<Map<String, dynamic>>();
    final mockDocumentReference = MockDocumentReference<Map<String, dynamic>>();
    final mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

    when(mockFirestore.collection('users')).thenReturn(mockCollectionReference);
    when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
    when(mockDocumentReference.get())
        .thenAnswer((_) async => mockDocumentSnapshot);
    when(mockDocumentSnapshot.exists).thenReturn(true);
    when(mockDocumentSnapshot.data()).thenReturn({'email': email});

    final userCredential =
        await mockFirebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    expect(user, isNotNull);

    await mockFirestore
        .collection('users')
        .doc(user?.uid)
        .set({'email': email});

    final userDoc =
        await mockFirestore.collection('users').doc(user?.uid).get();
    expect(userDoc.exists, isTrue);
    expect(userDoc.data()?['email'], email);

    verify(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).called(1);
    verify(mockFirestore.collection('users')).called(2);
    verify(mockDocumentReference.set({'email': email})).called(1);
    verify(mockDocumentReference.get()).called(1);
  });
}
