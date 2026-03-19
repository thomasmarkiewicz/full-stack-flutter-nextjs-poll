import '../../domain/entities/option.dart';

/// Data Transfer Object — knows about JSON, maps to a domain entity.
class OptionModel {
  final String id;
  final String text;
  final int votes;

  const OptionModel({
    required this.id,
    required this.text,
    required this.votes,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) => OptionModel(
    id: json['id'] as String,
    text: json['text'] as String,
    votes: json['votes'] as int,
  );

  Option toEntity() => Option(id: id, text: text, votes: votes);
}
