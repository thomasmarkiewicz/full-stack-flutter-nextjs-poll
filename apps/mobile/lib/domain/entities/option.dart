import 'package:equatable/equatable.dart';

/// Pure domain entity — no JSON, no http, no Flutter.
class Option extends Equatable {
  final String id;
  final String text;
  final int votes;

  const Option({required this.id, required this.text, required this.votes});

  Option copyWith({int? votes}) =>
      Option(id: id, text: text, votes: votes ?? this.votes);

  @override
  List<Object?> get props => [id, text, votes];
}
