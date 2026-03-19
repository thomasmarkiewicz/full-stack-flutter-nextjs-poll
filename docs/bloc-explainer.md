# BLoC Architecture — How Optimistic UI Works in This App

## BLoC in 30 seconds

BLoC is a strict one-way data flow:

```
UI  →  Event  →  BLoC  →  State  →  UI
```

The UI never mutates itself. It fires **events** and reacts to **states**. The BLoC is the only thing that knows how to transition between states.

---

## 1. Events — what the user _does_

`apps/mobile/lib/bloc/poll_event.dart`

```dart
class PollsLoadRequested extends PollEvent {}   // App opened
class VoteSubmitted extends PollEvent {          // User taps an option
  final String pollId;
  final String optionId;
}
```

Think of events as button presses / user intentions. They carry no logic — just data.

---

## 2. States — what the UI _shows_

`apps/mobile/lib/bloc/poll_state.dart`

```dart
class PollInitial  // Before anything happens
class PollLoading  // Fetching polls from API
class PollLoaded {
  final List<Poll> polls;
  final String? pendingOptionId;  // ← THE KEY to optimistic UI
  final String? errorMessage;     // ← set on rollback
}
class PollError    // Hard failure on initial load
```

`PollLoaded` is the "live" state. Notice it holds `pendingOptionId` — while a vote is in-flight, this is set to the tapped option's ID. The UI uses this to immediately show the spinner and highlight the option pressed.

---

## 3. BLoC — the logic engine

`apps/mobile/lib/bloc/poll_bloc.dart`

The BLoC registers handlers in its constructor using the modern `on<Event>` syntax:

```dart
on<PollsLoadRequested>(_onPollsLoadRequested);
on<VoteSubmitted>(_onVoteSubmitted);
```

### Loading polls (simple async):

```dart
emit(PollLoading());                    // 1. show spinner
final polls = await repo.getPolls();    // 2. hit API
emit(PollLoaded(polls: polls));         // 3. show data
```

### Voting — the optimistic pattern:

```dart
// Step 1: Snapshot current state (for rollback)
final originalPolls = currentState.polls;

// Step 2: Update vote count locally RIGHT NOW — no API call yet
final optimisticPolls = _applyOptimisticVote(...);
emit(PollLoaded(polls: optimisticPolls, pendingOptionId: optionId));
// ↑ UI instantly shows +1 vote and a spinner on that option

// Step 3: Hit the API in background (2-second delay on server)
try {
  await repository.vote(pollId: pollId, optionId: optionId);
  emit(state.copyWith(clearPending: true));  // ✅ success: keep count, remove spinner

} catch (e) {
  emit(state.copyWith(
    polls: originalPolls,       // ❌ failure: restore original counts
    clearPending: true,
    errorMessage: 'Vote failed. Please try again.',
  ));
}
```

The critical insight: `emit()` is called **before** `await repository.vote()`. The UI updates happen synchronously. The network call happens asynchronously after.

---

## 4. UI — reacts to state, fires events

`apps/mobile/lib/ui/poll_page.dart` uses `BlocConsumer` which combines two things:

```dart
BlocConsumer<PollBloc, PollState>(
  listener: (context, state) {
    // Side effects (snackbars, navigation) — fires once per state change
    if (state is PollLoaded && state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(...); // rollback toast
    }
  },
  builder: (context, state) {
    // Rebuild the widget tree — called on every state change
    if (state is PollLoading) return CircularProgressIndicator();
    if (state is PollLoaded)  return ListView(...);
  }
)
```

When a user taps an option:

```dart
context.read<PollBloc>().add(
  VoteSubmitted(pollId: pollId, optionId: option.id)
);
```

That's it. The UI just **fires an event**. It doesn't touch any vote counts itself — BLoC emits a new `PollLoaded` state with the updated count, Flutter rebuilds the widget, the bar animates.

---

## The full timeline when you tap an option

| Time    | What happens                                                |
| ------- | ----------------------------------------------------------- |
| 0ms     | `VoteSubmitted` event fired                                 |
| ~1ms    | BLoC emits optimistic state: vote +1, spinner appears       |
| ~1ms    | UI rebuilds — vote bar animates instantly                   |
| ~1ms    | `repository.vote()` HTTP call begins in background          |
| 2000ms  | Server responds (after the artificial delay)                |
| ~2001ms | BLoC emits `clearPending` — spinner disappears, count stays |

That 2-second gap between the instant UI update and the server confirmation is exactly what demonstrates Optimistic UI to the interviewers.
