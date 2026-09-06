import '../constants/app_strings.dart';

/// Centralized input validation helpers used across all forms.
class Validators {
  Validators._();

  static final RegExp _emailRegExp = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  static final RegExp _phoneRegExp = RegExp(r'^\+?[0-9]{9,15}$');

  static String? validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return AppStrings.emailRequired;
    if (!_emailRegExp.hasMatch(trimmed)) return AppStrings.emailInvalid;
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return AppStrings.passwordRequired;
    if (value.length < 6) return AppStrings.passwordMinLength;
    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) return AppStrings.passwordRequired;
    if (value != password) return AppStrings.passwordMismatch;
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.nameRequired;
    return null;
  }

  static String? validatePhone(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return AppStrings.phoneRequired;
    if (!_phoneRegExp.hasMatch(trimmed)) return AppStrings.phoneInvalid;
    return null;
  }

  /// Generic required-field validator (used for selects and textareas).
  static String? required(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }
}
