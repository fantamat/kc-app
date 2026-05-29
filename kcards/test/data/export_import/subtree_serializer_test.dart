import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:kcards/data/export_import/subtree_serializer.dart';
import 'package:kcards/data/models/card_image_model.dart';
import 'package:kcards/data/models/directory_model.dart';
import 'package:kcards/data/models/knowledge_card_model.dart';
import 'package:kcards/data/models/question_card_model.dart';
import 'package:kcards/data/repositories/interfaces/i_directory_repository.dart';
import 'package:kcards/data/repositories/interfaces/i_knowledge_card_repository.dart';
import 'package:kcards/data/repositories/interfaces/i_question_card_repository.dart';
import 'package:kcards/data/services/image_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDirectoryRepository extends Mock implements IDirectoryRepository {}

class MockKnowledgeCardRepository extends Mock
    implements IKnowledgeCardRepository {}

class MockQuestionCardRepository extends Mock implements IQuestionCardRepository {}

class MockImageService extends Mock implements ImageService {}

DirectoryModel _dir({
  required String id,
  required String name,
  String? parentId,
}) {
  return DirectoryModel(
    id: id,
    name: name,
    parentId: parentId,
    createdAt: DateTime.utc(2026, 1, 1),
  );
}

KnowledgeCardModel _kc({
  required String id,
  required String directoryId,
  required String title,
  String contentMd = '',
}) {
  return KnowledgeCardModel(
    id: id,
    directoryId: directoryId,
    title: title,
    contentMd: contentMd,
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: DateTime.utc(2026, 1, 1),
  );
}

QuestionCardModel _qc({
  required String id,
  required String directoryId,
  required String knowledgeCardId,
  required String title,
  String questionMd = '',
}) {
  return QuestionCardModel(
    id: id,
    directoryId: directoryId,
    knowledgeCardId: knowledgeCardId,
    title: title,
    questionMd: questionMd,
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: DateTime.utc(2026, 1, 1),
  );
}

