# Epic: Import / Export

Status: agreed

## Epic goal

Enable the user to export and import the entire root knowledge base so they can back up their content, move it between devices, and preserve their self-directed study records.

## Persona/product context already agreed

- The user wants to keep their mind sharp using their own resources.
- Single-user at launch, but design for future sharing.
- Folder hierarchy is tree-based.
- Concept cards support title + markdown body + up to 3 optional images.
- Question cards support title + markdown question body (no images).
- Question cards must link to concept cards and exist in the same folder.
- Card-level pass/fail counts are tracked to support neutral, self-directed feedback.
- Offline-first behavior is critical.

## Agreed scope and decisions

### Format and scope rules
- **Import/Export format:** ZIP archive containing a JSON database export (representing all directory, card, and progress metadata) + physical image files.
- **Export scope for MVP:** only allow exporting the entire database from the root directory (full backup) with folder-level export deferred.
- **Import merge behavior:** Destructive Replace. Importing a ZIP archive overwrites all existing local data and physical image assets with the imported set, requiring explicit user confirmation before proceeding.
- **Progress stats preservation:** card-level pass/fail counts are preserved during both export and import.

### System integration
- **Export delivery:** trigger the native system share sheet (or file save) so the user can save the ZIP to local storage, send it via email/message, or back it up to cloud storage.
- **Import selection:** use a system file picker to select a compatible `.zip` backup archive from device storage.

## User stories

### US-IE-01 Export full database to a ZIP archive
As a solo learner, I want to export my entire database to a ZIP archive so that I can back up my content and transfer it to another device.

#### Acceptance criteria
- Given the user initiates export, the app compiles all database tables (directories, concept cards, question cards, progress counts) into a clean JSON metadata file.
- Given there are attached images, the app packages the JSON file and all physical image files into a single `.zip` archive.
- Given the ZIP is created successfully, the app invokes the native system share sheet to let the user save or share the file.
- Given export fails for an unexpected reason, the user sees a snackbar/toast style error.

#### Edge cases
- Exporting an empty database (JSON indicates 0 items, ZIP contains only the JSON).
- Exporting with many images (ZIP compiles successfully without memory issues).
- Export cancelled by user in share sheet.

### US-IE-02 Import full database from a ZIP archive
As a solo learner, I want to import a database from a ZIP archive so that I can restore my backup or load my cards onto a new device.

#### Acceptance criteria
- Given the user initiates import, the app opens the system file picker.
- Given the user selects a compatible `.zip` archive, the app parses the zip and inspects the JSON metadata.
- Given the import contains valid structure, the app prompts the user with a destructive warning stating that this will replace all current folders, cards, images, and progress statistics.
- Given the user cancels the confirmation, no changes are made and the import is aborted.
- Given the user confirms the import:
  - the local database tables are completely cleared.
  - the local image storage directory is cleared.
  - the JSON metadata is written to the database (preserving pass/fail counts).
  - the physical images from the ZIP are extracted to local image storage.
  - the app refreshes the UI to display the newly imported root structure.
- Given the selected file is corrupt or invalid, the app aborts the import and informs the user via a snackbar/toast or alert dialog.

#### Edge cases
- File picker cancelled by user.
- Corrupted ZIP file.
- ZIP with missing JSON metadata.
- Import containing references to missing images.
- Confirm/cancel flow on the destructive warning.

## Epic completion note

This epic is considered mapped for MVP. This completes the discovery and mapping phase for all core MVP epics.
