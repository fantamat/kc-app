import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'package:kcards/data/models/card_image_model.dart';
import 'package:kcards/data/models/question_card_model.dart';
import 'package:kcards/data/repositories/interfaces/i_question_card_repository.dart';

class FirebaseQuestionCardRepository implements IQuestionCardRepository {
  FirebaseQuestionCardRepository({
    required FirebaseFirestore firestore,
    required String uid,
  })  : _col = firestore
            .collection('users')
            .doc(uid)
            .collection('questionCards'),
        _imgCol = firestore
            .collection('users')
            .doc(uid)
            .collection('questionCardImages'),
        _spCol = firestore
            .collection('users')
            .doc(uid)
            .collection('studyProgress');

  final CollectionReference<Map<String, dynamic>> _col;
  final CollectionReference<Map<String, dynamic>> _imgCol;
  final CollectionReference<Map<String, dynamic>> _spCol;

  @override
  Stream<List<QuestionCardModel>> watchByDirectory(String directoryId) =>
      _col
          .where('directoryId', isEqualTo: directoryId)
          .snapshots()
          .map((snap) => snap.docs.map(_fromDoc).toList());

  @override
  Stream<List<QuestionCardModel>> watchByKnowledgeCard(
          String knowledgeCardId) =>
      _col
          .where('knowledgeCardId', isEqualTo: knowledgeCardId)
          .snapshots()
          .map((snap) => snap.docs.map(_fromDoc).toList());

  @override
  Future<QuestionCardModel?> getById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return _fromDoc(doc);
  }

  @override
  Future<List<QuestionCardModel>> getByDirectoryIds(
      List<String> dirIds) async {
    if (dirIds.isEmpty) return [];
    final results = <QuestionCardModel>[];
    for (var i = 0; i < dirIds.length; i += 30) {
      final chunk =
          dirIds.sublist(i, i + 30 < dirIds.length ? i + 30 : dirIds.length);
      final snap =
          await _col.where('directoryId', whereIn: chunk).get();
      results.addAll(snap.docs.map(_fromDoc));
    }
    return results;
  }

  @override
  Future<QuestionCardModel> create({
    required String directoryId,
    required String knowledgeCardId,
    required String title,
    String questionMd = '',
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    await _col.doc(id).set({
      'directoryId': directoryId,
      'knowledgeCardId': knowledgeCardId,
      'title': title,
      'questionMd': questionMd,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    });
    return QuestionCardModel(
      id: id,
      directoryId: directoryId,
      knowledgeCardId: knowledgeCardId,
      title: title,
      questionMd: questionMd,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<void> update(
    String id, {
    String? title,
    String? questionMd,
    String? knowledgeCardId,
  }) async {
    final updates = <String, dynamic>{'updatedAt': FieldValue.serverTimestamp()};
    if (title != null) updates['title'] = title;
    if (questionMd != null) updates['questionMd'] = questionMd;
    if (knowledgeCardId != null) updates['knowledgeCardId'] = knowledgeCardId;
    await _col.doc(id).update(updates);
  }

  @override
  Future<void> delete(String id) async {
    final imgSnap =
        await _imgCol.where('questionCardId', isEqualTo: id).get();
    final spSnap = await _spCol.where('questionCardId', isEqualTo: id).get();

    final batch = _col.firestore.batch();
    for (final doc in imgSnap.docs) {
      batch.delete(doc.reference);
    }
    for (final doc in spSnap.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_col.doc(id));
    await batch.commit();
  }

  // ── Images ────────────────────────────────────────────────────────────────

  @override
  Stream<List<CardImageModel>> watchImages(String questionCardId) =>
      _imgCol
          .where('questionCardId', isEqualTo: questionCardId)
          .orderBy('sortOrder')
          .snapshots()
          .map((snap) => snap.docs.map(_fromImgDoc).toList());

  @override
  Future<List<CardImageModel>> getImages(String questionCardId) async {
    final snap = await _imgCol
        .where('questionCardId', isEqualTo: questionCardId)
        .orderBy('sortOrder')
        .get();
    return snap.docs.map(_fromImgDoc).toList();
  }

  @override
  Future<CardImageModel> addImage(
    String questionCardId,
    String imagePath,
    int sortOrder,
  ) async {
    final id = const Uuid().v4();
    await _imgCol.doc(id).set({
      'questionCardId': questionCardId,
      'imagePath': imagePath,
      'sortOrder': sortOrder,
    });
    return CardImageModel(
        id: id, cardId: questionCardId, imagePath: imagePath, sortOrder: sortOrder);
  }

  @override
  Future<void> removeImage(CardImageModel image) =>
      _imgCol.doc(image.id).delete();

  QuestionCardModel _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final createdAt = _readDate(data, 'createdAt');
    return QuestionCardModel(
      id: doc.id,
      directoryId: data['directoryId'] as String,
      knowledgeCardId: data['knowledgeCardId'] as String,
      title: data['title'] as String,
      questionMd: data['questionMd'] as String? ?? '',
      createdAt: createdAt,
      updatedAt: _readDate(data, 'updatedAt', fallback: createdAt),
    );
  }

  DateTime _readDate(
    Map<String, dynamic> data,
    String key, {
    DateTime? fallback,
  }) {
    final value = data[key];
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) {
      return DateTime.tryParse(value) ??
          (fallback ?? DateTime.fromMillisecondsSinceEpoch(0));
    }
    return fallback ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  CardImageModel _fromImgDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return CardImageModel(
      id: doc.id,
      cardId: data['questionCardId'] as String,
      imagePath: data['imagePath'] as String,
      sortOrder: data['sortOrder'] as int? ?? 0,
    );
  }
}
