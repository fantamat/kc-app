# Epic: Question Card Authoring

Status: agreed

## Epic goal

Enable the user to create and manage question cards linked to concept cards so they can reinforce understanding through practical questions and active recall.

## Persona/product context already agreed

- Question cards are secondary to concept cards, but central to deeper reinforcement.
- Question cards must link back to concept cards.
- The product should support understanding concepts through practical questions.
- Question cards live inside folders.
- Concept-card detail is a natural launch point for creating linked question cards.
- Offline-first behavior is critical.

## Agreed scope and decisions

### Required fields
- linked concept card: required
- title: required
- markdown question body: required

### Validation rules
- title is required
- title is trimmed
- question body is required
- question body is trimmed
- both must be non-empty after trimming
- title must be unique within the same folder
- title uniqueness is case-insensitive within the same folder

### Media rules
- question cards do not support images in the MVP

### Relationship rules
- a question card must live in the same folder as its linked concept card
- relinking a question card to a different concept card is not required in the MVP

### Authoring scope
- authoring actions in MVP: create, edit, delete only
- question-card creation should normally start from the linked concept-card detail screen
- question cards should have their own dedicated detail screen in the MVP
- leaving question-card create/edit with unsaved changes should trigger a discard warning

### Navigation / follow-up actions
- after creating a question card successfully, return to the linked concept-card detail screen
- after editing a question card successfully, return to the linked concept-card detail screen
- deleting a question card also deletes its study progress
- question-card delete confirmation must explicitly mention the study-progress deletion
- tapping a linked question card from the concept-card detail screen opens a management/detail context, not immediate single-question study
- the question-card detail screen should include direct actions to edit and delete the question card

## User stories

### US-Q-01 Create a question card linked to a concept card
As a solo learner, I want to create a question card linked to a concept card so that I can practice recalling and applying the concept through a concrete prompt.

#### Acceptance criteria
- Given the user is on a concept-card detail screen, they can start creating a new linked question card.
- Given the linked concept card is already known, the new question card is created against that concept card in the same folder.
- Given the user provides a valid title and valid markdown question body, they can save the question card.
- Given the user saves a new question card successfully, the app returns to the linked concept-card detail screen.
- Given the title is empty after trimming, the question card is not created and the user sees a snackbar/toast style error.
- Given the question body is empty after trimming, the question card is not created and the user sees a snackbar/toast style error.
- Given the title duplicates another question-card title in the same folder, the question card is not created and the user sees a snackbar/toast style error.
- Given the title differs only by letter case from another question-card title in the same folder, the question card is not created and the user sees a snackbar/toast style error.
- Given creation fails unexpectedly, the user is informed with a snackbar/toast style error.
- Given the user attempts to leave with unsaved changes, the app warns before discarding them.

#### Edge cases
- Empty title
- Empty question body
- Whitespace-only title/body
- Duplicate title within folder
- Duplicate title differing only by case
- Leave create screen with unsaved changes

### US-Q-02 Edit a question card
As a solo learner, I want to edit a question card so that I can improve the quality of my practice prompts over time.

#### Acceptance criteria
- Given the user opens an existing question card for editing, they can modify the title and markdown question body.
- Given the user saves valid changes successfully, the app returns to the linked concept-card detail screen.
- Given the edited title is empty after trimming, the changes are not saved and the user sees a snackbar/toast style error.
- Given the edited question body is empty after trimming, the changes are not saved and the user sees a snackbar/toast style error.
- Given the edited title duplicates another question-card title in the same folder, the changes are not saved and the user sees a snackbar/toast style error.
- Given the edited title differs only by letter case from another question-card title in the same folder, the changes are not saved and the user sees a snackbar/toast style error.
- Given saving fails unexpectedly, the user sees a snackbar/toast style error.
- Given the user attempts to leave with unsaved changes, the app warns before discarding them.

#### Edge cases
- Edit title only
- Edit body only
- Edit both title and body
- Rename to duplicate title
- Rename to duplicate title with different case
- Leave edit screen with unsaved changes

### US-Q-03 Delete a question card
As a solo learner, I want to delete a question card so that I can remove low-value or obsolete prompts.

#### Acceptance criteria
- Given the user chooses to delete a question card, the app asks for explicit confirmation before deletion proceeds.
- Given the confirmation is shown, it explicitly states that the question card will be deleted.
- Given the confirmation is shown, it explicitly states that the question card's study progress (pass/fail counts) will also be deleted.
- Given the user cancels the confirmation, nothing is deleted.
- Given the user confirms deletion, the question card is deleted.
- Given the user confirms deletion, the question card's study progress is also deleted.
- Given deletion succeeds, the question card no longer appears on the linked concept-card detail screen.
- Given deletion fails for any reason, the user sees a snackbar/toast style error.

#### Edge cases
- Cancel delete
- Delete from detail screen

### US-Q-04 View question cards from the linked concept-card detail screen
As a solo learner, I want to see question cards from the linked concept-card detail screen so that I can manage practice prompts in the context of the concept they reinforce.

#### Acceptance criteria
- Given the user is on a concept-card detail screen, they can see the linked question cards associated with that concept.
- Given linked question cards are shown, each item shows enough information to identify the question card (title).
- Given linked question cards are shown, each item also shows a lightweight progress signal (e.g., `timesCorrect / timesReviewed` correct, or `Not reviewed yet`).
- Given a linked question card has never been reviewed, the UI communicates that clearly.
- Given a linked question card has review history, the UI shows simple progress information neutrally.
- Given the user wants to manage a linked question card, they can access edit and delete actions from this context.
- Given the user taps a linked question card, it opens in a management/detail context rather than immediately starting single-question study.

#### Edge cases
- No linked question cards
- One linked question card
- Multiple linked question cards
- Mixed reviewed and unreviewed question cards

### US-Q-05 View a dedicated question-card detail screen
As a solo learner, I want a dedicated detail screen for a question card so that I can inspect and manage the prompt cleanly.

#### Acceptance criteria
- Given the user opens a question-card detail screen, they can see the question-card title.
- Given the user opens a question-card detail screen, they can see the markdown question body rendered for reading.
- Given the user is on the question-card detail screen, they can directly edit the question card.
- Given the user is on the question-card detail screen, they can directly delete the question card.
- Given the question card is linked to a concept card, the detail screen should preserve that context clearly.

#### Edge cases
- Navigate from concept-detail list into question detail

## Epic completion note

This epic is considered mapped for MVP. The next epic should define Study / Review Sessions, because several study-scope rules are already agreed and both concept and question cards now have clear authoring models.
