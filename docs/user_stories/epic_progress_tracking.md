# Epic: Progress Tracking

Status: agreed

## Epic goal

Enable the user to track pass/fail counts for cards over time so they can see their factual recall state neutrally, without any external gamification, streaks, or artificial motivational systems.

## Persona/product context already agreed

- The user wants to keep their mind sharp using their own resources.
- The product focuses on **internal drive** rather than external rewards.
- **NO gamification:** no daily streaks, no trophies, no levels, and no points.
- **YES database persistence:** review outcomes (pass/fail) are saved to the database to calculate total times correct vs times reviewed per card.
- Offline-first is critical.

## Agreed scope and decisions

### Neutral metrics tracked
- **Times Reviewed:** count of total times the card has been graded in a study session.
- **Times Correct:** count of times the card was graded Correct on the *first try* during a study session.

### Display rules
- Stats are shown neutrally and lightly (e.g., `3/5 correct` or `60%`) in detail lists or cards.
- No high-pressure visual styling.

## User stories

### US-TRACK-01 Persist pass/fail counts
As a solo learner, I want the app to save my correct/incorrect results to the database so that my card-level recall history is preserved.

#### Acceptance criteria
- Given the user grades a card Correct on the first try in a study session, the card's `timesCorrect` and `timesReviewed` are both incremented by 1 in the database.
- Given the user grades a card Incorrect, the card's `timesReviewed` is incremented by 1, but `timesCorrect` is not incremented.
- Given a recycled card is eventually marked Correct later in the same session, the database counts are not updated again (only the first attempt per session counts to ensure accurate long-term recall statistics).
- Given a card is deleted, its pass/fail counts are permanently deleted.

### US-TRACK-02 View neutral pass/fail stats
As a solo learner, I want to see my card-level recall counts neutrally in lists and detail screens so that I can self-identify which topics need more attention.

#### Acceptance criteria
- Given a question card (or concept card) is displayed in a list or detail screen, the UI displays its recall stats neutrally (e.g. `3/5 correct` or `Not reviewed yet`).
- Given the stats are displayed, there are no artificial badges, points, or streak numbers.
