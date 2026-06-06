# Epic: Study / Review Sessions

Status: agreed

## Epic goal

Enable the user to review concept cards and question cards in efficient phone-friendly study sessions that support both broad recall and focused topic practice.

## Persona/product context already agreed

- The user wants to keep their mind sharp through daily phone-based review.
- Studyable content includes both concept cards and question cards.
- Concept-only review is valid.
- In concept-card review:
  - front = title
  - back = description/content
  - correct = confident about the term
  - incorrect = unsure about the term
- When both concept cards and question cards are present in one session:
  - concept cards appear first
  - question cards appear second
  - ordering within each section is alphabetical by card title (A→Z)
- Study scope can come from:
  - global/root Study (entire app)
  - current folder only
  - current folder including subfolders
- The app should avoid asking the user unnecessary scope questions.

## Agreed scope and decisions

### Entry points
- both are first-class session entry points:
  - global Study from root (studies everything in the entire app)
  - folder-based Study (studies single folder or folder subtree depending on content)

### Session progression
- **Reveal interaction:** both tap-to-flip and an explicit Reveal control are available.
- **Grading rules:** Correct/Incorrect can be chosen only after the card has been revealed.
- **Post-reveal actions:** Correct / Incorrect only (no skip/flag in MVP).
- **Correctness model:** same correctness behavior and buttons for both concept and question cards:
  - **Correct** = I knew it / felt confident.
  - **Incorrect** = I didn't know it / was unsure.
- **Incorrect card behavior (Active Recall Loop):**
  - when a card is marked Incorrect, it is placed at the end of the current session queue to be tested again in the same session.
  - cards keep recycling until they are marked Correct.
- **Progress bar behavior:**
  - represents unique cards completed (marked correct) / total unique cards in session.
  - incorrect answers recycle the card but do not move progress backward, and do not advance progress.
- **Database persistence:** to support self-directed feedback, study outcomes (pass/fail first-try correct counts) are persisted to the database. No gamified streaks or rewards are stored or calculated.

### Completion state
- **Completion screen shows:**
  - session stats (total cards reviewed in session, first-try correct percentage).
  - option to return to Safety (Home/Folder).
  - option to **Restart** the same study session.

## User stories

### US-STUDY-01 Start a study session from root or folder scope
As a solo learner, I want to start a study session from the whole app or a specific folder scope so that I can review either broadly or with focus.

#### Acceptance criteria
- Given the user triggers Study from root, a session is initialized containing all studyable cards in the entire app.
- Given the user triggers Study from a folder, a session is initialized containing only cards within that folder (or its subtree, depending on agreed scope rules).
- Given the session starts, the queue is sorted such that:
  - concept cards appear first (sorted alphabetically by title A→Z)
  - question cards appear second (sorted alphabetically by title A→Z)
- Given a session is initialized, the first card in the sorted queue is displayed as "unrevealed" (front face only).

#### Edge cases
- No studyable content (this is blocked at the entry point, see Organization Epic).
- Only concept cards exist in scope.
- Only question cards exist in scope.
- Both concept and question cards exist in scope.

### US-STUDY-02 Flip or reveal the current card
As a solo learner, I want to reveal the answer/content for the current card so that I can test myself before seeing it.

#### Acceptance criteria
- Given a card is unrevealed, only its front face is visible:
  - concept card: title only
  - question card: question title + question markdown body
- Given the card is unrevealed, the Correct and Incorrect actions are hidden or disabled.
- Given the user taps the card body or taps the explicit Reveal control, the card flips/reveals its back face:
  - concept card back: title + markdown content + attached images
  - question card back: question card front (front remains visible) + linked concept title + linked concept markdown content + linked concept images
- Given the card is revealed, the Correct and Incorrect grading controls become visible and active.

#### Edge cases
- Tapping to reveal multiple times (should toggle between front and back once revealed, or remain on back face).
- Concept card with markdown but no images.
- Concept card with markdown and images.

### US-STUDY-03 Mark the card correct or incorrect
As a solo learner, I want to mark whether I knew the card so that the app can record my pass/fail recall state and recycle incorrect cards during this session.

#### Acceptance criteria
- Given the card is revealed, the user can tap "Correct" or "Incorrect".
- Given the user taps "Correct" or "Incorrect", the outcome is recorded instantly in the database to increment the card's pass/fail counts (`timesCorrect` and `timesReviewed`).
- Given the user taps "Correct" for the first time this card appeared in the session:
  - the card is marked as Correct on first-try for the session stats.
  - the card is removed from the active session queue.
  - the database records are updated to increment both `timesCorrect` and `timesReviewed` by 1.
- Given the user taps "Incorrect" on any card appearance:
  - the card is recycled and placed at the end of the session queue.
  - if this is the first time the card was answered in this session, the database records are updated to increment `timesReviewed` by 1 (and `timesCorrect` remains unchanged).
- Given the user is reviewing a recycled card (already marked incorrect once) and marks it "Correct", it is removed from the queue, but does not count as Correct on first-try, and does *not* trigger any additional database updates for counts.
- Given the user exits the session early, progress for cards already graded is preserved in the database; only the active session queue memory is discarded.

#### Edge cases
- Single card remaining in queue marked Incorrect (recycles immediately, appearing again on front face).
- Exiting session early preserves already answered card stats.

### US-STUDY-04 Advance through the session
As a solo learner, I want the session to move me through cards clearly so that I can keep momentum while reviewing.

#### Acceptance criteria
- Given the user grades a card (Correct/Incorrect), the app automatically transitions to the next card in the queue.
- Given a transition occurs, the new card is shown in its unrevealed state (front face only).
- Given transition animation occurs, it should be smooth and phone-friendly.

#### Edge cases
- Rapid tapping on grading buttons (ignore double-taps to prevent accidental skips).

### US-STUDY-05 See session progress
As a solo learner, I want to see my progress through the session so that I know how much remains.

#### Acceptance criteria
- Given a study session is active, the progress bar displays unique cards completed (marked correct) divided by total unique cards in the session.
- Given progress text is shown, it displays `completed unique count / total unique count` (e.g. `4 / 10`).
- Given a card is marked Incorrect, the progress bar and text do not advance.
- Given a recycled card is eventually marked Correct, the progress bar and text advance to reflect that the card is now completed.

#### Edge cases
- First card of session (progress is 0%).
- Only recycled cards left in queue (progress is stationary until they are answered correctly).

### US-STUDY-06 Complete a session and optionally restart
As a solo learner, I want to finish a session and optionally restart it so that I can repeat review when useful.

#### Acceptance criteria
- Given the active session queue becomes empty (all cards marked Correct), the session is complete and the Completion screen is displayed.
- Given the Completion screen is shown, it displays:
  - total reviews performed in this session
  - percentage of cards answered Correct on first-try
- Given the user taps "Return", they are navigated back to their previous context (Home or Folder).
- Given the user taps "Restart", the session queue is re-initialized with the exact same starting set of cards, progress is reset to 0%, and the session begins again.

#### Edge cases
- 100% correct first-try (display perfect score celebration).
- 0% correct first-try (show encouraging message, encourage retry).

## Epic completion note

This epic is considered mapped for MVP. The next epic should define Study Progress tracking over time, which consumes the real-time review results saved during study sessions.
