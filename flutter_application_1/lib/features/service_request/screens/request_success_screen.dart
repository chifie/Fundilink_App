import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/navigation/customer_tabs.dart';

/// Confirmation shown after a service request is submitted.
class RequestSuccessScreen extends StatelessWidget {
  const RequestSuccessScreen({super.key, required this.fundiName});

  final String fundiName;

  void _goToTab(BuildContext context, int tab) {
    CustomerTabs.goTo(tab);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingXL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 112,
                  height: 112,
                  decoration: const BoxDecoration(
                    color: AppColors.forestGreen.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 64,
                    color: AppColors.forestGreen,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXL),
                Text(
                  AppStrings.requestSubmitted,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                Text(
                  '${AppStrings.requestConfirmed} ($fundiName).',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXL),
                SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeight,
                  child: ElevatedButton(
                    onPressed: () => _goToTab(context, CustomerTabs.requests),
                    child: const Text(AppStrings.myRequests),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                TextButton(
                  onPressed: () => _goToTab(context, CustomerTabs.home),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
