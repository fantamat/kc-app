# Epic: Topic Organization

Status: agreed

## Epic goal

Enable the user to organize learning material in a topic hierarchy so they can keep professional knowledge and language-learning content separated, navigable, and studyable.

## Existing codebase signals

From the existing repository history, the app already appears to support:
- directories with `id`, `name`, `parentId`, `createdAt`
- root-level and nested directories
- listing child directories
- breadcrumbs / ancestor navigation
- creating directories
- renaming directories
- deleting an entire subtree
- studying a single directory or a subtree
- drill-down navigation via directory routes

## Agreed scope and decisions

- **Organization model for MVP:** folders/tree only
- **Tags:** not required for MVP
- **Hierarchy depth:** technically unlimited, but UX should encourage practical/simple structures on mobile
- **Primary mobile navigation model:** drill-down screens with back/breadcrumb navigation
- **Empty folders:** allowed
- **Card placement rule:** every card must belong to a folder; root is for navigation and top-level folders, not loose cards
- **Additional folder actions:** move folder is not required for MVP

### Folder naming rules
- name must be non-empty
- leading/trailing whitespace is trimmed
- duplicate names are not allowed within the same parent
- duplicate matching is case-insensitive within the same parent
- the same name may exist in different branches

### Folder list/display rules
- folders are ordered alphabetically by folder name (A→Z)
- empty sections on folder screens are hidden when they have no items
- folder screen section order is:
  1. subfolders
  2. concept cards
  3. question cards

### Root and folder screen behavior
- **Root screen shows:**
  - top-level folders
  - global Study action
  - submenu actions including import/export
  - account status/actions
- **Global Study at root:** studies everything in the app
- **Folder screen shows:**
  - subfolders
  - concept cards
  - question cards
  - a visible Study action

### Navigation rules
- drill-down into folders is the primary navigation model
- both native/app back navigation and breadcrumbs are required
- breadcrumbs start with a Home/root affordance
- long breadcrumb trails remain usable via horizontal scrolling

### Folder deletion rules
- deleting a folder deletes the entire subtree and all contained cards
- explicit confirmation is required before deletion
- delete confirmation must explicitly mention:
  - the selected folder
  - all subfolders
  - all concept cards
  - all question cards
- if the deleted folder is the one currently open, navigate to its parent
- if the deleted folder was top-level, navigating to parent means returning to root

## Study-scope rules owned by this epic

This epic defines how folder structure determines study scope. Detailed study-session mechanics will be refined further in the Study epic.

- **Study entry points required from folders:**
  - study this folder only
  - study this folder including subfolders
- **Study entry UI:** one primary Study action
- the app should not ask the user to choose scope if there is only one meaningful scope
- if only the current folder has studyable content, Study starts the current folder only
- if the current folder has no studyable content but descendants do, Study starts subtree study with no prompt
- if both the current folder and descendants contain studyable content, ask the user to choose between:
  - current folder only
  - include subfolders
- if the folder subtree contains no studyable content at all, do not start a session; show a friendly message

### Studyable content definition
- either concept cards or question cards count as studyable content

### Agreed study behavior relevant to folder scope
- if a folder has concept cards but no question cards, Study still works
  - concept card front = title
  - concept card back = description/content
  - correct = user feels confident about the term
  - incorrect = user was unsure about the term
- if a folder has both concept cards and question cards, both are included in one session
- when both card types are included, concept cards appear before question cards
- within each section, cards are ordered alphabetically by card title (A→Z)

## User stories

### US-ORG-01 Browse folder contents
As a solo learner, I want to browse top-level and nested folders so that I can find the topic area I want to review or edit.

#### Acceptance criteria
- Given the user is at the root, they can see top-level folders.
- Given the user is at the root, they can access a global Study action.
- Given the user is at the root, the global Study action studies everything in the app.
- Given the user is at the root, they can access additional actions through a submenu, including import/export.
- Given the user is at the root, they can see/access account-related actions or status.
- Given the user is inside a folder, they can see that folder's subfolders.
- Given the user is inside a folder, they can see that folder's concept cards.
- Given the user is inside a folder, they can see that folder's question cards.
- Given the user is inside a folder, they can see a visible Study action for that folder.
- Given items are shown in a folder, sections appear in this order: subfolders, concept cards, question cards.
- Given folders are shown in a list, they are ordered alphabetically by folder name (A→Z).
- Given there are no folders at root, the UI shows a clear empty state.
- Given a folder contains no subfolders, concept cards, or question cards, the UI shows a clear empty state for that folder.
- Given a section has no items, that section header is hidden.

#### Edge cases
- Empty root state
- Empty folder state
- Folder with only subfolders
- Folder with only concept cards
- Folder with only question cards
- Folder with mixed content

### US-ORG-02 Navigate through the folder hierarchy
As a solo learner, I want to drill into folders and navigate back using both back navigation and breadcrumbs so that I can move through my knowledge structure easily on mobile.

#### Acceptance criteria
- Given the user taps a folder, they are taken into that folder's screen.
- Given the user is inside a nested folder, they can return using native/app back navigation.
- Given the user is inside a nested folder, they can also use breadcrumbs to jump back to higher levels.
- Given breadcrumbs are shown, they start with a Home/root affordance.
- Given the user is several levels deep, breadcrumb labels reflect the actual folder path.
- Given the breadcrumb trail is too long for the screen width, it remains usable via horizontal scrolling.
- Given the user is at root, breadcrumbs do not imply they are inside another folder.

