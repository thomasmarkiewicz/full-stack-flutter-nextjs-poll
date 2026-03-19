import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/poll.dart';
import '../domain/repositories/poll_repository.dart';
import 'poll_event.dart';
import 'poll_state.dart';

class PollBloc extends Bloc<PollEvent, PollState> {
  final PollRepository _repository;

  PollBloc({required PollRepository repository})
    : _repository = repository,
      super(const PollInitial()) {
    on<PollsLoadRequested>(_onPollsLoadRequested);
    on<VoteSubmitted>(_onVoteSubmitted);
  }

  Future<void> _onPollsLoadRequested(
    PollsLoadRequested event,
    Emitter<PollState> emit,
  ) async {
    emit(const PollLoading());
    try {
      final polls = await _repository.getPolls();
      emit(PollLoaded(polls: polls));
    } catch (e) {
      emit(PollError(e.toString()));
    }
  }

  Future<void> _onVoteSubmitted(
    VoteSubmitted event,
    Emitter<PollState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PollLoaded) return;

    // ── OPTIMISTIC UPDATE ──────────────────────────────────────────────────
    // Snapshot original polls so we can roll back if the request fails.
    final originalPolls = currentState.polls;

    final optimisticPolls = _applyOptimisticVote(
      polls: originalPolls,
      pollId: event.pollId,
      optionId: event.optionId,
    );

    emit(
      currentState.copyWith(
        polls: optimisticPolls,
        pendingOptionId: event.optionId,
        clearError: true,
      ),
    );

    // ── BACKGROUND API CALL ────────────────────────────────────────────────
    try {
      await _repository.vote(pollId: event.pollId, optionId: event.optionId);

      // Success: optimistic state was correct, just clear the pending indicator.
      if (state is PollLoaded) {
        emit((state as PollLoaded).copyWith(clearPending: true));
      }
    } catch (e) {
      // Failure: roll back to original counts and surface an error message.
      if (state is PollLoaded) {
        emit(
          (state as PollLoaded).copyWith(
            polls: originalPolls,
            clearPending: true,
            errorMessage: 'Vote failed. Please try again.',
          ),
        );
      }
    }
  }

  /// Returns a new polls list with the target option's vote count incremented by 1.
  List<Poll> _applyOptimisticVote({
    required List<Poll> polls,
    required String pollId,
    required String optionId,
  }) {
    return polls.map((poll) {
      if (poll.id != pollId) return poll;
      final updatedOptions = poll.options.map((option) {
        if (option.id != optionId) return option;
        return option.copyWith(votes: option.votes + 1);
      }).toList();
      return poll.copyWith(options: updatedOptions);
    }).toList();
  }
}
