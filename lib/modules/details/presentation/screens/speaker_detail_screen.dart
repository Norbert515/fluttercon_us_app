import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/shared.dart';
import '../../../dashboard/presentation/widgets/session_card.dart';
import 'session_detail_screen.dart';

class SpeakerDetailScreen extends ConsumerWidget {
  final Speaker speaker;

  const SpeakerDetailScreen({super.key, required this.speaker});

  void _navigateToSessionDetail(BuildContext context, Session session) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SessionDetailScreen(session: session)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speakerSessionsAsync = ref.watch(sessionsForSpeakerProvider(speaker.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(speaker.fullName),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Speaker Header
            _buildSpeakerHeader(context),

            // Speaker Bio
            _buildSpeakerBio(context),

            // Speaker Links
            if (speaker.links.isNotEmpty) _buildSpeakerLinks(context),

            // Speaker Sessions
            _buildSpeakerSessions(context, speakerSessionsAsync),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeakerHeader(BuildContext context) {
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
        children: [
          // Profile Picture
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3),
            ),
            child: ClipOval(
              child:
                  speaker.profilePicture.isNotEmpty
                      ? Image.network(
                        speaker.profilePicture,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.person, size: 60, color: Colors.grey);
                        },
                      )
                      : const Icon(Icons.person, size: 60, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),

          // Speaker Name
          Text(
            speaker.fullName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          // Speaker Tag Line
          if (speaker.tagLine.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              speaker.tagLine,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],

          // Top Speaker Badge
          if (speaker.isTopSpeaker) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Top Speaker',
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpeakerBio(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(speaker.bio, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildSpeakerLinks(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Connect', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children:
                speaker.links.map((link) {
                  return _buildLinkChip(context, link);
                }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLinkChip(BuildContext context, SpeakerLink link) {
    IconData icon;
    Color color;

    switch (link.linkType.toLowerCase()) {
      case 'twitter':
      case 'x (twitter)':
        icon = Icons.alternate_email;
        color = Colors.blue;
        break;
      case 'linkedin':
        icon = Icons.work;
        color = Colors.blue[800]!;
        break;
      default:
        icon = Icons.link;
        color = Colors.grey;
    }

    return InkWell(
      onTap: () {
        // TODO: Launch URL
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opening ${link.title}: ${link.url}')));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(link.title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeakerSessions(BuildContext context, AsyncValue<List<Session>> speakerSessionsAsync) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          speakerSessionsAsync.when(
            data:
                (sessions) => Text(
                  'Sessions (${sessions.length})',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
            loading:
                () => Text(
                  'Sessions',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
            error:
                (error, stack) => Text(
                  'Sessions',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
          ),
          const SizedBox(height: 16),

          speakerSessionsAsync.when(
            data:
                (sessions) =>
                    sessions.isEmpty
                        ? const Text('No sessions found for this speaker.')
                        : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: sessions.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final session = sessions[index];
                            return SessionCard(
                              session: session,
                              onTap: () => _navigateToSessionDetail(context, session),
                            );
                          },
                        ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('Error loading sessions: $error'),
          ),
        ],
      ),
    );
  }
}
