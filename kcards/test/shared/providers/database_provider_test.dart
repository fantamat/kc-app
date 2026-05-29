import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcards/data/database/database.dart';
import 'package:kcards/data/repositories/firebase/firebase_directory_repository.dart';
import 'package:kcards/data/repositories/firebase/firebase_knowledge_card_repository.dart';
import 'package:kcards/data/repositories/firebase/firebase_question_card_repository.dart';
import 'package:kcards/data/repositories/firebase/firebase_study_progress_repository.dart';
import 'package:kcards/data/repositories/local/local_directory_repository.dart';
import 'package:kcards/data/repositories/local/local_knowledge_card_repository.dart';
import 'package:kcards/data/repositories/local/local_question_card_repository.dart';
import 'package:kcards/data/repositories/local/local_study_progress_repository.dart';
import 'package:kcards/data/services/firebase_image_service.dart';
import 'package:kcards/data/services/local_image_service.dart';
import 'package:kcards/shared/providers/auth_providers.dart';
import 'package:kcards/shared/providers/database_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}

class MockAppDatabase extends Mock implements AppDatabase {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

ProviderContainer _buildContainer({
  required AuthStatus authStatus,
  required User? user,
  required AppDatabase database,
  required FirebaseFirestore firestore,
  required FirebaseStorage storage,
}) {
  return ProviderContainer(
    overrides: [
      authStatusProvider.overrideWith((_) => authStatus),
      currentUserProvider.overrideWith((_) => Stream<User?>.value(user)),
      appDatabaseProvider.overrideWith((_) => database),
      firestoreProvider.overrideWith((_) => firestore),
      firebaseStorageProvider.overrideWith((_) => storage),
    ],
  );
}

void _stubFirestorePathChain(FirebaseFirestore firestore) {
  final collection = MockCollectionReference();
  final document = MockDocumentReference();

  when(() => firestore.collection(any())).thenReturn(collection);
  when(() => collection.doc(any())).thenReturn(document);
  when(() => document.collection(any())).thenReturn(collection);
}

void main() {
  group('database providers', () {
    late MockAppDatabase database;
    late MockFirebaseFirestore firestore;
    late MockFirebaseStorage storage;

    setUp(() {
      database = MockAppDatabase();
      firestore = MockFirebaseFirestore();
      storage = MockFirebaseStorage();
      _stubFirestorePathChain(firestore);
    });

    test('firebase implementations are returned only for authenticated user',
        () async {
      final user = MockUser();
      when(() => user.uid).thenReturn('user-123');

      final container = _buildContainer(
        authStatus: AuthStatus.authenticated,
        user: user,
        database: database,
        firestore: firestore,
        storage: storage,
      );

      addTearDown(container.dispose);

      await container.read(currentUserProvider.future);

      expect(
        container.read(directoryRepositoryProvider),
        isA<FirebaseDirectoryRepository>(),
      );
      expect(
        container.read(knowledgeCardRepositoryProvider),
        isA<FirebaseKnowledgeCardRepository>(),
      );
      expect(
        container.read(questionCardRepositoryProvider),
        isA<FirebaseQuestionCardRepository>(),
      );
      expect(
        container.read(studyProgressRepositoryProvider),
        isA<FirebaseStudyProgressRepository>(),
      );
      expect(container.read(imageServiceProvider), isA<FirebaseImageService>());
    });

    test('authenticated state with null user returns local implementations',
        () async {
      final container = _buildContainer(
        authStatus: AuthStatus.authenticated,
        user: null,
        database: database,
        firestore: firestore,
        storage: storage,
      );

      addTearDown(container.dispose);

      await container.read(currentUserProvider.future);

      expect(
        container.read(directoryRepositoryProvider),
        isA<LocalDirectoryRepository>(),
      );
      expect(
        container.read(knowledgeCardRepositoryProvider),
        isA<LocalKnowledgeCardRepository>(),
      );
      expect(
        container.read(questionCardRepositoryProvider),
        isA<LocalQuestionCardRepository>(),
      );
      expect(
        container.read(studyProgressRepositoryProvider),
        isA<LocalStudyProgressRepository>(),
      );
      expect(container.read(imageServiceProvider), isA<LocalImageService>());
    });

    for (final authStatus in <AuthStatus>[
      AuthStatus.guest,
      AuthStatus.unauthenticated,
      AuthStatus.loading,
    ]) {
      test('$authStatus returns local implementations', () async {
        final container = _buildContainer(
          authStatus: authStatus,
          user: null,
          database: database,
          firestore: firestore,
          storage: storage,
        );

        addTearDown(container.dispose);

        await container.read(currentUserProvider.future);

        expect(
          container.read(directoryRepositoryProvider),
          isA<LocalDirectoryRepository>(),
        );
        expect(
          container.read(knowledgeCardRepositoryProvider),
          isA<LocalKnowledgeCardRepository>(),
        );
        expect(
          container.read(questionCardRepositoryProvider),
          isA<LocalQuestionCardRepository>(),
        );
        expect(
          container.read(studyProgressRepositoryProvider),
          isA<LocalStudyProgressRepository>(),
        );
        expect(container.read(imageServiceProvider), isA<LocalImageService>());
      });
    }
  });
}