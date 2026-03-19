import 'package:equatable/equatable.dart';

abstract class PollEvent extends Equatable {
  const PollEvent();

  @override
  List<Object?> get props => [];
}

/// Fired on startup to fetch all polls from the API.
class PollsLoadRequested extends PollEvent {
  const PollsLoadRequested();
}

/// Fired when the user taps a vote option.
/// Triggers an immediate optimistic UI update, then fires the API in the background.
class VoteSubmitted extends PollEvent {
  final String pollId;
  final String optionId;

  const VoteSubmitted({required this.pollId, required this.optionId});

  @override
  List<Object?> get props => [pollId, optionId];
}
