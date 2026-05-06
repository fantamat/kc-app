import 'dart:convert';
import 'dart:io' as io;

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../database/database.dart';
import '../repositories/directory_repository.dart';
import '../repositories/knowledge_card_repository.dart';
import '../repositories/question_card_repository.dart';

class SubtreeSerializer {
  SubtreeSerializer({
    required AppDatabase db,
    required DirectoryRepository dirRepo,
    required KnowledgeCardRepository kcRepo,
    required QuestionCardRepository qcRepo,
  })  : _db = db,
        _dirRepo = dirRepo,
        _kcRepo = kcRepo,
        _qcRepo = qcRepo;

  final AppDatabase _db;
  final DirectoryRepository _dirRepo;
  final KnowledgeCardRepository _kcRepo;
  final QuestionCardRepository _qcRepo;

  // ── Export ────────────────────────────────────────────────────────────────

  /// Serializes [directoryId] and all its descendants to a JSON-encodable map.
  Future<Map<String, dynamic>> exportSubtree(int directoryId) async {
    final dir = await _dirRepo.getById(directoryId);
    if (dir == null) throw ArgumentError('Directory $directoryId not found');
    return {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'directory': await _exportDir(directoryId, dir.name),
    };
  }

  Future<Map<String, dynamic>> _exportDir(int dirId, String name) async {
    final allDirs = await _db.directoryDao.getAll();
    final children = allDirs.where((d) => d.parentId == dirId).toList();

    final kcs = await _kcRepo.getByDirectory(dirId);
    final allQcs = await _db.questionCardDao.getByDirectoryIds([dirId]);

    final kcMaps = await Future.wait(
      kcs.map((kc) {
        final qcs = allQcs.where((q) => q.knowledgeCardId == kc.id).toList();
        return _exportKc(kc, qcs);
      }),
    );

    final childMaps = await Future.wait(
      children.map((d) => _exportDir(d.id, d.name)),
    );

    return {
      'name': name,
      'knowledgeCards': kcMaps,
      'children': childMaps,
    };
  }

  Future<Map<String, dynamic>> _exportKc(
    KnowledgeCard kc,
    List<QuestionCard> qcs,
  ) async {
    final images = await _db.knowledgeCardDao.getImages(kc.id);
    return {
      'title': kc.title,
      'contentMd': kc.contentMd,
      'images': (await Future.wait(images.map(_encodeKcImage)))
          .whereType<String>()
          .toList(),
      'questionCards': await Future.wait(qcs.map(_exportQc)),
    };
  }

  Future<Map<String, dynamic>> _exportQc(QuestionCard qc) async {
    final images = await _db.questionCardDao.getImages(qc.id);
    return {
      'title': qc.title,
      'questionMd': qc.questionMd,
      'images': (await Future.wait(images.map(_encodeQcImage)))
          .whereType<String>()
          .toList(),
    };
  }

  Future<String?> _encodeKcImage(KnowledgeCardImage img) async {
    final file = io.File(img.localPath);
    if (!file.existsSync()) return null;
    return base64Encode(await file.readAsBytes());
  }

  Future<String?> _encodeQcImage(QuestionCardImage img) async {
    final file = io.File(img.localPath);
    if (!file.existsSync()) return null;
    return base64Encode(await file.readAsBytes());
  }

  // ── Import ────────────────────────────────────────────────────────────────

  /// Deserializes [json] (produced by [exportSubtree]) under [parentId].
  /// Skips directories/knowledge cards that already exist at the same level.
  Future<void> importSubtree(
    Map<String, dynamic> json,
    int? parentId,
  ) async {
    final version = json['version'] as int?;
    if (version != 1) {
      throw ArgumentError('Unsupported export version: $version');
    }
    final dirData = json['directory'] as Map<String, dynamic>;
    await _importDir(dirData, parentId);
  }

  Future<void> _importDir(Map<String, dynamic> data, int? parentId) async {
    final name = data['name'] as String;

    // Reuse existing directory with same name under same parent.
    final allDirs = await _db.directoryDao.getAll();
    final existing =
        allDirs.where((d) => d.parentId == parentId && d.name == name).firstOrNull;
    final dir = existing ?? await _dirRepo.create(name: name, parentId: parentId);

    final kcs = (data['knowledgeCards'] as List<dynamic>?) ?? [];
    for (final kcData in kcs) {
      await _importKc(kcData as Map<String, dynamic>, dir.id);
    }

    final children = (data['children'] as List<dynamic>?) ?? [];
    for (final child in children) {
      await _importDir(child as Map<String, dynamic>, dir.id);
    }
  }

  Future<void> _importKc(Map<String, dynamic> data, int dirId) async {
    final title = data['title'] as String;
    final contentMd = data['contentMd'] as String? ?? '';

    // Skip if a knowledge card with the same title already exists here.
    final existingKcs = await _kcRepo.getByDirectory(dirId);
    if (existingKcs.any((kc) => kc.title == title)) return;

    final kc = await _kcRepo.create(
      directoryId: dirId,
      title: title,
      contentMd: contentMd,
    );

    final images = (data['images'] as List<dynamic>?) ?? [];
    for (int i = 0; i < images.length; i++) {
      final b64 = images[i] as String?;
      if (b64 == null) continue;
      final localPath = await _saveBase64Image(b64, 'kc_${kc.id}_$i');
      await _kcRepo.addImage(kc.id, localPath, i);
    }

    final qcs = (data['questionCards'] as List<dynamic>?) ?? [];
    for (final qcData in qcs) {
      await _importQc(qcData as Map<String, dynamic>, dirId, kc.id);
    }
  }

  Future<void> _importQc(
    Map<String, dynamic> data,
    int dirId,
    int kcId,
  ) async {
    final title = data['title'] as String? ?? '';
    final questionMd = data['questionMd'] as String? ?? '';
    final qc = await _qcRepo.create(
      directoryId: dirId,
      knowledgeCardId: kcId,
      title: title,
      questionMd: questionMd,
    );

    final images = (data['images'] as List<dynamic>?) ?? [];
    for (int i = 0; i < images.length; i++) {
      final b64 = images[i] as String?;
      if (b64 == null) continue;
      final localPath = await _saveBase64Image(b64, 'qc_${qc.id}_$i');
      await _qcRepo.addImage(qc.id, localPath, i);
    }
  }

  Future<String> _saveBase64Image(String b64, String prefix) async {
    final dir = await getApplicationDocumentsDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final filePath = p.join(dir.path, 'import_${prefix}_$ts.jpg');
    await io.File(filePath).writeAsBytes(base64Decode(b64));
    return filePath;
  }
}
