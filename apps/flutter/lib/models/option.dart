import 'package:equatable/equatable.dart';

class Option extends Equatable {
  final String id;
  final String text;
  final int votes;

  const Option({required this.id, required this.text, required this.votes});

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    id: json['id'] as String,
    text: json['text'] as String,
    votes: json['votes'] as int,
  );

  Option copyWith({int? votes}) =>
      Option(id: id, text: text, votes: votes ?? this.votes);

  @override
  List<Object?> get props => [id, text, votes];
}
