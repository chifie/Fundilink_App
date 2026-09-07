import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/models/request_status_extension.dart';
import 'package:fundi_link/models/service_request.dart';

void main() {
  const fundiName = 'James Otieno';

  group('RequestStatusHelpers.canCancel / canAccept / canReject', () {
    test('only pending requests can be cancelled, accepted or rejected', () {
      for (final status in RequestStatus.values) {
        final expected = status == RequestStatus.pending;
        expect(status.canCancel, expected, reason: '$status canCancel');
        expect(status.canAccept, expected, reason: '$status canAccept');
        expect(status.canReject, expected, reason: '$status canReject');
      }
    });
  });

  group('RequestStatusHelpers.canStartWork / canMarkComplete', () {
    test('work starts from accepted and completes from inProgress', () {
      expect(RequestStatus.accepted.canStartWork, isTrue);
      expect(RequestStatus.pending.canStartWork, isFalse);
      expect(RequestStatus.inProgress.canMarkComplete, isTrue);
      expect(RequestStatus.accepted.canMarkComplete, isFalse);
    });
  });

  group('RequestStatusHelpers.isActive / isPaidOut', () {
    test('isActive matches accepted and inProgress only', () {
      expect(RequestStatus.accepted.isActive, isTrue);
      expect(RequestStatus.inProgress.isActive, isTrue);
      expect(RequestStatus.pending.isActive, isFalse);
      expect(RequestStatus.completed.isActive, isFalse);
      expect(RequestStatus.reviewed.isActive, isFalse);
      expect(RequestStatus.rejected.isActive, isFalse);
    });

    test('isPaidOut matches completed and reviewed only', () {
      expect(RequestStatus.completed.isPaidOut, isTrue);
      expect(RequestStatus.reviewed.isPaidOut, isTrue);
      expect(RequestStatus.pending.isPaidOut, isFalse);
      expect(RequestStatus.accepted.isPaidOut, isFalse);
      expect(RequestStatus.inProgress.isPaidOut, isFalse);
      expect(RequestStatus.rejected.isPaidOut, isFalse);
    });
  });

  group('RequestStatusHelpers.isTerminal', () {
    test('completed, reviewed and rejected are terminal', () {
      for (final status in RequestStatus.values) {
        final expected =
            status == RequestStatus.completed ||
            status == RequestStatus.reviewed ||
            status == RequestStatus.rejected;
        expect(status.isTerminal, expected, reason: '$status isTerminal');
      }
    });
  });

  group('RequestStatusHelpers.nextStatus', () {
    test('walks the workflow and stops at terminal states', () {
      expect(RequestStatus.pending.nextStatus, RequestStatus.accepted);
      expect(RequestStatus.accepted.nextStatus, RequestStatus.inProgress);
      expect(RequestStatus.inProgress.nextStatus, RequestStatus.completed);
      expect(RequestStatus.completed.nextStatus, RequestStatus.reviewed);
      expect(RequestStatus.reviewed.nextStatus, isNull);
      expect(RequestStatus.rejected.nextStatus, isNull);
    });
  });

  group('RequestStatusHelpers.progress', () {
    test('is bounded between 0 and 1', () {
      for (final status in RequestStatus.values) {
        expect(status.progress, inInclusiveRange(0.0, 1.0));
      }
    });

    test('increases through the happy path', () {
      expect(
        RequestStatus.pending.progress,
        lessThan(RequestStatus.accepted.progress),
      );
      expect(
        RequestStatus.accepted.progress,
        lessThan(RequestStatus.inProgress.progress),
      );
      expect(
        RequestStatus.inProgress.progress,
        lessThan(RequestStatus.completed.progress),
      );
      expect(
        RequestStatus.completed.progress,
        lessThan(RequestStatus.reviewed.progress),
      );
    });
  });

  group('RequestStatusHelpers.customerHint', () {
    test('pending hint awaits the fundi', () {
      expect(
        RequestStatus.pending.customerHint(fundiName),
        'Waiting for fundi to accept',
      );
    });

    test('accepted and inProgress hints name the fundi', () {
      expect(
        RequestStatus.accepted.customerHint(fundiName),
        '$fundiName accepted your request and will be in touch.',
      );
      expect(
        RequestStatus.inProgress.customerHint(fundiName),
        '$fundiName is working on your request.',
      );
    });

    test('completed hint invites a review', () {
      expect(
        RequestStatus.completed.customerHint(fundiName),
        'This job is complete. Leave a review for $fundiName.',
      );
    });

    test('reviewed and rejected hints do not mention the fundi', () {
      expect(
        RequestStatus.reviewed.customerHint(fundiName),
        'You reviewed this fundi. Thanks for the feedback!',
      );
      expect(
        RequestStatus.rejected.customerHint(fundiName),
        'This request was cancelled.',
      );
    });
  });

  group('RequestStatusHelpers.displayLabel', () {
    test('returns a friendly label for every status', () {
      expect(RequestStatus.pending.displayLabel, 'Awaiting response');
      expect(RequestStatus.rejected.displayLabel, 'Request declined');
      expect(RequestStatus.reviewed.displayLabel, 'Review submitted');
    });
  });
}
