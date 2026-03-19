import '../entities/poll.dart';

/// Abstract contract. The domain layer defines WHAT can be done.
/// The data layer decides HOW it's done.
abstract class PollRepository {
  Future<List<Poll>> getPolls();
  Future<void> vote({required String pollId, required String optionId});
}
