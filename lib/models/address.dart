/// A place the customer can send a fundi to.
class SavedAddress {
  const SavedAddress({
    required this.id,
    required this.label,
    required this.line,
    this.isDefault = false,
  });

  /// Two places to start from, until the customer adds their own.
  static const List<SavedAddress> demo = [
    SavedAddress(
      id: 'address-home',
      label: 'Home',
      line: 'Riverside Drive, Kilimani, Nairobi',
      isDefault: true,
    ),
    SavedAddress(
      id: 'address-office',
      label: 'Office',
      line: '4th Floor, Westlands Square, Nairobi',
    ),
  ];

  final String id;

  /// Short name for the place, e.g. "Home".
  final String label;
  final String line;

  /// The address bookings default to.
  final bool isDefault;

  /// Copy with any field replaced; omitted fields keep their value.
  SavedAddress copyWith({String? label, String? line, bool? isDefault}) =>
      SavedAddress(
        id: id,
        label: label ?? this.label,
        line: line ?? this.line,
        isDefault: isDefault ?? this.isDefault,
      );

  /// Rebuilds an address from the JSON written by [toJson].
  factory SavedAddress.fromJson(Map<String, dynamic> json) => SavedAddress(
    id: json['id'] as String,
    label: json['label'] as String,
    line: json['line'] as String,
    isDefault: json['isDefault'] as bool,
  );

  /// Plain JSON map, safe for `jsonEncode` and local persistence.
  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'line': line,
    'isDefault': isDefault,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedAddress &&
          other.id == id &&
          other.label == label &&
          other.line == line &&
          other.isDefault == isDefault;

  @override
  int get hashCode => Object.hash(id, label, line, isDefault);
}
