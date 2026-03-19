import 'package:equatable/equatable.dart';
import 'option.dart';

/// Pure domain entity — no JSON, no http, no Flutter.
class Poll extends Equatable {
  final String id;
  final String question;
  final List<Option> options;

  const Poll({required this.id, required this.question, required this.options});

  Poll copyWith({List<Option>? options}) =>
      Poll(id: id, question: question, options: options ?? this.options);

  int get totalVotes => options.fold(0, (sum, o) => sum + o.votes);

  @override
  List<Object?> get props => [id, question, options];
}
