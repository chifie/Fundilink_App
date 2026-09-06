import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';

/// Lifecycle of a service request.
enum RequestStatus {
  pending,
  accepted,
  inProgress,
  completed,
  reviewed,
  rejected,
}

extension RequestStatusX on RequestStatus {
  String get label {
    switch (this) {
      case RequestStatus.pending:
        return AppStrings.pending;
      case RequestStatus.accepted:
        return AppStrings.accepted;
      case RequestStatus.inProgress:
        return AppStrings.inProgress;
      case RequestStatus.completed:
        return AppStrings.completed;
      case RequestStatus.reviewed:
        return AppStrings.reviewed;
      case RequestStatus.rejected:
        return AppStrings.rejected;
    }
  }

  Color get color {
    switch (this) {
      case RequestStatus.pending:
        return AppColors.statusPending;
      case RequestStatus.accepted:
        return AppColors.statusAccepted;
      case RequestStatus.inProgress:
        return AppColors.statusInProgress;
      case RequestStatus.completed:
        return AppColors.statusCompleted;
      case RequestStatus.reviewed:
        return AppColors.statusReviewed;
      case RequestStatus.rejected:
        return AppColors.statusRejected;
    }
  }

  Color get lightColor {
    switch (this) {
      case RequestStatus.pending:
        return AppColors.warningLight;
      case RequestStatus.accepted:
        return AppColors.infoLight;
      case RequestStatus.inProgress:
        return AppColors.primarySurface;
      case RequestStatus.completed:
        return AppColors.successLight;
      case RequestStatus.reviewed:
        return AppColors.successLight;
      case RequestStatus.rejected:
        return AppColors.errorLight;
    }
  }

  IconData get icon {
    switch (this) {
      case RequestStatus.pending:
        return Icons.schedule;
      case RequestStatus.accepted:
        return Icons.check_circle_outline;
      case RequestStatus.inProgress:
        return Icons.build_circle_outlined;
      case RequestStatus.completed:
        return Icons.verified_outlined;
      case RequestStatus.reviewed:
        return Icons.rate_review_outlined;
      case RequestStatus.rejected:
        return Icons.cancel_outlined;
    }
  }
}

RequestStatus requestStatusFromName(String name) {
  for (final status in RequestStatus.values) {
    if (status.name == name) return status;
  }
  return RequestStatus.pending;
}

/// A service request placed by a customer for a specific fundi.
class ServiceRequest {
  final String id;
  final String customerId;
  final String customerName;
  final String? customerAvatar;
  final String fundiId;
  final String fundiName;
  final String? fundiAvatar;
  final String categoryId;
  final String categoryName;
  final String description;
  final RequestStatus status;
  final String preferredDate;
  final String preferredTime;
  final String location;
  final List<String> images;
  final double estimatedCost;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ServiceRequest({
    required this.id,
    required this.customerId,
    required this.customerName,
    this.customerAvatar,
    required this.fundiId,
    required this.fundiName,
    this.fundiAvatar,
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.status,
    required this.preferredDate,
    required this.preferredTime,
    required this.location,
    this.images = const [],
    this.estimatedCost = 0,
    required this.createdAt,
    this.updatedAt,
  });

  ServiceRequest copyWith({
    RequestStatus? status,
    DateTime? updatedAt,
    double? estimatedCost,
  }) {
    return ServiceRequest(
      id: id,
      customerId: customerId,
      customerName: customerName,
      customerAvatar: customerAvatar,
      fundiId: fundiId,
      fundiName: fundiName,
      fundiAvatar: fundiAvatar,
      categoryId: categoryId,
      categoryName: categoryName,
      description: description,
      status: status ?? this.status,
      preferredDate: preferredDate,
      preferredTime: preferredTime,
      location: location,
      images: images,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
