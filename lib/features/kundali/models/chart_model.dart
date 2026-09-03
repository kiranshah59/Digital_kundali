class ChartModel {
  final int id;
  final int birthProfileId;
  final String ayanamsaSystem;
  final String houseSystem;
  final ChartData chartData;
  final String? engineVersion;
  final DateTime? generatedAt;

  ChartModel({
    required this.id,
    required this.birthProfileId,
    required this.ayanamsaSystem,
    required this.houseSystem,
    required this.chartData,
    this.engineVersion,
    this.generatedAt,
  });

  factory ChartModel.fromJson(Map<String, dynamic> json) {
    return ChartModel(
      id: json['id'],
      birthProfileId: json['birth_profile_id'],
      ayanamsaSystem: json['ayanamsa_system'] ?? '',
      houseSystem: json['house_system'] ?? '',
      chartData: ChartData.fromJson(json['chart_data'] ?? {}),
      engineVersion: json['engine_version'],
      generatedAt: json['generated_at'] != null ? DateTime.tryParse(json['generated_at']) : null,
    );
  }
}

class ChartData {
  final Ascendant ascendant;
  final Map<String, PlanetData> planets;
  final List<HouseData> houses;
  final double? ayanamsaValue;
  final double? julianDayUt;

  ChartData({
    required this.ascendant,
    required this.planets,
    this.houses = const [],
    this.ayanamsaValue,
    this.julianDayUt,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    Map<String, PlanetData> parsedPlanets = {};
    if (json['planets'] != null) {
      json['planets'].forEach((key, value) {
        parsedPlanets[key] = PlanetData.fromJson(value);
      });
    }

    List<HouseData> parsedHouses = [];
    if (json['houses'] != null && json['houses'] is List) {
      parsedHouses = (json['houses'] as List).map((h) => HouseData.fromJson(h)).toList();
    }

    return ChartData(
      ascendant: Ascendant.fromJson(json['ascendant'] ?? {}),
      planets: parsedPlanets,
      houses: parsedHouses,
      ayanamsaValue: json['ayanamsa_value']?.toDouble(),
      julianDayUt: json['julian_day_ut']?.toDouble(),
    );
  }
}

class Ascendant {
  final String sign;
  final double degree;
  final String nakshatra;
  final int pada;

  Ascendant({
    required this.sign,
    required this.degree,
    required this.nakshatra,
    required this.pada,
  });

  factory Ascendant.fromJson(Map<String, dynamic> json) {
    return Ascendant(
      sign: json['sign'] ?? '',
      degree: (json['degree'] ?? 0.0).toDouble(),
      nakshatra: json['nakshatra'] ?? '',
      pada: json['pada'] ?? 0,
    );
  }
}

class PlanetData {
  final String sign;
  final double degree;
  final int house;
  final String nakshatra;
  final int pada;
  final bool retrograde;

  PlanetData({
    required this.sign,
    required this.degree,
    required this.house,
    required this.nakshatra,
    required this.pada,
    required this.retrograde,
  });

  factory PlanetData.fromJson(Map<String, dynamic> json) {
    return PlanetData(
      sign: json['sign'] ?? '',
      degree: (json['degree'] ?? 0.0).toDouble(),
      house: json['house'] ?? 0,
      nakshatra: json['nakshatra'] ?? '',
      pada: json['pada'] ?? 0,
      retrograde: json['retrograde'] ?? false,
    );
  }
}

class HouseData {
  final int house;
  final String sign;

  HouseData({
    required this.house,
    required this.sign,
  });

  factory HouseData.fromJson(Map<String, dynamic> json) {
    return HouseData(
      house: json['house'] ?? 0,
      sign: json['sign'] ?? '',
    );
  }
}