#### Edge cases
- Deeply nested folder paths
- Long folder names inside breadcrumbs
- Return to root from a deep path

### US-ORG-03 Create a folder
As a solo learner, I want to create a folder at the root or inside another folder so that I can organize my study material by topic.

#### Acceptance criteria
- Given the user is at root, they can create a new top-level folder.
- Given the user is inside a folder, they can create a subfolder inside the current folder.
- Given the user enters a valid new folder name, the folder is created in the current location.
- Given a folder is created, the app stays on the current screen and shows the new folder in the list.
- Given the entered name is empty after trimming, the folder is not created and the user sees inline validation.
- Given the entered name duplicates another folder name under the same parent, the folder is not created and the user sees inline validation.
- Given the entered name differs only by case from another sibling folder, the folder is not created and the user sees inline validation.
- Given folder creation fails for an unexpected reason, the user sees a non-blocking error such as a snackbar/toast.

#### Edge cases
- Empty input
- Whitespace-only input
- Duplicate sibling name
- Duplicate sibling name with different letter case
- Valid same name in a different branch

### US-ORG-04 Rename a folder
As a solo learner, I want to rename a folder so that I can keep my topic structure clear as my understanding evolves.

#### Acceptance criteria
- Given the user chooses to rename a folder, they can edit the existing folder name.
- Given the user enters a valid new name, the folder is renamed in place.
- Given the entered name is empty after trimming, the rename is not applied and the user sees inline validation.
- Given the entered name duplicates another folder name under the same parent, the rename is not applied and the user sees inline validation.
- Given the entered name differs only by case from another sibling folder, the rename is not applied and the user sees inline validation.
- Given the rename fails for an unexpected reason, the user sees a non-blocking error such as a snackbar/toast.
- Given the user keeps the same effective name, the app does not create a duplicate or misleading change.

#### Edge cases
- Rename to blank/whitespace
- Rename to duplicate sibling
- Rename to duplicate sibling with different letter case
- Rename to same effective name

### US-ORG-05 Delete a folder subtree
As a solo learner, I want to delete a folder and everything inside it after confirmation so that I can remove obsolete topic structures cleanly.

#### Acceptance criteria
- Given the user chooses to delete a folder, they are asked for explicit confirmation before deletion proceeds.
- Given the confirmation dialog is shown, it explicitly states that the selected folder, all subfolders, all concept cards, and all question cards inside that subtree will be deleted.
- Given the user cancels the confirmation, nothing is deleted.
- Given the user confirms deletion, the full subtree and all contained cards are deleted.
- Given deletion completes, the folder no longer appears in the list/navigation.
- Given the deleted folder is the folder currently being viewed, the app navigates to that folder's parent.
- Given the deleted folder was a top-level folder, navigating to its parent returns the user to root.
- Given deletion fails for an unexpected reason, the user sees a non-blocking error such as a snackbar/toast.

#### Edge cases
- Deleting an empty folder
- Deleting a folder with deep descendants
- Deleting a folder with both concept and question cards
- Deleting the currently open folder
- Deleting a top-level folder currently open

### US-ORG-06 Start studying from a folder
As a solo learner, I want to start a study session from a folder using the most relevant scope automatically when possible so that I can begin reviewing quickly without unnecessary prompts.

#### Acceptance criteria
- Given the user is inside a folder, they can access a primary Study action.
- Given only one meaningful study scope exists, the app starts studying without asking the user to choose scope.
- Given the current folder has studyable content and descendants do not add additional studyable content, the Study action starts a session for the current folder only.
- Given the current folder has no studyable content but descendants do, the Study action starts a subtree session with no prompt.
- Given both the current folder and descendants contain studyable content, the app asks the user to choose between studying the current folder only or including subfolders.
- Given the current folder contains concept cards but no question cards, Study still works using concept-card review behavior.
- Given the current folder contains both concept cards and question cards, the session includes both card types.
- Given both card types are included, concept cards appear before question cards.
- Given cards are shown within a section, they are ordered alphabetically by card title (A→Z).
- Given the current folder and its descendants contain no studyable content at all, the app does not start a session and shows a friendly message instead.

#### Edge cases
- Folder with concept cards only
- Folder with question cards only
- Folder with both card types
- Folder with no local content but studyable descendants
- Folder with both local and descendant studyable content
- Folder with no studyable content anywhere in its subtree

### US-ORG-07 Start studying a folder including subfolders
As a solo learner, I want to study a folder including its subfolders when appropriate so that I can review a broader topic area in one session.

#### Acceptance criteria
- Given the user chooses to include subfolders, the study scope includes the current folder and all descendant folders.
- Given only descendants contain studyable content, subtree study starts automatically from the primary Study action.
- Given subtree study runs across concept cards and question cards, both card types may be included according to the same session rules.
- Given both card types are included in subtree study, concept cards appear before question cards.
- Given cards are shown within a section, they are ordered alphabetically by card title (A→Z).
- Given the selected folder subtree contains no studyable content, the app does not start a session and shows a friendly message instead.

#### Edge cases
- Very deep subtree
- Mixed concept/question content across multiple levels
- Descendants only, with no studyable cards in the selected folder itself
- Entire selected subtree empty of studyable content

## Epic completion note

This epic is considered mapped for MVP. The next epic should define the actual authoring behavior for concept cards, since concept cards are central both to browsing and to concept-review study sessions.
