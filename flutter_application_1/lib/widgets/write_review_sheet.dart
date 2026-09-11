import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_strings.dart';
import '../providers/review_provider.dart';
import 'feedback/toast.dart';

/// Opens the shared bottom sheet used to rate a fundi after a completed job.
Future<void> showWriteReviewSheet(
  BuildContext context, {
  required String fundiId,
  required String customerName,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    showDragHandle: true,
    builder: (_) =>
        _WriteReviewSheet(fundiId: fundiId, customerName: customerName),
  );
}

class _WriteReviewSheet extends StatefulWidget {
  const _WriteReviewSheet({required this.fundiId, required this.customerName});

  final String fundiId;
  final String customerName;

  @override
  State<_WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<_WriteReviewSheet> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 5;
  bool _submitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final provider = context.read<ReviewProvider>();
    try {
      await provider.addReview(
        fundiId: widget.fundiId,
        customerName: widget.customerName,
        rating: _rating,
        comment: _commentController.text.trim(),
      );
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text(AppStrings.reviewThanks)),
      );
    } catch (_) {
      if (mounted) Toast.showError(context, AppStrings.reviewSubmitFailed);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimensions.paddingL,
        right: AppDimensions.paddingL,
        top: AppDimensions.paddingL,
        bottom:
            MediaQuery.of(context).viewInsets.bottom + AppDimensions.paddingL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceL),
          Text(
            AppStrings.writeReview,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Center(
            child: RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 34,
              unratedColor: AppColors.starEmpty,
              itemBuilder: (_, _) =>
                  const Icon(Icons.star, color: AppColors.starFilled),
              onRatingUpdate: (value) => setState(() => _rating = value),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceL),
          TextField(
            controller: _commentController,
            maxLines: 4,
            minLines: 3,
            decoration: const InputDecoration(
              hintText: AppStrings.reviewText,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.textOnPrimary,
                      ),
                    )
                  : const Text(AppStrings.submitReview),
            ),
          ),
        ],
      ),
    );
  }
}
