/// Enumerate several mistake types
enum MistakeType {
  /// Misspelling mistake type
  misspelling('misspelling', 'خطأ إملائي'),

  /// Typographical mistake type
  typographical('typographical', 'خطأ مطبعي'),

  /// Grammar mistake type
  grammar('grammar', 'خطأ نحوي'),

  /// Uncategorized mistake type
  uncategorized('uncategorized', 'خطأ غير مصنف'),

  /// NonConformance mistake type
  nonConformance('nonconformance', 'خطأ عدم المطابقة'),

  /// Style mistake type
  style('style', 'خطأ في التنسيق'),

  /// Any other mistake type
  other('other', 'خطأ من نوع آخر');

  /// The string value associated with the MistakeType variant
  final String value;

  /// The Arabic translation of the MistakeType variant
  final String arabicValue;

  const MistakeType(this.value, this.arabicValue);

  /// Getting the [MistakeType] from String.
  static MistakeType fromString(String value) {
    final lowercasedValue = value.toLowerCase();

    return MistakeType.values.firstWhere(
      (type) => type.value == lowercasedValue,
      orElse: () => MistakeType.other,
    );
  }
}

