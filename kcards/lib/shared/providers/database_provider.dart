import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:kcards/data/database/database.dart';
import 'package:kcards/data/repositories/firebase/firebase_directory_repository.dart';
import 'package:kcards/data/repositories/firebase/firebase_knowledge_card_repository.dart';
import 'package:kcards/data/repositories/firebase/firebase_question_card_repository.dart';
import 'package:kcards/data/repositories/firebase/firebase_study_progress_repository.dart';
import 'package:kcards/data/repositories/interfaces/i_directory_repository.dart';
import 'package:kcards/data/repositories/interfaces/i_knowledge_card_repository.dart';
import 'package:kcards/data/repositories/interfaces/i_question_card_repository.dart';
import 'package:kcards/data/repositories/interfaces/i_study_progress_repository.dart';
import 'package:kcards/data/repositories/local/local_directory_repository.dart';
import 'package:kcards/data/repositories/local/local_knowledge_card_repository.dart';
import 'package:kcards/data/repositories/local/local_question_card_repository.dart';
import 'package:kcards/data/repositories/local/local_study_progress_repository.dart';
import 'package:kcards/data/services/firebase_image_service.dart';
import 'package:kcards/data/services/image_service.dart';
import 'package:kcards/data/services/local_image_service.dart';
import 'package:kcards/shared/providers/auth_providers.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final firestoreProvider =
    Provider<FirebaseFirestore>((_) => FirebaseFirestore.instance);

final firebaseStorageProvider =
    Provider<FirebaseStorage>((_) => FirebaseStorage.instance);

final directoryRepositoryProvider = Provider<IDirectoryRepository>((ref) {
  final status = ref.watch(authStatusProvider);
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (status == AuthStatus.authenticated && user != null) {
    return FirebaseDirectoryRepository(
      firestore: ref.watch(firestoreProvider),
      uid: user.uid,
    );
  }
  return LocalDirectoryRepository(ref.watch(appDatabaseProvider));
});

final knowledgeCardRepositoryProvider = Provider<IKnowledgeCardRepository>((ref) {
  final status = ref.watch(authStatusProvider);
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (status == AuthStatus.authenticated && user != null) {
    return FirebaseKnowledgeCardRepository(
      firestore: ref.watch(firestoreProvider),
      uid: user.uid,
    );
  }
  return LocalKnowledgeCardRepository(ref.watch(appDatabaseProvider));
});

final questionCardRepositoryProvider = Provider<IQuestionCardRepository>((ref) {
  final status = ref.watch(authStatusProvider);
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (status == AuthStatus.authenticated && user != null) {
    return FirebaseQuestionCardRepository(
      firestore: ref.watch(firestoreProvider),
      uid: user.uid,
    );
  }
  return LocalQuestionCardRepository(ref.watch(appDatabaseProvider));
});

final studyProgressRepositoryProvider =
    Provider<IStudyProgressRepository>((ref) {
  final status = ref.watch(authStatusProvider);
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (status == AuthStatus.authenticated && user != null) {
    return FirebaseStudyProgressRepository(
      firestore: ref.watch(firestoreProvider),
      uid: user.uid,
    );
  }
  return LocalStudyProgressRepository(ref.watch(appDatabaseProvider));
});

final imageServiceProvider = Provider<ImageService>((ref) {
  final status = ref.watch(authStatusProvider);
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (status == AuthStatus.authenticated && user != null) {
    return FirebaseImageService(
      storage: ref.watch(firebaseStorageProvider),
      uid: user.uid,
    );
  }
  return const LocalImageService();
});
