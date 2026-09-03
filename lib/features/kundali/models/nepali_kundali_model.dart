class NepaliKundaliModel {
  final NepaliAscendant ascendant;
  final List<NepaliHouse> houses;

  NepaliKundaliModel({
    required this.ascendant,
    required this.houses,
  });

  factory NepaliKundaliModel.fromJson(Map<String, dynamic> json) {
    List<NepaliHouse> parsedHouses = [];
    if (json['houses'] != null) {
      parsedHouses = List<NepaliHouse>.from(
          json['houses'].map((x) => NepaliHouse.fromJson(x)));
    }

    return NepaliKundaliModel(
      ascendant: NepaliAscendant.fromJson(json['ascendant'] ?? {}),
      houses: parsedHouses,
    );
  }
}

class NepaliAscendant {
  final String signEn;
  final String signDevanagari;
  final String degreeDevanagari;

  NepaliAscendant({
    required this.signEn,
    required this.signDevanagari,
    required this.degreeDevanagari,
  });

  factory NepaliAscendant.fromJson(Map<String, dynamic> json) {
    return NepaliAscendant(
      signEn: json['sign_en'] ?? '',
      signDevanagari: json['sign_devanagari'] ?? '',
      degreeDevanagari: json['degree_devanagari'] ?? '',
    );
  }
}

class NepaliHouse {
  final int house;
  final String signEn;
  final String signDevanagari;
  final List<NepaliPlanet> planets;

  NepaliHouse({
    required this.house,
    required this.signEn,
    required this.signDevanagari,
    required this.planets,
  });

  factory NepaliHouse.fromJson(Map<String, dynamic> json) {
    List<NepaliPlanet> parsedPlanets = [];
    if (json['planets'] != null) {
      parsedPlanets = List<NepaliPlanet>.from(
          json['planets'].map((x) => NepaliPlanet.fromJson(x)));
    }

    return NepaliHouse(
      house: json['house'] ?? 0,
      signEn: json['sign_en'] ?? '',
      signDevanagari: json['sign_devanagari'] ?? '',
      planets: parsedPlanets,
    );
  }
}

class NepaliPlanet {
  final String key;
  final String nameDevanagari;
  final String degreeDevanagari;
  final bool retrograde;

  NepaliPlanet({
    required this.key,
    required this.nameDevanagari,
    required this.degreeDevanagari,
    required this.retrograde,
  });

  factory NepaliPlanet.fromJson(Map<String, dynamic> json) {
    return NepaliPlanet(
      key: json['key'] ?? '',
      nameDevanagari: json['name_devanagari'] ?? '',
      degreeDevanagari: json['degree_devanagari'] ?? '',
      retrograde: json['retrograde'] ?? false,
    );
  }
}
