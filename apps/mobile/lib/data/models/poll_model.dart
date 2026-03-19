import '../../domain/entities/poll.dart';
import 'option_model.dart';

/// Data Transfer Object — knows about JSON, maps to a domain entity.
class PollModel {
  final String id;
  final String question;
  final List<OptionModel> options;

  const PollModel({
    required this.id,
    required this.question,
    required this.options,
  });

  factory PollModel.fromJson(Map<String, dynamic> json) => PollModel(
    id: json['id'] as String,
    question: json['question'] as String,
    options: (json['options'] as List<dynamic>)
        .map((o) => OptionModel.fromJson(o as Map<String, dynamic>))
        .toList(),
  );

  Poll toEntity() => Poll(
    id: id,
    question: question,
    options: options.map((o) => o.toEntity()).toList(),
  );
}
