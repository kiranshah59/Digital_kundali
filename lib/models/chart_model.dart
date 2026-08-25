class ChartModel {
  final int id;
  final int birthProfileId;
  final String ayanamsaSystem;
  final String houseSystem;
  final ChartData chartData;

  ChartModel({
    required this.id,
    required this.birthProfileId,
    required this.ayanamsaSystem,
    required this.houseSystem,
    required this.chartData,
  });

  factory ChartModel.fromJson(Map<String, dynamic> json) {
    return ChartModel(
      id: json['id'],
      birthProfileId: json['birth_profile_id'],
      ayanamsaSystem: json['ayanamsa_system'] ?? '',
      houseSystem: json['house_system'] ?? '',
      chartData: ChartData.fromJson(json['chart_data'] ?? {}),
    );
  }
}

class ChartData {
  final Ascendant ascendant;
  final Map<String, PlanetData> planets;

  ChartData({
    required this.ascendant,
    required this.planets,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    Map<String, PlanetData> parsedPlanets = {};
    if (json['planets'] != null) {
      json['planets'].forEach((key, value) {
        parsedPlanets[key] = PlanetData.fromJson(value);
      });
    }

    return ChartData(
      ascendant: Ascendant.fromJson(json['ascendant'] ?? {}),
      planets: parsedPlanets,
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
