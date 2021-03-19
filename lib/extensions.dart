String enumToString(dynamic enumValue) {
  assert(enumValue != null, 'The value should never be null.');

  final stringValue = enumValue.toString();
  assert(stringValue.contains(''), 'Only enum values are supported.');

  return stringValue.split('.').last;
}
