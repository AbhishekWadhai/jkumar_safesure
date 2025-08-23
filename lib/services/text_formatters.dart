class TextFormatters {
  String toTitleCase(String input) {
    RegExp exp = RegExp(r'(?<=[a-z])[A-Z]');
    return input
        .replaceAllMapped(exp, (Match m) => ' ${m.group(0)}')
        .split(' ')
        .map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  String toCamelCase(String input) {
    List<String> words = input.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';

    String camelCaseString = words.first.toLowerCase();
    for (int i = 1; i < words.length; i++) {
      camelCaseString +=
          words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
    }
    return camelCaseString;
  }
}
