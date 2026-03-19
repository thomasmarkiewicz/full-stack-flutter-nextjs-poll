import 'package:equatable/equatable.dart';
import '../domain/entities/poll.dart';

abstract class PollState extends Equatable {
  const PollState();

  @override
  List<Object?> get props => [];
}

/// Before any data has been requested.
class PollInitial extends PollState {
  const PollInitial();
}

/// Fetching polls from the API for the first time.
class PollLoading extends PollState {
  const PollLoading();
}

/// Polls are loaded. This is the primary "live" state.
///
/// [pendingOptionId] — the option currently being voted on optimistically.
/// Non-null while the HTTP request is in-flight; null once confirmed or rolled back.
///
/// [errorMessage] — if a vote failed and was rolled back, this carries the
/// brief message shown to the user before being cleared.
class PollLoaded extends PollState {
  final List<Poll> polls;
  final String? pendingOptionId;
  final String? errorMessage;

  const PollLoaded({
    required this.polls,
    this.pendingOptionId,
    this.errorMessage,
  });

  PollLoaded copyWith({
    List<Poll>? polls,
    String? pendingOptionId,
    bool clearPending = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PollLoaded(
      polls: polls ?? this.polls,
      pendingOptionId: clearPending
          ? null
          : (pendingOptionId ?? this.pendingOptionId),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [polls, pendingOptionId, errorMessage];
}

/// Hard failure loading polls (network down on startup, etc.)
class PollError extends PollState {
  final String message;

  const PollError(this.message);

  @override
  List<Object?> get props => [message];
}
