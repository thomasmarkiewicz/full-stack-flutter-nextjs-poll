import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/poll.dart';
import '../../domain/repositories/poll_repository.dart';
import '../models/poll_model.dart';

/// Concrete HTTP implementation of [PollRepository].
/// Lives in the data layer — the domain layer never sees this class directly.
class PollRepositoryImpl implements PollRepository {
  final String baseUrl;
  final http.Client _client;

  PollRepositoryImpl({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  @override
  Future<List<Poll>> getPolls() async {
    final response = await _client.get(Uri.parse('$baseUrl/polls'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load polls: ${response.statusCode}');
    }
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((p) => PollModel.fromJson(p as Map<String, dynamic>).toEntity())
        .toList();
  }

  @override
  Future<void> vote({required String pollId, required String optionId}) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/polls/$pollId/vote'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'optionId': optionId}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Vote failed: ${response.statusCode}');
    }
  }
}
