import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../providers/auth_provider.dart';
import 'register_screen.dart';

/// Sign-in entry point shown to signed-out users.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'brian@example.com');
  final _passwordController = TextEditingController(text: 'fundilink');

  bool _obscurePassword = true;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final success = await context.read<AuthProvider>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!success && mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(context.read<AuthProvider>().error ?? '')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _forgotPassword() async {
    final controller = TextEditingController();
    final messenger = ScaffoldMessenger.of(context);
    final auth = context.read<AuthProvider>();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.forgotPassword),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: AppStrings.email,
            prefixIcon: Icon(Icons.mail_outline),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              await auth.forgotPassword(controller.text.trim());
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'If the account exists, a reset link has been sent.',
                    ),
                  ),
                );
              }
            },
            child: const Text(AppStrings.sendResetLink),
          ),
        ],
      ),
    );
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingXL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.paddingXL),
                Container(
                  width: 84,
                  height: 84,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  ),
                  child: const Icon(
                    Icons.handyman,
                    size: 44,
                    color: AppColors.forestGreen,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceL),
                Text(
                  AppStrings.appName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.forestGreen,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceS),
                Text(
                  AppStrings.appTagline,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXL),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.validateEmail,
                  decoration: const InputDecoration(
                    labelText: AppStrings.email,
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceL),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: Validators.validatePassword,
                  decoration: InputDecoration(
                    labelText: AppStrings.password,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _forgotPassword,
                    child: const Text(AppStrings.forgotPassword),
                  ),
                ),
                if (auth.error != null) ...[
                  Text(
                    auth.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.error),
                  ),
                  const SizedBox(height: AppDimensions.spaceS),
                ],
                SizedBox(
                  height: AppDimensions.buttonHeight,
                  child: ElevatedButton(
                    onPressed: auth.isLoading || _submitting ? null : _submit,
                    child: auth.isLoading || _submitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.textOnPrimary,
                            ),
                          )
                        : const Text(AppStrings.login),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceL),
                OutlinedButton.icon(
                  onPressed: () {
                    _emailController.text = 'brian@example.com';
                    _passwordController.text = 'fundilink';
                  },
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: const Text('Use demo account'),
                ),
                const SizedBox(height: AppDimensions.spaceXXL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStrings.noAccount,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const RegisterScreen(),
                        ),
                      ),
                      child: const Text(AppStrings.register),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceS),
                Text(
                  'Demo fundi login: james@example.com',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
