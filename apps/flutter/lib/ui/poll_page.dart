import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/poll_bloc.dart';
import '../bloc/poll_event.dart';
import '../bloc/poll_state.dart';
import '../domain/entities/poll.dart';
import '../domain/entities/option.dart';

class PollPage extends StatelessWidget {
  const PollPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Live Poll',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<PollBloc, PollState>(
        listener: (context, state) {
          if (state is PollLoaded && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PollLoading || state is PollInitial) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.purpleAccent),
            );
          }

          if (state is PollError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<PollBloc>().add(
                      const PollsLoadRequested(),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is PollLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: state.polls.length,
              separatorBuilder: (_, _) => const SizedBox(height: 24),
              itemBuilder: (context, index) => _PollCard(
                poll: state.polls[index],
                pendingOptionId: state.pendingOptionId,
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _PollCard extends StatelessWidget {
  final Poll poll;
  final String? pendingOptionId;

  const _PollCard({required this.poll, this.pendingOptionId});

  @override
  Widget build(BuildContext context) {
    final total = poll.totalVotes;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purpleAccent.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            poll.question,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$total votes',
            style: const TextStyle(color: Colors.white38, fontSize: 13),
          ),
          const SizedBox(height: 20),
          ...poll.options.map(
            (option) => _OptionTile(
              option: option,
              pollId: poll.id,
              totalVotes: total,
              isPending: pendingOptionId == option.id,
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final Option option;
  final String pollId;
  final int totalVotes;
  final bool isPending;

  const _OptionTile({
    required this.option,
    required this.pollId,
    required this.totalVotes,
    required this.isPending,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = totalVotes == 0 ? 0.0 : option.votes / totalVotes;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: isPending
            ? null // Prevent double-voting while a request is in-flight
            : () => context.read<PollBloc>().add(
                VoteSubmitted(pollId: pollId, optionId: option.id),
              ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: isPending
                ? Colors.purpleAccent.withOpacity(0.15)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPending ? Colors.purpleAccent : Colors.white24,
              width: isPending ? 2 : 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      option.text,
                      style: TextStyle(
                        color: isPending ? Colors.purpleAccent : Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (isPending)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.purpleAccent,
                      ),
                    )
                  else
                    Text(
                      '${option.votes}',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              // Animated vote bar
              LayoutBuilder(
                builder: (context, constraints) => Stack(
                  children: [
                    Container(
                      height: 6,
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      height: 6,
                      width: constraints.maxWidth * percentage,
                      decoration: BoxDecoration(
                        color: isPending
                            ? Colors.purpleAccent
                            : Colors.purpleAccent.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${(percentage * 100).toStringAsFixed(1)}%',
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
