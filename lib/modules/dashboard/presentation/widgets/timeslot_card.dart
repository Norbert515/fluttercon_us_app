import 'package:flutter/material.dart';
import '../../../../shared/shared.dart';
import 'session_card.dart';

class TimeslotCard extends StatelessWidget {
  final Timeslot timeslot;
  final Function(Session) onSessionTap;

  const TimeslotCard({super.key, required this.timeslot, required this.onSessionTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeslot header
            Row(
              children: [
                Icon(Icons.schedule, color: Theme.of(context).colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  _formatTimeRange(timeslot.startTime, timeslot.endTime),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${timeslot.sessions.length} session${timeslot.sessions.length != 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Sessions list
            if (timeslot.sessions.length == 1)
              // Single session - display as a regular card
              SessionCard(session: timeslot.sessions.first, onTap: () => onSessionTap(timeslot.sessions.first))
            else
              // Multiple sessions - display in a grid or list
              _buildMultipleSessionsLayout(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMultipleSessionsLayout(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < timeslot.sessions.length; i++) ...[
          SessionCard(session: timeslot.sessions[i], onTap: () => onSessionTap(timeslot.sessions[i])),
          if (i < timeslot.sessions.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }

  String _formatTimeRange(DateTime start, DateTime end) {
    final startTime = _formatTime(start);
    final endTime = _formatTime(end);
    return '$startTime - $endTime';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }
}
