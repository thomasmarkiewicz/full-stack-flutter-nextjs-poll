import 'package:equatable/equatable.dart';
import 'option.dart';

class Poll extends Equatable {
  final String id;
  final String question;
  final List<Option> options;

  const Poll({required this.id, required this.question, required this.options});

  factory Poll.fromJson(Map<String, dynamic> json) => Poll(
    id: json['id'] as String,
    question: json['question'] as String,
    options: (json['options'] as List<dynamic>)
        .map((o) => Option.fromJson(o as Map<String, dynamic>))
        .toList(),
  );

  Poll copyWith({List<Option>? options}) =>
      Poll(id: id, question: question, options: options ?? this.options);

  int get totalVotes => options.fold(0, (sum, o) => sum + o.votes);

  @override
  List<Object?> get props => [id, question, options];
}
