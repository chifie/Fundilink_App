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
}
