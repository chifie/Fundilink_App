/// The signed-in customer's own details.
class CustomerProfile {
  const CustomerProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
  });

  /// What a fresh install starts with, until sign-up exists.
  static const CustomerProfile demo = CustomerProfile(
    name: 'Amina Yusuf',
    email: 'amina.yusuf@example.com',
    phone: '+254 712 345 678',
    location: 'Kilimani, Nairobi',
  );

  final String name;
  final String email;
  final String phone;
  final String location;

  /// Copy with any field replaced; omitted fields keep their value.
  CustomerProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? location,
  }) => CustomerProfile(
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    location: location ?? this.location,
  );

  /// Rebuilds a profile from the JSON written by [toJson].
  factory CustomerProfile.fromJson(Map<String, dynamic> json) =>
      CustomerProfile(
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        location: json['location'] as String,
      );

  /// Plain JSON map, safe for `jsonEncode` and local persistence.
  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'location': location,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerProfile &&
          other.name == name &&
          other.email == email &&
          other.phone == phone &&
          other.location == location;

  @override
  int get hashCode => Object.hash(name, email, phone, location);
}
