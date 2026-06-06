# Unit Test Scope (High Level)

This document describes what should be covered by unit tests first, based on
current project structure and risk areas.

## Goals

- Protect core data behavior from regressions.
- Verify backend selection logic (local vs Firebase) at provider boundaries.
- Validate import/export correctness for directory subtrees.
- Keep UI-heavy behavior mostly in widget tests; keep unit tests focused on
  logic, transformations, and side effects.

## Priority 1: Core data/repository behavior

### LocalDirectoryRepository

Related files:
- [lib/data/repositories/local/local_directory_repository.dart](lib/data/repositories/local/local_directory_repository.dart)
- [lib/data/repositories/interfaces/i_directory_repository.dart](lib/data/repositories/interfaces/i_directory_repository.dart)
- [lib/data/database/daos/directory_dao.dart](lib/data/database/daos/directory_dao.dart)
- [lib/data/database/database.dart](lib/data/database/database.dart)

Test:
- `create` stores name, parent relation, and generated ID.
- `rename` updates existing directory and no-ops for unknown IDs.
- `getSubtreeIds` returns root + descendants recursively.
- `deleteSubtree` removes:
  - directories in subtree,
  - knowledge cards and question cards in subtree,
  - linked study progress,
  - image records and image files when present.

### LocalKnowledgeCardRepository

Related files:
- [lib/data/repositories/local/local_knowledge_card_repository.dart](lib/data/repositories/local/local_knowledge_card_repository.dart)
- [lib/data/repositories/interfaces/i_knowledge_card_repository.dart](lib/data/repositories/interfaces/i_knowledge_card_repository.dart)
- [lib/data/database/daos/knowledge_card_dao.dart](lib/data/database/daos/knowledge_card_dao.dart)
- [lib/data/database/database.dart](lib/data/database/database.dart)

Test:
- create/get/update round trip.
- update refreshes `updatedAt`.
- delete throws when linked question cards exist.
- delete removes images both from DB rows and file system.
- image helpers (`addImage`, `getImages`, `removeImage`) keep sort order and
  cleanup behavior.

### LocalQuestionCardRepository

Related files:
- [lib/data/repositories/local/local_question_card_repository.dart](lib/data/repositories/local/local_question_card_repository.dart)
- [lib/data/repositories/interfaces/i_question_card_repository.dart](lib/data/repositories/interfaces/i_question_card_repository.dart)
- [lib/data/database/daos/question_card_dao.dart](lib/data/database/daos/question_card_dao.dart)
- [lib/data/database/database.dart](lib/data/database/database.dart)

Test:
- create/get/update round trip.
- update supports changing `knowledgeCardId`.
- delete removes question images and linked study progress.
- image helper behavior mirrors expectations from knowledge card images.

OK

### LocalStudyProgressRepository

Related files:
- [lib/data/repositories/local/local_study_progress_repository.dart](lib/data/repositories/local/local_study_progress_repository.dart)
- [lib/data/repositories/interfaces/i_study_progress_repository.dart](lib/data/repositories/interfaces/i_study_progress_repository.dart)
- [lib/data/database/daos/study_progress_dao.dart](lib/data/database/daos/study_progress_dao.dart)
- [lib/data/database/database.dart](lib/data/database/database.dart)

Test:
- first `recordReview` creates row with proper counters.
- subsequent `recordReview` increments totals correctly.
- `correct=true` and `correct=false` affect the right counter.
- `lastReviewedAt` gets updated.

## Priority 2: Import/Export correctness

### SubtreeSerializer

Related files:
- [lib/data/export_import/subtree_serializer.dart](lib/data/export_import/subtree_serializer.dart)
- [lib/data/services/image_service.dart](lib/data/services/image_service.dart)
- [lib/data/repositories/interfaces/i_directory_repository.dart](lib/data/repositories/interfaces/i_directory_repository.dart)
- [lib/data/repositories/interfaces/i_knowledge_card_repository.dart](lib/data/repositories/interfaces/i_knowledge_card_repository.dart)
- [lib/data/repositories/interfaces/i_question_card_repository.dart](lib/data/repositories/interfaces/i_question_card_repository.dart)
- [lib/features/export_import/export_screen.dart](lib/features/export_import/export_screen.dart)
- [lib/features/export_import/import_screen.dart](lib/features/export_import/import_screen.dart)

Test export:
- Throws for unknown directory ID.
- Includes expected envelope fields (`version`, `exportedAt`, `directory`).
- Exports nested directory structure recursively.
- Exports knowledge cards, linked question cards, and image payloads.
- Skips image entries when bytes cannot be read.

