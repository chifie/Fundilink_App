import 'service_request.dart';

/// Additional helpers for RequestStatus.
extension RequestStatusHelpers on RequestStatus {
  /// Returns true if the request can be cancelled.
  bool get canCancel => this == RequestStatus.pending;

  /// Returns true if the request can be accepted.
  bool get canAccept => this == RequestStatus.pending;

  /// Returns true if the request can be rejected.
  bool get canReject => this == RequestStatus.pending;

  /// Returns a user-friendly label for the current status.
  String get displayLabel {
    switch (this) {
      case RequestStatus.pending:
        return 'Awaiting response';
      case RequestStatus.accepted:
        return 'Fundi accepted';
      case RequestStatus.inProgress:
        return 'Work in progress';
      case RequestStatus.completed:
        return 'Work completed';
      case RequestStatus.reviewed:
        return 'Review submitted';
      case RequestStatus.rejected:
        return 'Request declined';
    }
  }

  /// Returns true if work can be started.
  bool get canStartWork => this == RequestStatus.accepted;

  /// Returns true if the work can be marked as complete.
  bool get canMarkComplete => this == RequestStatus.inProgress;

  /// Returns true if the request is in a terminal state.
  bool get isTerminal =>
      this == RequestStatus.completed ||
      this == RequestStatus.reviewed ||
      this == RequestStatus.rejected;

  /// Returns the next status in the workflow.
  RequestStatus? get nextStatus {
    switch (this) {
      case RequestStatus.pending:
        return RequestStatus.accepted;
      case RequestStatus.accepted:
        return RequestStatus.inProgress;
      case RequestStatus.inProgress:
        return RequestStatus.completed;
      case RequestStatus.completed:
        return RequestStatus.reviewed;
      case RequestStatus.reviewed:
        return null;
      case RequestStatus.rejected:
        return null;
    }
  }

  /// Customer-facing one-line hint about this status, referencing the fundi
  /// by name where relevant.
  String customerHint(String fundiName) {
    switch (this) {
      case RequestStatus.pending:
        return 'Waiting for fundi to accept';
      case RequestStatus.accepted:
        return '$fundiName accepted your request and will be in touch.';
      case RequestStatus.inProgress:
        return '$fundiName is working on your request.';
      case RequestStatus.completed:
        return 'This job is complete. Leave a review for $fundiName.';
      case RequestStatus.reviewed:
        return 'You reviewed this fundi. Thanks for the feedback!';
      case RequestStatus.rejected:
        return 'This request was cancelled.';
    }
  }

  /// Returns a progress value (0.0 to 1.0) for the request workflow.
  double get progress {
    switch (this) {
      case RequestStatus.pending:
        return 0.2;
      case RequestStatus.accepted:
        return 0.4;
      case RequestStatus.inProgress:
        return 0.6;
      case RequestStatus.completed:
        return 0.8;
      case RequestStatus.reviewed:
        return 1.0;
      case RequestStatus.rejected:
        return 0.0;
    }
  }
}
