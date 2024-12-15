class Language {
  final String name;
  final String languageCode;

  Language(this.name, this.languageCode);

  static List<Language> getLanguages() {
    return [
      Language('English', 'en'),
      Language('Hindi', 'hi'),
      Language('Gujarati', 'gu'),
    ];
  }
}
