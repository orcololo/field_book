List<String> parseCoCollectorsInput(String input) {
  return input
      .split(RegExp(r'[,;\n]'))
      .map((name) => name.trim())
      .where((name) => name.isNotEmpty)
      .toList();
}

String formatCoCollectors(List<String> coCollectors) {
  return coCollectors
      .map((name) => name.trim())
      .where((name) => name.isNotEmpty)
      .join(', ');
}
