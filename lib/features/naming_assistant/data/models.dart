class BabyName {
  final String id;
  final String name;
  final String nameDevanagari;
  final String? gender;
  final String? origin;
  final String? meaning;
  final String source; // seed|ai|import
  final String? reaction; // like|dislike|null
  final int likesCount;
  final int dislikesCount;

  BabyName({
    required this.id,
    required this.name,
    required this.nameDevanagari,
    this.gender,
    this.origin,
    this.meaning,
    required this.source,
    this.reaction,
    this.likesCount = 0,
    this.dislikesCount = 0,
  });

  factory BabyName.fromJson(Map<String, dynamic> json) {
    return BabyName(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      nameDevanagari: json['name_devanagari'] ?? '',
      gender: json['gender'],
      origin: json['origin'],
      meaning: json['meaning'],
      source: json['source'] ?? 'seed',
      reaction: json['reaction'],
      likesCount: json['likes_count'] ?? 0,
      dislikesCount: json['dislikes_count'] ?? 0,
    );
  }
}

class PaginationInfo {
  final int currentPage;
  final bool hasMore;

  PaginationInfo({
    required this.currentPage,
    required this.hasMore,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['current_page'] ?? 1,
      hasMore: json['has_more'] ?? false,
    );
  }
}

class NamingSuggestionResponse {
  final String startingSound;
  final List<BabyName> names;
  final PaginationInfo pagination;

  NamingSuggestionResponse({
    required this.startingSound,
    required this.names,
    required this.pagination,
  });

  factory NamingSuggestionResponse.fromJson(Map<String, dynamic> json) {
    return NamingSuggestionResponse(
      startingSound: json['starting_sound'] ?? '',
      names: (json['names'] as List?)
              ?.map((e) => BabyName.fromJson(e))
              .toList() ??
          [],
      pagination: PaginationInfo.fromJson(json['pagination'] ?? {}),
    );
  }
}
