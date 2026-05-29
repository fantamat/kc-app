import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'package:kcards/data/models/card_image_model.dart';
import 'package:kcards/data/models/knowledge_card_model.dart';
import 'package:kcards/data/repositories/interfaces/i_knowledge_card_repository.dart';

class FirebaseKnowledgeCardRepository implements IKnowledgeCardRepository {
  FirebaseKnowledgeCardRepository({
    required FirebaseFirestore firestore,
    required String uid,
  })  : _col = firestore
            .collection('users')
            .doc(uid)
            .collection('knowledgeCards'),
        _imgCol = firestore
            .collection('users')
            .doc(uid)
            .collection('knowledgeCardImages'),
        _qcCol = firestore
            .collection('users')
            .doc(uid)
            .collection('questionCards');

  final CollectionReference<Map<String, dynamic>> _col;
  final CollectionReference<Map<String, dynamic>> _imgCol;
  final CollectionReference<Map<String, dynamic>> _qcCol;

  @override
  Stream<List<KnowledgeCardModel>> watchByDirectory(String directoryId) =>
      _col
          .where('directoryId', isEqualTo: directoryId)
          .orderBy('title')
          .snapshots()
          .map((snap) => snap.docs.map(_fromDoc).toList());

  @override
  Future<List<KnowledgeCardModel>> getByDirectory(String directoryId) async {
    final snap =
        await _col.where('directoryId', isEqualTo: directoryId).get();
    return snap.docs.map(_fromDoc).toList();
  }

  @override
  Future<List<KnowledgeCardModel>> getByDirectoryIds(
      List<String> dirIds) async {
    if (dirIds.isEmpty) return [];
    // Firestore whereIn supports up to 30 values per query.
    final results = <KnowledgeCardModel>[];
    for (var i = 0; i < dirIds.length; i += 30) {
      final chunk = dirIds.sublist(i, i + 30 < dirIds.length ? i + 30 : dirIds.length);
      final snap =
          await _col.where('directoryId', whereIn: chunk).get();
      results.addAll(snap.docs.map(_fromDoc));
    }
    return results;
  }

  @override
  Future<KnowledgeCardModel?> getById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return _fromDoc(doc);
  }

  @override
  Future<KnowledgeCardModel> create({
    required String directoryId,
    required String title,
    String contentMd = '',
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    await _col.doc(id).set({
      'directoryId': directoryId,
      'title': title,
      'contentMd': contentMd,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    });
    return KnowledgeCardModel(
      id: id,
      directoryId: directoryId,
      title: title,
      contentMd: contentMd,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<void> update(String id, {String? title, String? contentMd}) async {
    final updates = <String, dynamic>{'updatedAt': FieldValue.serverTimestamp()};
    if (title != null) updates['title'] = title;
    if (contentMd != null) updates['contentMd'] = contentMd;
    await _col.doc(id).update(updates);
  }

  @override
  Future<void> delete(String id) async {
    if (await hasLinkedQuestionCards(id)) {
      throw StateError(
          'Cannot delete a KnowledgeCard that has linked QuestionCards.');
    }
    final imgSnap =
        await _imgCol.where('knowledgeCardId', isEqualTo: id).get();
    final batch = _col.firestore.batch();
    for (final doc in imgSnap.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_col.doc(id));
    await batch.commit();
  }

  @override
  Future<bool> hasLinkedQuestionCards(String id) async {
    final snap = await _qcCol
        .where('knowledgeCardId', isEqualTo: id)
        .limit(1)
        .get();
    return snap.docs.isNotEmpty;
  }

  // ── Images ────────────────────────────────────────────────────────────────

  @override
  Stream<List<CardImageModel>> watchImages(String knowledgeCardId) =>
      _imgCol
          .where('knowledgeCardId', isEqualTo: knowledgeCardId)
          .orderBy('sortOrder')
          .snapshots()
          .map((snap) => snap.docs.map(_fromImgDoc).toList());

  @override
  Future<List<CardImageModel>> getImages(String knowledgeCardId) async {
    final snap = await _imgCol
        .where('knowledgeCardId', isEqualTo: knowledgeCardId)
        .orderBy('sortOrder')
        .get();
    return snap.docs.map(_fromImgDoc).toList();
  }

  @override
  Future<CardImageModel> addImage(
    String knowledgeCardId,
    String imagePath,
    int sortOrder,
  ) async {
    final id = const Uuid().v4();
    await _imgCol.doc(id).set({
      'knowledgeCardId': knowledgeCardId,
      'imagePath': imagePath,
      'sortOrder': sortOrder,
    });
    return CardImageModel(
        id: id, cardId: knowledgeCardId, imagePath: imagePath, sortOrder: sortOrder);
  }

  @override
  Future<void> removeImage(CardImageModel image) =>
      _imgCol.doc(image.id).delete();

  KnowledgeCardModel _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final createdAt = _readDate(data, 'createdAt');
    return KnowledgeCardModel(
      id: doc.id,
      directoryId: data['directoryId'] as String,
      title: data['title'] as String,
      contentMd: data['contentMd'] as String? ?? '',
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
    if (value is String) return DateTime.tryParse(value) ?? (fallback ?? DateTime.fromMillisecondsSinceEpoch(0));
    return fallback ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  CardImageModel _fromImgDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return CardImageModel(
      id: doc.id,
      cardId: data['knowledgeCardId'] as String,
      imagePath: data['imagePath'] as String,
      sortOrder: data['sortOrder'] as int? ?? 0,
    );
  }
}
