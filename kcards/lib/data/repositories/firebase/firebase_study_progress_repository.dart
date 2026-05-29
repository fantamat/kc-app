import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'package:kcards/data/models/study_progress_model.dart';
import 'package:kcards/data/repositories/interfaces/i_study_progress_repository.dart';

class FirebaseStudyProgressRepository implements IStudyProgressRepository {
  FirebaseStudyProgressRepository({
    required FirebaseFirestore firestore,
    required String uid,
  }) : _col = firestore
            .collection('users')
            .doc(uid)
            .collection('studyProgress');

  final CollectionReference<Map<String, dynamic>> _col;

  @override
  Stream<StudyProgressModel?> watchByQuestionCard(String questionCardId) =>
      _col
          .where('questionCardId', isEqualTo: questionCardId)
          .limit(1)
          .snapshots()
          .map((snap) =>
              snap.docs.isNotEmpty ? _fromDoc(snap.docs.first) : null);

  @override
  Future<StudyProgressModel?> getByQuestionCard(String questionCardId) async {
    final snap = await _col
        .where('questionCardId', isEqualTo: questionCardId)
        .limit(1)
        .get();
    return snap.docs.isNotEmpty ? _fromDoc(snap.docs.first) : null;
  }

  @override
  Future<void> recordReview(String questionCardId,
      {required bool correct}) async {
    final existing = await getByQuestionCard(questionCardId);
    if (existing == null) {
      final id = const Uuid().v4();
      await _col.doc(id).set({
        'questionCardId': questionCardId,
        'timesReviewed': 1,
        'timesCorrect': correct ? 1 : 0,
        'timesIncorrect': correct ? 0 : 1,
        'lastReviewedAt': FieldValue.serverTimestamp(),
      });
    } else {
      await _col.doc(existing.id).update({
        'timesReviewed': existing.timesReviewed + 1,
        'timesCorrect': existing.timesCorrect + (correct ? 1 : 0),
        'timesIncorrect': existing.timesIncorrect + (correct ? 0 : 1),
        'lastReviewedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  StudyProgressModel _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return StudyProgressModel(
      id: doc.id,
      questionCardId: data['questionCardId'] as String,
      timesReviewed: data['timesReviewed'] as int? ?? 0,
      timesCorrect: data['timesCorrect'] as int? ?? 0,
      timesIncorrect: data['timesIncorrect'] as int? ?? 0,
      lastReviewedAt: _readNullableDate(data, 'lastReviewedAt'),
    );
  }

  DateTime? _readNullableDate(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
