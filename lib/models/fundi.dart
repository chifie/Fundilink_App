import 'package:flutter/material.dart';

/// Services a fundi can offer.
enum FundiSkill { cleaning, plumbing, electrical, moving, painting, repairs }

/// Human labels and icons for each service category.
extension FundiSkillInfo on FundiSkill {
  String get label => switch (this) {
    FundiSkill.cleaning => 'Cleaning',
    FundiSkill.plumbing => 'Plumbing',
    FundiSkill.electrical => 'Electrical',
    FundiSkill.moving => 'Moving',
    FundiSkill.painting => 'Painting',
    FundiSkill.repairs => 'Repairs',
  };

  IconData get icon => switch (this) {
    FundiSkill.cleaning => Icons.cleaning_services_outlined,
    FundiSkill.plumbing => Icons.plumbing_outlined,
    FundiSkill.electrical => Icons.electrical_services_outlined,
    FundiSkill.moving => Icons.local_shipping_outlined,
    FundiSkill.painting => Icons.format_paint_outlined,
    FundiSkill.repairs => Icons.handyman_outlined,
  };
}

/// A service professional ("fundi") shown on cards and listings.
class FundiProfile {
  const FundiProfile({
    required this.name,
    required this.skill,
    required this.rating,
    required this.reviewCount,
    required this.jobsDone,
    required this.pricePerHour,
    required this.isOnline,
  });

  final String name;
  final FundiSkill skill;
  final double rating;
  final int reviewCount;
  final int jobsDone;
  final int pricePerHour;
  final bool isOnline;

  /// Copy with any field replaced; omitted fields keep their value.
  FundiProfile copyWith({
    String? name,
    FundiSkill? skill,
    double? rating,
    int? reviewCount,
    int? jobsDone,
    int? pricePerHour,
    bool? isOnline,
  }) => FundiProfile(
    name: name ?? this.name,
    skill: skill ?? this.skill,
    rating: rating ?? this.rating,
    reviewCount: reviewCount ?? this.reviewCount,
    jobsDone: jobsDone ?? this.jobsDone,
    pricePerHour: pricePerHour ?? this.pricePerHour,
    isOnline: isOnline ?? this.isOnline,
  );

  /// Fundis are value objects: two profiles match when every field does.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FundiProfile &&
          other.name == name &&
          other.skill == skill &&
          other.rating == rating &&
          other.reviewCount == reviewCount &&
          other.jobsDone == jobsDone &&
          other.pricePerHour == pricePerHour &&
          other.isOnline == isOnline;

  @override
  int get hashCode => Object.hash(
    name,
    skill,
    rating,
    reviewCount,
    jobsDone,
    pricePerHour,
    isOnline,
  );

  /// Rebuilds a profile from the JSON written by [toJson].
  factory FundiProfile.fromJson(Map<String, dynamic> json) => FundiProfile(
    name: json['name'] as String,
    skill: FundiSkill.values.byName(json['skill'] as String),
    rating: (json['rating'] as num).toDouble(),
    reviewCount: json['reviewCount'] as int,
    jobsDone: json['jobsDone'] as int,
    pricePerHour: json['pricePerHour'] as int,
    isOnline: json['isOnline'] as bool,
  );

  /// Plain JSON map, safe for `jsonEncode` and local persistence.
  Map<String, dynamic> toJson() => {
    'name': name,
    'skill': skill.name,
    'rating': rating,
    'reviewCount': reviewCount,
    'jobsDone': jobsDone,
    'pricePerHour': pricePerHour,
    'isOnline': isOnline,
  };
}
