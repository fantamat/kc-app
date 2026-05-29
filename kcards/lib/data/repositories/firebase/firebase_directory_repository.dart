import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'package:kcards/data/models/directory_model.dart';
import 'package:kcards/data/repositories/interfaces/i_directory_repository.dart';

class FirebaseDirectoryRepository implements IDirectoryRepository {
  FirebaseDirectoryRepository({
    required FirebaseFirestore firestore,
    required String uid,
  }) : _col = firestore.collection('users').doc(uid).collection('directories'),
       _kcCol = firestore.collection('users').doc(uid).collection('knowledgeCards'),
       _kcImgCol = firestore.collection('users').doc(uid).collection('knowledgeCardImages'),
       _qcCol = firestore.collection('users').doc(uid).collection('questionCards'),
       _qcImgCol = firestore.collection('users').doc(uid).collection('questionCardImages'),
       _spCol = firestore.collection('users').doc(uid).collection('studyProgress');

  final CollectionReference<Map<String, dynamic>> _col;
  final CollectionReference<Map<String, dynamic>> _kcCol;
  final CollectionReference<Map<String, dynamic>> _kcImgCol;
  final CollectionReference<Map<String, dynamic>> _qcCol;
  final CollectionReference<Map<String, dynamic>> _qcImgCol;
  final CollectionReference<Map<String, dynamic>> _spCol;

  @override
  Stream<List<DirectoryModel>> watchChildren(String? parentId) {
    Query<Map<String, dynamic>> q = _col;
    q = parentId == null
        ? q.where('parentId', isNull: true)
        : q.where('parentId', isEqualTo: parentId);
    return q
        .snapshots()
        .map((snap) => snap.docs.map(_fromDoc).toList());
  }

  @override
  Future<DirectoryModel?> getById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return _fromDoc(doc);
  }

  @override
  Future<List<DirectoryModel>> getAll() async {
    final snap = await _col.get();
    return snap.docs.map(_fromDoc).toList();
  }

  @override
  Future<DirectoryModel> create({
    required String name,
    String? parentId,
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    await _col.doc(id).set({
      'name': name,
      'parentId': parentId,
      'createdAt': Timestamp.fromDate(now),
    });
    return DirectoryModel(id: id, name: name, parentId: parentId, createdAt: now);
  }

  @override
  Future<void> rename(String id, String newName) =>
      _col.doc(id).update({'name': newName});

  @override
  Future<List<String>> getSubtreeIds(String directoryId) async {
    final all = await getAll();
    final result = <String>[];
    _collectIds(all, directoryId, result);
    return result;
  }

  @override
  Future<void> deleteSubtree(String directoryId) async {
    final dirIds = await getSubtreeIds(directoryId);

    // Delete all question card images + study progress + question cards.
    for (final dirId in dirIds) {
      final qcSnap = await _qcCol.where('directoryId', isEqualTo: dirId).get();
      for (final qcDoc in qcSnap.docs) {
        final qcId = qcDoc.id;
        final imgSnap =
            await _qcImgCol.where('questionCardId', isEqualTo: qcId).get();
        await _deleteBatch(imgSnap.docs.map((d) => d.reference).toList());
        final spSnap =
            await _spCol.where('questionCardId', isEqualTo: qcId).get();
        await _deleteBatch(spSnap.docs.map((d) => d.reference).toList());
      }
      await _deleteBatch(qcSnap.docs.map((d) => d.reference).toList());
    }

    // Delete all knowledge card images + knowledge cards.
    for (final dirId in dirIds) {
      final kcSnap = await _kcCol.where('directoryId', isEqualTo: dirId).get();
      for (final kcDoc in kcSnap.docs) {
        final kcId = kcDoc.id;
        final imgSnap =
            await _kcImgCol.where('knowledgeCardId', isEqualTo: kcId).get();
        await _deleteBatch(imgSnap.docs.map((d) => d.reference).toList());
      }
      await _deleteBatch(kcSnap.docs.map((d) => d.reference).toList());
    }

    // Delete directories leaf-first.
    for (final id in dirIds.reversed) {
      await _col.doc(id).delete();
    }
  }

  Future<void> _deleteBatch(
      List<DocumentReference<Map<String, dynamic>>> refs) async {
    if (refs.isEmpty) return;
    final batch = _col.firestore.batch();
    for (final ref in refs) {
      batch.delete(ref);
    }
    await batch.commit();
  }

  void _collectIds(
      List<DirectoryModel> all, String parentId, List<String> out) {
    out.add(parentId);
    for (final dir in all) {
      if (dir.parentId == parentId) _collectIds(all, dir.id, out);
    }
  }

  DirectoryModel _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return DirectoryModel(
      id: doc.id,
      name: data['name'] as String,
      parentId: data['parentId'] as String?,
      createdAt: _readDate(data, 'createdAt'),
    );
  }

  DateTime _readDate(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}
