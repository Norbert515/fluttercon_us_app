import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/shared.dart';
import '../widgets/speaker_card.dart';
import '../widgets/timeslot_card.dart';
import '../../../details/presentation/screens/speaker_detail_screen.dart';
import '../../../details/presentation/screens/session_detail_screen.dart';
import 'favorites_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _navigateToSpeakerDetail(BuildContext context, Speaker speaker) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SpeakerDetailScreen(speaker: speaker)));
  }

  void _navigateToSessionDetail(BuildContext context, Session session) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SessionDetailScreen(session: session)));
  }

  void _navigateToFavorites(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardStatsAsync = ref.watch(dashboardStatsProvider);
    final topSpeakersAsync = ref.watch(topSpeakersProvider);
    final timeslotsAsync = ref.watch(sessionsGroupedByTimeslotProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterCon'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          // Favorites button with badge
          Stack(
            children: [
              IconButton(onPressed: () => _navigateToFavorites(context), icon: const Icon(Icons.favorite)),
              ref.watch(favoritesProvider).isNotEmpty
                  ? Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '${ref.watch(favoritesProvider).length}',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                  : const SizedBox.shrink(),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Invalidate all providers to force refresh
          ref.invalidate(speakersProvider);
          ref.invalidate(talkSchedulesProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Section
              _buildStatsSection(context, dashboardStatsAsync),
              const SizedBox(height: 24),

              // Top Speakers Section
              _buildTopSpeakersSection(context, topSpeakersAsync),
              const SizedBox(height: 24),

              // Schedule by Timeslot Section
              _buildScheduleByTimeslotSection(context, timeslotsAsync),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, AsyncValue<DashboardStats> statsAsync) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Conference Overview', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            statsAsync.when(
              data:
                  (stats) => Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Speakers',
                          stats.speakersCount.toString(),
                          Icons.person,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Sessions',
                          stats.sessionsCount.toString(),
                          Icons.calendar_today,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error loading stats: $error'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
          Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildTopSpeakersSection(BuildContext context, AsyncValue<List<Speaker>> topSpeakersAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Top Speakers', style: Theme.of(context).textTheme.headlineSmall),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all speakers
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: topSpeakersAsync.when(
            data:
                (topSpeakers) => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: topSpeakers.take(5).length,
                  itemBuilder: (context, index) {
                    final speaker = topSpeakers[index];
                    return Padding(
                      padding: EdgeInsets.only(right: index < topSpeakers.length - 1 ? 16 : 0),
                      child: SpeakerCard(speaker: speaker, onTap: () => _navigateToSpeakerDetail(context, speaker)),
                    );
                  },
                ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error loading speakers: $error')),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleByTimeslotSection(BuildContext context, AsyncValue<List<Timeslot>> timeslotsAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Conference Schedule', style: Theme.of(context).textTheme.headlineSmall),
            TextButton(
              onPressed: () {
                // TODO: Navigate to full schedule
              },
              child: const Text('View Full Schedule'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        timeslotsAsync.when(
          data: (timeslots) {
            if (timeslots.isEmpty) {
              return const Center(child: Padding(padding: EdgeInsets.all(32), child: Text('No sessions scheduled')));
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: timeslots.length,
              itemBuilder: (context, index) {
                final timeslot = timeslots[index];
                return TimeslotCard(
                  timeslot: timeslot,
                  onSessionTap: (session) => _navigateToSessionDetail(context, session),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error loading schedule: $error')),
        ),
      ],
    );
  }
}
