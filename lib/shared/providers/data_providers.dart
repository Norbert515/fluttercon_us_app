import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'favorites_provider.dart';

// Core data providers for loading JSON assets
final speakersProvider = FutureProvider<List<Speaker>>((ref) async {
  try {
    final String jsonString = await rootBundle.loadString('assets/speakers.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList.map((speakerJson) => Speaker.fromJson(speakerJson)).toList();
  } catch (e) {
    throw Exception('Failed to load speakers: $e');
  }
});

final talkSchedulesProvider = FutureProvider<List<TalkSchedule>>((ref) async {
  try {
    final String jsonString = await rootBundle.loadString('assets/talks.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList.map((scheduleJson) => TalkSchedule.fromJson(scheduleJson)).toList();
  } catch (e) {
    throw Exception('Failed to load talk schedules: $e');
  }
});

// Derived providers for computed data
final allSessionsProvider = FutureProvider<List<Session>>((ref) async {
  final schedules = await ref.watch(talkSchedulesProvider.future);
  final List<Session> allSessions = [];

  for (final schedule in schedules) {
    for (final room in schedule.rooms) {
      allSessions.addAll(room.sessions);
    }
  }

  return allSessions;
});

final topSpeakersProvider = FutureProvider<List<Speaker>>((ref) async {
  final speakers = await ref.watch(speakersProvider.future);
  return speakers.where((speaker) => speaker.isTopSpeaker).toList();
});

final nonServiceSessionsProvider = FutureProvider<List<Session>>((ref) async {
  final sessions = await ref.watch(allSessionsProvider.future);
  return sessions.where((s) => !s.isServiceSession).toList();
});

// Provider for getting a specific speaker by ID
final speakerByIdProvider = FutureProvider.family<Speaker?, String>((ref, id) async {
  final speakers = await ref.watch(speakersProvider.future);
  final matchingSpeakers = speakers.where((speaker) => speaker.id == id);
  return matchingSpeakers.isNotEmpty ? matchingSpeakers.first : null;
});

// Provider for getting a specific session by ID
final sessionByIdProvider = FutureProvider.family<Session?, String>((ref, id) async {
  final sessions = await ref.watch(allSessionsProvider.future);
  final matchingSessions = sessions.where((session) => session.id == id);
  return matchingSessions.isNotEmpty ? matchingSessions.first : null;
});

// Provider for getting sessions for a specific speaker
final sessionsForSpeakerProvider = FutureProvider.family<List<Session>, String>((ref, speakerId) async {
  final sessions = await ref.watch(allSessionsProvider.future);
  return sessions.where((session) => session.speakers.any((speaker) => speaker.id == speakerId)).toList();
});

// Provider for getting speakers for a specific session
final speakersForSessionProvider = FutureProvider.family<List<Speaker>, List<String>>((ref, speakerIds) async {
  final speakers = await ref.watch(speakersProvider.future);
  final List<Speaker> sessionSpeakers = [];

  for (final speakerId in speakerIds) {
    final matchingSpeakers = speakers.where((s) => s.id == speakerId);
    if (matchingSpeakers.isNotEmpty) {
      sessionSpeakers.add(matchingSpeakers.first);
    }
  }

  return sessionSpeakers;
});

// Provider for dashboard stats
final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final speakers = await ref.watch(speakersProvider.future);
  final sessions = await ref.watch(nonServiceSessionsProvider.future);

  return DashboardStats(speakersCount: speakers.length, sessionsCount: sessions.length);
});

// Data class for dashboard stats
class DashboardStats {
  final int speakersCount;
  final int sessionsCount;

  DashboardStats({required this.speakersCount, required this.sessionsCount});
}

// Data class for representing a timeslot with its sessions
class Timeslot {
  final DateTime startTime;
  final DateTime endTime;
  final List<Session> sessions;

  Timeslot({required this.startTime, required this.endTime, required this.sessions});
}

// Provider for grouping sessions by timeslot
final sessionsGroupedByTimeslotProvider = FutureProvider<List<Timeslot>>((ref) async {
  final sessions = await ref.watch(nonServiceSessionsProvider.future);
  final favoriteIds = ref.watch(favoritesProvider);

  // Group sessions by their start time
  final Map<DateTime, List<Session>> groupedSessions = {};

  for (final session in sessions) {
    final startTime = DateTime(
      session.startsAt.year,
      session.startsAt.month,
      session.startsAt.day,
      session.startsAt.hour,
      session.startsAt.minute,
    );

    if (!groupedSessions.containsKey(startTime)) {
      groupedSessions[startTime] = [];
    }
    groupedSessions[startTime]!.add(session);
  }

  // Convert to list of Timeslot objects and sort by start time
  final timeslots =
      groupedSessions.entries.map((entry) {
        final sessions = entry.value;
        final startTime = entry.key;
        // Find the end time (latest end time among all sessions in this timeslot)
        final endTime = sessions.map((s) => s.endsAt).reduce((a, b) => a.isAfter(b) ? a : b);

        // Sort sessions within the timeslot: favorites first, then others
        sessions.sort((a, b) {
          final aIsFavorite = favoriteIds.contains(a.id);
          final bIsFavorite = favoriteIds.contains(b.id);

          // If both are favorites or both are not, sort by title
          if (aIsFavorite == bIsFavorite) {
            return a.title.compareTo(b.title);
          }

          // Favorites come first
          return bIsFavorite ? 1 : -1;
        });

        return Timeslot(startTime: startTime, endTime: endTime, sessions: sessions);
      }).toList();

  // Sort timeslots by start time
  timeslots.sort((a, b) => a.startTime.compareTo(b.startTime));

  return timeslots;
});