CardImageModel _img({
  required String id,
  required String cardId,
  required String imagePath,
  required int sortOrder,
}) {
  return CardImageModel(
    id: id,
    cardId: cardId,
    imagePath: imagePath,
    sortOrder: sortOrder,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(<String>[]);
    registerFallbackValue(Uint8List(0));
  });

  late MockDirectoryRepository dirRepo;
  late MockKnowledgeCardRepository kcRepo;
  late MockQuestionCardRepository qcRepo;
  late MockImageService imageService;
  late SubtreeSerializer serializer;

  setUp(() {
    dirRepo = MockDirectoryRepository();
    kcRepo = MockKnowledgeCardRepository();
    qcRepo = MockQuestionCardRepository();
    imageService = MockImageService();

    serializer = SubtreeSerializer(
      dirRepo: dirRepo,
      kcRepo: kcRepo,
      qcRepo: qcRepo,
      imageService: imageService,
    );
  });

  group('SubtreeSerializer export', () {
    test('throws for unknown directory ID', () async {
      when(() => dirRepo.getById('missing')).thenAnswer((_) async => null);

      await expectLater(
        () => serializer.exportSubtree('missing'),
        throwsA(isA<ArgumentError>()),
      );

      verify(() => dirRepo.getById('missing')).called(1);
      verifyNever(() => dirRepo.getAll());
      verifyNever(() => kcRepo.getByDirectory(any()));
      verifyNever(() => qcRepo.getByDirectoryIds(any()));
      verifyNever(() => imageService.readBytes(any()));
    });

    test('includes expected envelope fields', () async {
      final root = _dir(id: 'root', name: 'Root');

      when(() => dirRepo.getById('root')).thenAnswer((_) async => root);
      when(() => dirRepo.getAll()).thenAnswer((_) async => [root]);
      when(() => kcRepo.getByDirectory('root')).thenAnswer((_) async => []);
      when(() => qcRepo.getByDirectoryIds(any())).thenAnswer((_) async => []);

      final json = await serializer.exportSubtree('root');

      expect(json['version'], 1);
      expect(json.containsKey('exportedAt'), isTrue);
      expect(DateTime.parse(json['exportedAt'] as String), isA<DateTime>());
      expect(json.containsKey('directory'), isTrue);

      final directory = json['directory'] as Map<String, dynamic>;
      expect(directory['name'], 'Root');
      expect(directory['knowledgeCards'], isEmpty);
      expect(directory['children'], isEmpty);
    });

    test('exports nested directory structure recursively', () async {
      final root = _dir(id: 'root', name: 'Root');
      final child = _dir(id: 'child', name: 'Child', parentId: 'root');
      final grandChild = _dir(id: 'grand', name: 'Grand', parentId: 'child');

      when(() => dirRepo.getById('root')).thenAnswer((_) async => root);
      when(() => dirRepo.getAll())
          .thenAnswer((_) async => [root, child, grandChild]);
      when(() => kcRepo.getByDirectory(any())).thenAnswer((_) async => []);
      when(() => qcRepo.getByDirectoryIds(any())).thenAnswer((_) async => []);

      final json = await serializer.exportSubtree('root');

      final rootJson = json['directory'] as Map<String, dynamic>;
      final children = rootJson['children'] as List<dynamic>;
      expect(children, hasLength(1));
      final childJson = children.single as Map<String, dynamic>;
      expect(childJson['name'], 'Child');

      final grandChildren = childJson['children'] as List<dynamic>;
      expect(grandChildren, hasLength(1));
      final grandChildJson = grandChildren.single as Map<String, dynamic>;
      expect(grandChildJson['name'], 'Grand');
    });

    test(
        'exports knowledge cards, linked question cards, and image payloads',
        () async {
      final root = _dir(id: 'root', name: 'Root');
      final kc = _kc(
        id: 'kc-1',
        directoryId: 'root',
        title: 'Knowledge 1',
        contentMd: 'Content 1',
      );
      final qc = _qc(
        id: 'qc-1',
        directoryId: 'root',
        knowledgeCardId: 'kc-1',
        title: 'Question 1',
        questionMd: 'What is 1?',
      );
      final kcImgOk = _img(
        id: 'kimg-ok',
        cardId: 'kc-1',
        imagePath: '/img/kc-ok.png',
        sortOrder: 0,
      );
      final kcImgMissing = _img(
        id: 'kimg-missing',
        cardId: 'kc-1',
        imagePath: '/img/kc-missing.png',
        sortOrder: 1,
      );
      final qcImgOk = _img(
        id: 'qimg-ok',
        cardId: 'qc-1',
        imagePath: '/img/qc-ok.png',
        sortOrder: 0,
      );
      final kcBytes = Uint8List.fromList([1, 2, 3]);
      final qcBytes = Uint8List.fromList([9, 8, 7]);

      when(() => dirRepo.getById('root')).thenAnswer((_) async => root);
      when(() => dirRepo.getAll()).thenAnswer((_) async => [root]);
      when(() => kcRepo.getByDirectory('root')).thenAnswer((_) async => [kc]);
      when(() => qcRepo.getByDirectoryIds(any())).thenAnswer((_) async => [qc]);
      when(() => kcRepo.getImages('kc-1'))
          .thenAnswer((_) async => [kcImgOk, kcImgMissing]);
      when(() => qcRepo.getImages('qc-1')).thenAnswer((_) async => [qcImgOk]);
      when(() => imageService.readBytes('/img/kc-ok.png'))
          .thenAnswer((_) async => kcBytes);
      when(() => imageService.readBytes('/img/kc-missing.png'))
          .thenAnswer((_) async => null);
      when(() => imageService.readBytes('/img/qc-ok.png'))
          .thenAnswer((_) async => qcBytes);

      final json = await serializer.exportSubtree('root');

      final rootJson = json['directory'] as Map<String, dynamic>;
      final cards = rootJson['knowledgeCards'] as List<dynamic>;
      expect(cards, hasLength(1));

      final card = cards.single as Map<String, dynamic>;
      expect(card['title'], 'Knowledge 1');
      expect(card['contentMd'], 'Content 1');
      expect(card['images'], [base64Encode(kcBytes)]);

      final questionCards = card['questionCards'] as List<dynamic>;
      expect(questionCards, hasLength(1));
      final question = questionCards.single as Map<String, dynamic>;
      expect(question['title'], 'Question 1');
      expect(question['questionMd'], 'What is 1?');
      expect(question['images'], [base64Encode(qcBytes)]);

      verify(() => imageService.readBytes('/img/kc-ok.png')).called(1);
      verify(() => imageService.readBytes('/img/kc-missing.png')).called(1);
      verify(() => imageService.readBytes('/img/qc-ok.png')).called(1);
    });
  });

  group('SubtreeSerializer import', () {
    test('rejects unsupported version', () async {
      final json = <String, dynamic>{
        'version': 2,
        'exportedAt': '2026-05-29T12:00:00.000Z',
        'directory': <String, dynamic>{
          'name': 'Root',
          'knowledgeCards': <dynamic>[],
          'children': <dynamic>[],
        },
      };

      await expectLater(
        () => serializer.importSubtree(json, null),
        throwsA(isA<ArgumentError>()),
      );

      verifyNever(() => dirRepo.getAll());
      verifyNever(() => dirRepo.create(name: any(named: 'name'), parentId: any(named: 'parentId')));
      verifyNever(() => kcRepo.create(
            directoryId: any(named: 'directoryId'),
            title: any(named: 'title'),
            contentMd: any(named: 'contentMd'),
          ));
      verifyNever(() => qcRepo.create(
            directoryId: any(named: 'directoryId'),
            knowledgeCardId: any(named: 'knowledgeCardId'),
            title: any(named: 'title'),
            questionMd: any(named: 'questionMd'),
          ));
      verifyNever(() => imageService.saveBytes(any(), any()));
    });

    test('reuses existing directory with same name under same parent',
        () async {
      final existing = _dir(id: 'd-1', name: 'Root', parentId: 'parent-1');
      final json = <String, dynamic>{
        'version': 1,
        'directory': <String, dynamic>{
          'name': 'Root',
          'knowledgeCards': <dynamic>[],
          'children': <dynamic>[],
        },
      };

      when(() => dirRepo.getAll()).thenAnswer((_) async => [existing]);

      await serializer.importSubtree(json, 'parent-1');

      verify(() => dirRepo.getAll()).called(1);
      verifyNever(() => dirRepo.create(name: 'Root', parentId: 'parent-1'));
    });

    test('skips knowledge card if title already exists in target directory',
        () async {
      final existingDir = _dir(id: 'd-1', name: 'Root');
      final existingCard = _kc(
        id: 'kc-existing',
        directoryId: 'd-1',
        title: 'Duplicate title',
      );
      final json = <String, dynamic>{
        'version': 1,
        'directory': <String, dynamic>{
          'name': 'Root',
          'knowledgeCards': <dynamic>[
            <String, dynamic>{
              'title': 'Duplicate title',
              'contentMd': 'new content',
              'images': <dynamic>[base64Encode(Uint8List.fromList([1, 2]))],
              'questionCards': <dynamic>[
                <String, dynamic>{
                  'title': 'Q',
                  'questionMd': 'Should be skipped',
                },
              ],
            },
          ],
          'children': <dynamic>[],
        },
      };

      when(() => dirRepo.getAll()).thenAnswer((_) async => [existingDir]);
      when(() => kcRepo.getByDirectory('d-1'))
          .thenAnswer((_) async => [existingCard]);

      await serializer.importSubtree(json, null);

      verify(() => kcRepo.getByDirectory('d-1')).called(1);
      verifyNever(() => kcRepo.create(
            directoryId: any(named: 'directoryId'),
            title: any(named: 'title'),
            contentMd: any(named: 'contentMd'),
          ));
      verifyNever(() => qcRepo.create(
            directoryId: any(named: 'directoryId'),
            knowledgeCardId: any(named: 'knowledgeCardId'),
            title: any(named: 'title'),
            questionMd: any(named: 'questionMd'),
          ));
      verifyNever(() => imageService.saveBytes(any(), any()));
    });

    test('creates question cards under imported knowledge card', () async {
      final existingDir = _dir(id: 'd-1', name: 'Root');
      final importedKc = _kc(
        id: 'kc-new',
        directoryId: 'd-1',
        title: 'Imported',
      );
      final json = <String, dynamic>{
        'version': 1,
        'directory': <String, dynamic>{
          'name': 'Root',
          'knowledgeCards': <dynamic>[
            <String, dynamic>{
              'title': 'Imported',
              'contentMd': 'Body',
              'questionCards': <dynamic>[
                <String, dynamic>{'title': 'Q1', 'questionMd': 'one'},
                <String, dynamic>{'title': 'Q2', 'questionMd': 'two'},
              ],
            },
          ],
          'children': <dynamic>[],
        },
      };

      when(() => dirRepo.getAll()).thenAnswer((_) async => [existingDir]);
      when(() => kcRepo.getByDirectory('d-1')).thenAnswer((_) async => []);
      when(() => kcRepo.create(
            directoryId: 'd-1',
            title: 'Imported',
            contentMd: 'Body',
          )).thenAnswer((_) async => importedKc);
      when(() => qcRepo.create(
            directoryId: any(named: 'directoryId'),
            knowledgeCardId: any(named: 'knowledgeCardId'),
            title: any(named: 'title'),
            questionMd: any(named: 'questionMd'),
          )).thenAnswer((invocation) async {
        final title = invocation.namedArguments[#title] as String;
        final questionMd = invocation.namedArguments[#questionMd] as String;
        return _qc(
          id: 'qc-$title',
          directoryId: 'd-1',
          knowledgeCardId: 'kc-new',
          title: title,
          questionMd: questionMd,
        );
      });

      await serializer.importSubtree(json, null);

      verify(() => qcRepo.create(
            directoryId: 'd-1',
            knowledgeCardId: 'kc-new',
            title: 'Q1',
            questionMd: 'one',
          )).called(1);
      verify(() => qcRepo.create(
            directoryId: 'd-1',
            knowledgeCardId: 'kc-new',
            title: 'Q2',
            questionMd: 'two',
          )).called(1);
    });

    test('decodes and saves image payloads through ImageService.saveBytes',
        () async {
      final existingDir = _dir(id: 'd-1', name: 'Root');
      final importedKc = _kc(
        id: 'kc-new',
        directoryId: 'd-1',
        title: 'Imported',
      );
      final importedQc = _qc(
        id: 'qc-new',
        directoryId: 'd-1',
        knowledgeCardId: 'kc-new',
        title: 'Q1',
      );
      final kcImg0 = Uint8List.fromList([1, 2, 3]);
      final kcImg1 = Uint8List.fromList([4, 5, 6]);
      final qcImg0 = Uint8List.fromList([7, 8, 9]);

      final json = <String, dynamic>{
        'version': 1,
        'directory': <String, dynamic>{
          'name': 'Root',
          'knowledgeCards': <dynamic>[
            <String, dynamic>{
              'title': 'Imported',
              'contentMd': 'Body',
              'images': <dynamic>[
                base64Encode(kcImg0),
                base64Encode(kcImg1),
              ],
              'questionCards': <dynamic>[
                <String, dynamic>{
                  'title': 'Q1',
                  'questionMd': 'one',
                  'images': <dynamic>[base64Encode(qcImg0)],
                },
              ],
            },
          ],
          'children': <dynamic>[],
        },
      };

      when(() => dirRepo.getAll()).thenAnswer((_) async => [existingDir]);
      when(() => kcRepo.getByDirectory('d-1')).thenAnswer((_) async => []);
      when(() => kcRepo.create(
            directoryId: 'd-1',
            title: 'Imported',
            contentMd: 'Body',
          )).thenAnswer((_) async => importedKc);
      when(() => kcRepo.addImage(any(), any(), any())).thenAnswer((invocation) async {
        final cardId = invocation.positionalArguments[0] as String;
        final imagePath = invocation.positionalArguments[1] as String;
        final sortOrder = invocation.positionalArguments[2] as int;
        return _img(
          id: 'kc-img-$sortOrder',
          cardId: cardId,
          imagePath: imagePath,
          sortOrder: sortOrder,
        );
      });
      when(() => qcRepo.create(
            directoryId: 'd-1',
            knowledgeCardId: 'kc-new',
            title: 'Q1',
            questionMd: 'one',
          )).thenAnswer((_) async => importedQc);
      when(() => qcRepo.addImage(any(), any(), any())).thenAnswer((invocation) async {
        final cardId = invocation.positionalArguments[0] as String;
        final imagePath = invocation.positionalArguments[1] as String;
        final sortOrder = invocation.positionalArguments[2] as int;
        return _img(
          id: 'qc-img-$sortOrder',
          cardId: cardId,
          imagePath: imagePath,
          sortOrder: sortOrder,
        );
      });
      when(() => imageService.saveBytes(any(), any())).thenAnswer((invocation) async {
        final prefix = invocation.positionalArguments[1] as String;
        return '/tmp/$prefix.png';
      });

      await serializer.importSubtree(json, null);

      final saveVerify = verify(() => imageService.saveBytes(captureAny(), captureAny()));
      saveVerify.called(3);
      final captured = saveVerify.captured;
      expect(captured, hasLength(6));

      expect(base64Encode(captured[0] as Uint8List), base64Encode(kcImg0));
      expect(captured[1], 'import_kc_kc-new_0');
      expect(base64Encode(captured[2] as Uint8List), base64Encode(kcImg1));
      expect(captured[3], 'import_kc_kc-new_1');
      expect(base64Encode(captured[4] as Uint8List), base64Encode(qcImg0));
      expect(captured[5], 'import_qc_qc-new_0');

      verify(() => kcRepo.addImage('kc-new', '/tmp/import_kc_kc-new_0.png', 0))
          .called(1);
      verify(() => kcRepo.addImage('kc-new', '/tmp/import_kc_kc-new_1.png', 1))
          .called(1);
      verify(() => qcRepo.addImage('qc-new', '/tmp/import_qc_qc-new_0.png', 0))
          .called(1);
    });
  });
}
