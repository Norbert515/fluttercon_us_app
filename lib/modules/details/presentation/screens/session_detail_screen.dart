import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/shared.dart';
import 'speaker_detail_screen.dart';

class SessionDetailScreen extends ConsumerWidget {
  final Session session;

  const SessionDetailScreen({super.key, required this.session});

  void _navigateToSpeakerDetail(BuildContext context, Speaker speaker) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SpeakerDetailScreen(speaker: speaker)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speakerIds = session.speakers.map((s) => s.id).toList();
    final sessionSpeakersAsync = ref.watch(speakersForSessionProvider(speakerIds));

    return Scaffold(
      appBar: AppBar(
        title: Text(session.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          FavoriteButton(
            sessionId: session.id,
            sessionTitle: session.title,
            size: 24,
            favoriteColor: Colors.white,
            unfavoriteColor: Colors.white70,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session Header
            _buildSessionHeader(context),

            // Session Description
            if (session.description != null && session.description!.isNotEmpty) _buildSessionDescription(context),

            // Session Categories/Tags
            if (session.categories.isNotEmpty) _buildSessionCategories(context),

            // Session Speakers
            _buildSessionSpeakers(context, sessionSpeakersAsync),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), Colors.transparent],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Session Title
          Text(session.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Session Time and Room
          _buildInfoRow(context, Icons.access_time, 'Time', _formatTimeRange(session.startsAt, session.endsAt)),
          const SizedBox(height: 8),
          _buildInfoRow(context, Icons.room, 'Room', session.room),

          // Session Status
          if (session.status != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(context, Icons.info, 'Status', session.status!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge,
              children: [
                TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(session.description!, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildSessionCategories(BuildContext context) {
    final categories = session.categories.where((category) => category.categoryItems.isNotEmpty).toList();

    if (categories.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Categories', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                categories.map((category) {
                  return _buildCategorySection(context, category);
                }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, Category category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children:
              category.categoryItems.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildSessionSpeakers(BuildContext context, AsyncValue<List<Speaker>> sessionSpeakersAsync) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Speakers (${session.speakers.length})',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          sessionSpeakersAsync.when(
            data:
                (speakers) =>
                    speakers.isEmpty
                        ? const Text('No speaker information available.')
                        : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: speakers.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final speaker = speakers[index];
                            return _buildSpeakerTile(context, speaker);
                          },
                        ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('Error loading speakers: $error'),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakerTile(BuildContext context, Speaker speaker) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: speaker.profilePicture.isNotEmpty ? NetworkImage(speaker.profilePicture) : null,
          child: speaker.profilePicture.isEmpty ? const Icon(Icons.person) : null,
        ),
        title: Text(speaker.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle:
            speaker.tagLine.isNotEmpty ? Text(speaker.tagLine, maxLines: 2, overflow: TextOverflow.ellipsis) : null,
        trailing:
            speaker.isTopSpeaker
                ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(12)),
                  child: const Text(
                    'Top',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                )
                : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _navigateToSpeakerDetail(context, speaker),
      ),
    );
  }

  String _formatTimeRange(DateTime start, DateTime end) {
    final startTime = _formatTime(start);
    final endTime = _formatTime(end);
    final date = _formatDate(start);
    return '$date, $startTime - $endTime';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }

  String _formatDate(DateTime dateTime) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }
}
