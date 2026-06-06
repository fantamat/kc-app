# Epic: Concept Card Authoring

Status: agreed

## Epic goal

Enable the user to create and edit concept cards that sit between notes and flashcards: rich enough to capture understanding, but structured enough to study quickly on mobile.

## Persona/product context already agreed

- Concept cards are central to the MVP.
- The product should feel like something between note-taking and flashcards.
- Concept cards support direct study.
- In concept-card review:
  - front = title
  - back = description/content
  - correct = user feels confident about the term
  - incorrect = user was unsure about the term
- Concept cards live inside folders.
- Offline-first behavior is critical.

## Agreed scope and decisions

### Required fields
- title: required
- markdown body/description: required
- images: optional

### Validation rules
- title is required
- title is trimmed
- body is required
- body is trimmed
- both must be non-empty after trimming
- title must be unique within the same folder
- title uniqueness is case-insensitive within the same folder

### Image rules
- users can create a concept card without images and add images later
- up to 3 images per concept card
- images can be added from both camera and gallery
- append order is sufficient for MVP
- image reordering is not required
- removing an image requires confirmation

### Authoring scope
- authoring actions in MVP: create, edit, delete only
- duplicate is not required
- leaving create/edit with unsaved changes should trigger a warning before discard

### Navigation / follow-up actions
- after creating a concept card successfully, open the concept-card detail screen
- after editing a concept card successfully, return to the updated concept-card detail screen
- deleting a concept card also deletes its linked question cards
- if a concept card is deleted from its detail screen, navigate to the parent folder screen
- the concept-card detail screen should show linked question cards on the same screen
- the concept-card detail screen should include:
  - a direct action to create a new linked question card
  - a direct Edit action

## User stories

### US-CON-01 Create a concept card in a folder
As a solo learner, I want to create a concept card inside a folder so that I can capture a term and its explanation in a studyable format.

#### Acceptance criteria
- Given the user is inside a folder, they can start creating a concept card for that folder.
- Given the user provides a valid title and valid markdown body, they can save the concept card.
- Given the user saves a new concept card successfully, the app opens the concept card detail screen.
- Given the user creates a concept card without images, save still succeeds.
- Given the user adds up to 3 images before saving, those images are saved with the concept card.
- Given the title is empty after trimming, the card is not created and the user sees a snackbar/toast style error.
- Given the markdown body is empty after trimming, the card is not created and the user sees a snackbar/toast style error.
- Given the title duplicates another concept-card title in the same folder, the card is not created and the user sees a snackbar/toast style error.
- Given the title differs only by letter case from another concept-card title in the same folder, the card is not created and the user sees a snackbar/toast style error.
- Given creation fails for an unexpected reason, the user sees a snackbar/toast style error.
- Given the user attempts to leave with unsaved changes, the app warns before discarding them.

#### Edge cases
- Empty title
- Empty markdown body
- Whitespace-only title/body
- Duplicate title within folder
- Duplicate title differing only by case
- Create with 0 images
- Create with 1–3 images
- Attempt to leave with unsaved content

### US-CON-02 Edit a concept card
As a solo learner, I want to edit a concept card so that I can improve or correct my understanding over time.

#### Acceptance criteria
- Given the user opens an existing concept card for editing, they can modify the title, markdown body, and images.
- Given the user saves valid changes successfully, the app returns to the updated concept-card detail screen.
- Given the edited title is empty after trimming, the changes are not saved and the user sees a snackbar/toast style error.
- Given the edited markdown body is empty after trimming, the changes are not saved and the user sees a snackbar/toast style error.
- Given the edited title duplicates another concept-card title in the same folder, the changes are not saved and the user sees a snackbar/toast style error.
- Given the edited title differs only by letter case from another concept-card title in the same folder, the changes are not saved and the user sees a snackbar/toast style error.
- Given saving fails unexpectedly, the user sees a snackbar/toast style error.
- Given the user attempts to leave with unsaved changes, the app warns before discarding them.

#### Edge cases
- Editing title/body only
- Editing images only
- Editing both content and images
- Rename to duplicate title
- Rename to duplicate title with different case
- Leave edit screen with unsaved changes

### US-CON-03 Delete a concept card
As a solo learner, I want to delete a concept card so that I can remove obsolete or low-value material.

#### Acceptance criteria
- Given the user chooses to delete a concept card, the app asks for explicit confirmation before deletion proceeds.
- Given the confirmation is shown, it explicitly states that the concept card will be deleted.
- Given the concept card has linked question cards, the confirmation explicitly states that those linked question cards will also be deleted.
- Given the user cancels the confirmation, nothing is deleted.
- Given the user confirms deletion, the concept card is deleted.
- Given the user confirms deletion of a concept card with linked question cards, those linked question cards are also deleted.
- Given deletion succeeds, the deleted concept card no longer appears in its folder or detail views.
- Given a concept card is deleted from its detail screen, the app navigates back to the parent folder screen.
- Given deletion fails for any reason, the user sees a snackbar/toast style error.

#### Edge cases
- Delete concept card with no linked question cards
- Delete concept card with one linked question card
- Delete concept card with multiple linked question cards
- Cancel delete
- Delete from detail screen

### US-CON-04 Add images to a concept card
As a solo learner, I want to attach a small number of images to a concept card so that I can reinforce the concept visually.

#### Acceptance criteria
- Given the user is creating or editing a concept card, they can add images from both camera and gallery.
- Given the user adds images successfully, those images are attached to the concept card.
- Given the concept card currently has fewer than 3 images, the user can continue adding images until the limit is reached.
- Given the concept card already has 3 images, the app does not allow additional images to be added.
- Given multiple images are attached, append order is sufficient for MVP and image reordering is not required.

#### Edge cases
- Add first image
- Add second/third image
- Attempt to add a fourth image
- Mix camera and gallery sources

### US-CON-05 Remove images from a concept card
As a solo learner, I want to remove images from a concept card so that I can keep the card clean and relevant.

#### Acceptance criteria
- Given a concept card has one or more images, the user can remove an image while editing the concept card.
- Given the user chooses to remove an image, the app asks for confirmation before the image is removed.
- Given the user cancels the confirmation, the image remains attached.
- Given the user confirms removal, the image is removed from the concept card.

#### Edge cases
- Remove one image from several
- Remove the only image
- Cancel image removal

### US-CON-06 View a concept card in study-ready detail form
As a solo learner, I want to view a concept card in a clean detail view so that I can read it, review it, and continue into related actions.

#### Acceptance criteria
- Given the user opens a concept card detail view, they can see the concept card title.
- Given the user opens a concept card detail view, they can see the markdown body/description rendered for reading.
- Given the concept card has images, those images are visible in the detail view.
- Given the concept card has linked question cards, those linked question cards are shown on the same screen.
- Given the concept card has no linked question cards yet, the detail view communicates that clearly.
- Given the user is on the concept-card detail screen, they can directly start creating a new linked question card.
- Given the user is on the concept-card detail screen, they can directly edit the concept card.

#### Edge cases
- Concept card with no images and no linked question cards
- Concept card with images only
- Concept card with linked question cards only
- Concept card with both images and linked question cards

## Epic completion note

This epic is considered mapped for MVP. The next epic should define question-card authoring, since linked question cards are now an explicit continuation path from concept-card detail.
