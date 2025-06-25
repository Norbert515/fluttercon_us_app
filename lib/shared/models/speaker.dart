class Speaker {
  final String id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String bio;
  final String tagLine;
  final String profilePicture;
  final List<SessionReference> sessions;
  final bool isTopSpeaker;
  final List<SpeakerLink> links;
  final List<dynamic> questionAnswers;
  final List<dynamic> categories;

  Speaker({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.bio,
    required this.tagLine,
    required this.profilePicture,
    required this.sessions,
    required this.isTopSpeaker,
    required this.links,
    required this.questionAnswers,
    required this.categories,
  });

  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      fullName: json['fullName'] ?? '',
      bio: json['bio'] ?? '',
      tagLine: json['tagLine'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      sessions:
          (json['sessions'] as List<dynamic>?)?.map((session) => SessionReference.fromJson(session)).toList() ?? [],
      isTopSpeaker: json['isTopSpeaker'] ?? false,
      links: (json['links'] as List<dynamic>?)?.map((link) => SpeakerLink.fromJson(link)).toList() ?? [],
      questionAnswers: json['questionAnswers'] ?? [],
      categories: json['categories'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'bio': bio,
      'tagLine': tagLine,
      'profilePicture': profilePicture,
      'sessions': sessions.map((session) => session.toJson()).toList(),
      'isTopSpeaker': isTopSpeaker,
      'links': links.map((link) => link.toJson()).toList(),
      'questionAnswers': questionAnswers,
      'categories': categories,
    };
  }
}

class SessionReference {
  final int id;
  final String name;

  SessionReference({required this.id, required this.name});

  factory SessionReference.fromJson(Map<String, dynamic> json) {
    return SessionReference(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class SpeakerLink {
  final String title;
  final String url;
  final String linkType;

  SpeakerLink({required this.title, required this.url, required this.linkType});

  factory SpeakerLink.fromJson(Map<String, dynamic> json) {
    return SpeakerLink(title: json['title'] ?? '', url: json['url'] ?? '', linkType: json['linkType'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'url': url, 'linkType': linkType};
  }
}
