import 'package:flutter/material.dart';

/// A service category a fundi can offer and customers can browse by.
class ServiceCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String description;
  final int jobCount;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
    this.jobCount = 0,
  });
}