Test import:
- Rejects unsupported version.
- Reuses existing directory with same name under same parent.
- Skips knowledge card if title already exists in target directory.
- Creates question cards under imported knowledge card.
- Decodes and saves image payloads through `ImageService.saveBytes`.

OK

## Priority 3: Provider-level decision logic

### auth_providers

Related files:
- [lib/shared/providers/auth_providers.dart](lib/shared/providers/auth_providers.dart)
- [lib/router.dart](lib/router.dart)

Test:
- `authStatusProvider` states:
  - loading when auth or guest state is loading,
  - authenticated when user exists,
  - guest when no user and guest mode enabled,
  - unauthenticated otherwise.

OK

### database_provider

Related files:
- [lib/shared/providers/database_provider.dart](lib/shared/providers/database_provider.dart)
- [lib/shared/providers/auth_providers.dart](lib/shared/providers/auth_providers.dart)
- [lib/data/repositories/local/local_directory_repository.dart](lib/data/repositories/local/local_directory_repository.dart)
- [lib/data/repositories/local/local_knowledge_card_repository.dart](lib/data/repositories/local/local_knowledge_card_repository.dart)
- [lib/data/repositories/local/local_question_card_repository.dart](lib/data/repositories/local/local_question_card_repository.dart)
- [lib/data/repositories/local/local_study_progress_repository.dart](lib/data/repositories/local/local_study_progress_repository.dart)
- [lib/data/repositories/firebase/firebase_directory_repository.dart](lib/data/repositories/firebase/firebase_directory_repository.dart)
- [lib/data/repositories/firebase/firebase_knowledge_card_repository.dart](lib/data/repositories/firebase/firebase_knowledge_card_repository.dart)
- [lib/data/repositories/firebase/firebase_question_card_repository.dart](lib/data/repositories/firebase/firebase_question_card_repository.dart)
- [lib/data/repositories/firebase/firebase_study_progress_repository.dart](lib/data/repositories/firebase/firebase_study_progress_repository.dart)
- [lib/data/services/local_image_service.dart](lib/data/services/local_image_service.dart)
- [lib/data/services/firebase_image_service.dart](lib/data/services/firebase_image_service.dart)

Test:
- repository providers return Firebase implementations only when authenticated
  user exists.
- guest/unauthenticated states return local implementations.
- image service switches to Firebase service only when authenticated user exists.

OK

## Priority 4: Feature provider logic

### tree_browser_providers

Related files:
- [lib/features/tree_browser/tree_browser_providers.dart](lib/features/tree_browser/tree_browser_providers.dart)
- [lib/features/tree_browser/tree_browser_screen.dart](lib/features/tree_browser/tree_browser_screen.dart)

Test:
- `breadcrumbProvider` builds ancestor chain in correct root-to-leaf order.
- returns empty list for null directory input.

### study_providers

Related files:
- [lib/features/study/study_providers.dart](lib/features/study/study_providers.dart)
- [lib/features/study/study_session_screen.dart](lib/features/study/study_session_screen.dart)
- [lib/shared/providers/database_provider.dart](lib/shared/providers/database_provider.dart)

Test:
- `studyQueueProvider` requests subtree IDs only when `subtree=true`.
- directory-only mode uses exactly one directory ID.
- resulting queue includes cards from resolved directories.
- queue order is shuffled (assert not guaranteed stable order across runs).

## Unit test strategy

- Prefer in-memory Drift DB via `AppDatabase.forTesting`.
- Use fake repositories/services for serializer and provider tests where direct DB
  behavior is not the focus.
- Avoid hitting network/Firebase in unit tests; treat Firebase behavior as
  integration-test concern.
- For file cleanup behavior, use temporary test directories/files and assert
  deletion side effects.

## Suggested test layout

- `test/data/repositories/local/local_directory_repository_test.dart`
- `test/data/repositories/local/local_knowledge_card_repository_test.dart`
- `test/data/repositories/local/local_question_card_repository_test.dart`
- `test/data/repositories/local/local_study_progress_repository_test.dart`
- `test/data/export_import/subtree_serializer_test.dart`
- `test/shared/providers/auth_providers_test.dart`
- `test/shared/providers/database_provider_test.dart`
- `test/features/tree_browser/tree_browser_providers_test.dart`
- `test/features/study/study_providers_test.dart`

## Out of scope for this unit-test document

- Full widget interaction flows (editor screens, dialogs, navigation taps).
- End-to-end Firebase behavior.
- Platform channel behavior from image picker/compression plugins.
