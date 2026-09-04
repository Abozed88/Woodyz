import 'package:flutter/material.dart';
import 'package:woodyz/core/widgets/custom_text_field.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  bool _isUpdating = false;

  @override
  void dispose() {
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (_key.currentState!.validate()) {
      if (_passController.text != _confirmPassController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }

      setState(() => _isUpdating = true);
      try {
        final success = await AuthProvider(context: context).updatePassword(_passController.text.trim());
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password updated successfully! Please login.")),
          );
          Navigator.pop(context); // Go back to login
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to update password. Try again.")),
          );
        }
      } finally {
        if (mounted) setState(() => _isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Set New Password", style: TextStyle(fontFamily: "Saira", fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Enter your new password below to regain access to your account.",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontFamily: "Saira",
                ),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                label: "New Password",
                hint: "minimum 6 characters",
                controller: _passController,
                obscure: true,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: "Confirm Password",
                hint: "repeat new password",
                controller: _confirmPassController,
                obscure: true,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _isUpdating ? null : _handleUpdate,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: _isUpdating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text("UPDATE PASSWORD", style: TextStyle(letterSpacing: 1.2)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
