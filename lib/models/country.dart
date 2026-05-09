class Country {
  final String commonName;
  final String officialName;
  final String flagEmoji;
  final String region;
  final List<String> capital;
  final int population;
  final Map<String, String> currencies;
  final Map<String, String> languages;
  final double area;
  final List<String> timezones;
  final String alpha3Code;

  const Country({
    required this.commonName,
    required this.officialName,
    required this.flagEmoji,
    required this.region,
    required this.capital,
    required this.population,
    required this.currencies,
    required this.languages,
    required this.area,
    required this.timezones,
    required this.alpha3Code,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    final rawCurrencies = json['currencies'] as Map<String, dynamic>? ?? {};
    final parsedCurrencies = rawCurrencies.map(
      (code, info) => MapEntry(
        code,
        (info as Map<String, dynamic>)['name'] as String? ?? '',
      ),
    );

    final rawLanguages = json['languages'] as Map<String, dynamic>? ?? {};
    final parsedLanguages = rawLanguages.map(
      (code, name) => MapEntry(code, name as String),
    );

    return Country(
      commonName: (json['name']?['common'] as String?) ?? 'Unknown',
      officialName: (json['name']?['official'] as String?) ?? 'Unknown',
      flagEmoji: (json['flag'] as String?) ?? '',
      region: (json['region'] as String?) ?? 'Unknown',
      capital:
          (json['capital'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      population: (json['population'] as int?) ?? 0,
      currencies: parsedCurrencies,
      languages: parsedLanguages,
      area: (json['area'] as num?)?.toDouble() ?? 0.0,
      timezones:
          (json['timezones'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      alpha3Code: (json['cca3'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': {'common': commonName, 'official': officialName},
    'flag': flagEmoji,
    'region': region,
    'capital': capital,
    'population': population,
    'currencies': currencies,
    'languages': languages,
    'area': area,
    'timezones': timezones,
    'cca3': alpha3Code,
  };

  Country copyWith({
    String? commonName,
    String? officialName,
    String? flagEmoji,
    String? region,
    List<String>? capital,
    int? population,
    Map<String, String>? currencies,
    Map<String, String>? languages,
    double? area,
    List<String>? timezones,
    String? alpha3Code,
  }) {
    return Country(
      commonName: commonName ?? this.commonName,
      officialName: officialName ?? this.officialName,
      flagEmoji: flagEmoji ?? this.flagEmoji,
      region: region ?? this.region,
      capital: capital ?? this.capital,
      population: population ?? this.population,
      currencies: currencies ?? this.currencies,
      languages: languages ?? this.languages,
      area: area ?? this.area,
      timezones: timezones ?? this.timezones,
      alpha3Code: alpha3Code ?? this.alpha3Code,
    );
  }
}
