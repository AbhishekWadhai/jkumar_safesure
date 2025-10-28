class Filter {
  final String key;
  final String label;
  final String type;
  final String? source;
  final String path;
  final dynamic defaultValue;

  Filter({
    required this.key,
    required this.label,
    required this.type,
    this.source,
    required this.path,
    this.defaultValue,
  });

  factory Filter.fromJson(Map<String, dynamic> j) => Filter(
        key: j['key'] as String,
        label: j['label'] as String,
        type: j['type'] as String,
        source: j['source'] as String?,
        path: j['path'] as String,
        defaultValue: j['default'],
      );

  Map<String, dynamic> toJson() => {
        'key': key,
        'label': label,
        'type': type,
        'source': source,
        'path': path,
        'default': defaultValue,
      };
}

// usage: List<Filter> filters = (jsonDecode(jsonString) as List).map((e) => Filter.fromJson(e)).toList();
