# 02. Core Epics / Feature Sets

Status: agreed

## MVP must-have epics

### 1. Topic Organization
Organize learning material in a directory/tree structure so the user can separate topics and navigate their knowledge base.

### 2. Concept Card Authoring
Create and edit concept/knowledge cards with a title, markdown body, and small supporting images.

### 3. Quiz Card Authoring
Create and edit question/quiz cards linked to concept cards so terms and concepts can be reinforced through retrieval practice.

### 4. Study / Review Sessions
Run review sessions against a directory or subtree using question cards and reveal linked concept answers.

### 5. Progress Tracking
Track neutral pass/fail counts for cards over time without external gamification or streaks, supporting self-directed feedback.

### 6. Import / Export
Export and import topic subtrees for backup, portability, and future sharing.

## Deferred / secondary epics

### 7. Account / Sync
Support authentication and cloud-backed sync as an additive capability, not a requirement for the MVP core loop.

## Priority rationale

These MVP epics support the full offline-first learning loop:

1. Organize topics
2. Create concept material
3. Create questions linked to concepts
4. Study and review
5. Track progress
6. Back up / move content

Account/sync is valuable but not part of the core standalone value proposition for the launch persona.

## Known codebase alignment

Existing repository history indicates the product already has corresponding technical areas for:
- directory tree browsing,
- knowledge cards,
- question cards,
- study sessions,
- study progress,
- import/export,
- and optional auth/cloud behavior.

This makes the selected MVP epics well aligned with the current product direction.
