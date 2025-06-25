class TalkSchedule {
  final DateTime date;
  final bool isDefault;
  final List<Room> rooms;

  TalkSchedule({required this.date, required this.isDefault, required this.rooms});

  factory TalkSchedule.fromJson(Map<String, dynamic> json) {
    return TalkSchedule(
      date: DateTime.parse(json['date']),
      isDefault: json['isDefault'] ?? false,
      rooms: (json['rooms'] as List<dynamic>?)?.map((room) => Room.fromJson(room)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'isDefault': isDefault,
      'rooms': rooms.map((room) => room.toJson()).toList(),
    };
  }
}

class Room {
  final int id;
  final String name;
  final List<Session> sessions;

  Room({required this.id, required this.name, required this.sessions});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      sessions: (json['sessions'] as List<dynamic>?)?.map((session) => Session.fromJson(session)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'sessions': sessions.map((session) => session.toJson()).toList()};
  }
}

class Session {
  final String id;
  final String title;
  final String? description;
  final DateTime startsAt;
  final DateTime endsAt;
  final bool isServiceSession;
  final bool isPlenumSession;
  final List<SessionSpeaker> speakers;
  final List<Category> categories;
  final int roomId;
  final String room;
  final String? liveUrl;
  final String? recordingUrl;
  final String? status;
  final bool isInformed;
  final bool isConfirmed;

  Session({
    required this.id,
    required this.title,
    this.description,
    required this.startsAt,
    required this.endsAt,
    required this.isServiceSession,
    required this.isPlenumSession,
    required this.speakers,
    required this.categories,
    required this.roomId,
    required this.room,
    this.liveUrl,
    this.recordingUrl,
    this.status,
    required this.isInformed,
    required this.isConfirmed,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      startsAt: DateTime.parse(json['startsAt']),
      endsAt: DateTime.parse(json['endsAt']),
      isServiceSession: json['isServiceSession'] ?? false,
      isPlenumSession: json['isPlenumSession'] ?? false,
      speakers: (json['speakers'] as List<dynamic>?)?.map((speaker) => SessionSpeaker.fromJson(speaker)).toList() ?? [],
      categories: (json['categories'] as List<dynamic>?)?.map((category) => Category.fromJson(category)).toList() ?? [],
      roomId: json['roomId'] ?? 0,
      room: json['room'] ?? '',
      liveUrl: json['liveUrl'],
      recordingUrl: json['recordingUrl'],
      status: json['status'],
      isInformed: json['isInformed'] ?? false,
      isConfirmed: json['isConfirmed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startsAt': startsAt.toIso8601String(),
      'endsAt': endsAt.toIso8601String(),
      'isServiceSession': isServiceSession,
      'isPlenumSession': isPlenumSession,
      'speakers': speakers.map((speaker) => speaker.toJson()).toList(),
      'categories': categories.map((category) => category.toJson()).toList(),
      'roomId': roomId,
      'room': room,
      'liveUrl': liveUrl,
      'recordingUrl': recordingUrl,
      'status': status,
      'isInformed': isInformed,
      'isConfirmed': isConfirmed,
    };
  }
}

class SessionSpeaker {
  final String id;
  final String name;

  SessionSpeaker({required this.id, required this.name});

  factory SessionSpeaker.fromJson(Map<String, dynamic> json) {
    return SessionSpeaker(id: json['id'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class Category {
  final int id;
  final String name;
  final List<CategoryItem> categoryItems;
  final int sort;

  Category({required this.id, required this.name, required this.categoryItems, required this.sort});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      categoryItems:
          (json['categoryItems'] as List<dynamic>?)?.map((item) => CategoryItem.fromJson(item)).toList() ?? [],
      sort: json['sort'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'categoryItems': categoryItems.map((item) => item.toJson()).toList(), 'sort': sort};
  }
}

class CategoryItem {
  final int id;
  final String name;

  CategoryItem({required this.id, required this.name});

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
