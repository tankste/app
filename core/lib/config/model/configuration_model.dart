enum ConfigItemType { unspecified, url }

class ConfigurationModel {
  final String key;
  final String label;
  final dynamic value;
  final dynamic defaultValue;
  final bool isConfigurable;
  final ConfigItemType type;

  ConfigurationModel({
    required this.key,
    required this.label,
    required this.value,
    required this.defaultValue,
    required this.isConfigurable,
    this.type = ConfigItemType.unspecified,
  });

  factory ConfigurationModel.fromJson(Map<String, dynamic> parsedJson) {
    return ConfigurationModel(
      key: parsedJson['key'],
      label: parsedJson['label'],
      value: parsedJson['default'],
      defaultValue: parsedJson['default'],
      isConfigurable: parsedJson['isConfigurable'] ?? false,
      type: _typeFromJson(parsedJson['type']),
    );
  }

  static ConfigItemType _typeFromJson(String? value) {
    if (value == "url") {
      return ConfigItemType.url;
    }

    return ConfigItemType.unspecified;
  }

  ConfigurationModel copyWith({
    String? key,
    String? label,
    dynamic value,
    dynamic defaultValue,
    bool? isConfigurable,
    ConfigItemType? type,
  }) {
    return ConfigurationModel(
      key: key ?? this.key,
      label: label ?? this.label,
      value: value ?? this.value,
      defaultValue: defaultValue ?? this.defaultValue,
      isConfigurable: isConfigurable ?? this.isConfigurable,
      type: type ?? this.type,
    );
  }

  @override
  String toString() {
    return "ConfigItemModel{key: $key, label: $label, value: $value, defaultValue: $defaultValue, isConfigurable: $isConfigurable, type: $type}";
  }
}
