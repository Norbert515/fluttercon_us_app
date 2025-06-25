import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/models.dart';

class DataService {
  static const String _speakersPath = 'assets/speakers.json';
  static const String _talksPath = 'assets/talks.json';

  // Singleton pattern
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  List<Speaker>? _cachedSpeakers;
  List<TalkSchedule>? _cachedTalkSchedules;

  /// Loads speakers from JSON asset
  Future<List<Speaker>> loadSpeakers({bool forceReload = false}) async {
    if (_cachedSpeakers != null && !forceReload) {
      return _cachedSpeakers!;
    }

    try {
      final String jsonString = await rootBundle.loadString(_speakersPath);
      final List<dynamic> jsonList = json.decode(jsonString);

      _cachedSpeakers = jsonList.map((speakerJson) => Speaker.fromJson(speakerJson)).toList();

      return _cachedSpeakers!;
    } catch (e) {
      throw Exception('Failed to load speakers: $e');
    }
  }

  /// Loads talk schedules from JSON asset
  Future<List<TalkSchedule>> loadTalkSchedules({bool forceReload = false}) async {
    if (_cachedTalkSchedules != null && !forceReload) {
      return _cachedTalkSchedules!;
    }

    try {
      final String jsonString = await rootBundle.loadString(_talksPath);
      final List<dynamic> jsonList = json.decode(jsonString);

      _cachedTalkSchedules = jsonList.map((scheduleJson) => TalkSchedule.fromJson(scheduleJson)).toList();

      return _cachedTalkSchedules!;
    } catch (e) {
      throw Exception('Failed to load talk schedules: $e');
    }
  }

  /// Gets a speaker by ID
  Future<Speaker?> getSpeakerById(String id) async {
    final speakers = await loadSpeakers();
    try {
      return speakers.firstWhere((speaker) => speaker.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Gets all sessions from all schedules
  Future<List<Session>> getAllSessions() async {
    final schedules = await loadTalkSchedules();
    final List<Session> allSessions = [];

    for (final schedule in schedules) {
      for (final room in schedule.rooms) {
        allSessions.addAll(room.sessions);
      }
    }

    return allSessions;
  }

  /// Gets a session by ID
  Future<Session?> getSessionById(String id) async {
    final sessions = await getAllSessions();
    try {
      return sessions.firstWhere((session) => session.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Gets sessions for a specific speaker
  Future<List<Session>> getSessionsForSpeaker(String speakerId) async {
    final sessions = await getAllSessions();
    return sessions.where((session) => session.speakers.any((speaker) => speaker.id == speakerId)).toList();
  }

  /// Gets top speakers
  Future<List<Speaker>> getTopSpeakers() async {
    final speakers = await loadSpeakers();
    return speakers.where((speaker) => speaker.isTopSpeaker).toList();
  }

  /// Clears cached data
  void clearCache() {
    _cachedSpeakers = null;
    _cachedTalkSchedules = null;
  }
}
