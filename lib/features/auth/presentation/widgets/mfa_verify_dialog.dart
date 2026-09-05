import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';

class MFAVerifyDialog extends StatefulWidget {
  const MFAVerifyDialog({super.key});

  @override
  State<MFAVerifyDialog> createState() => _MFAVerifyDialogState();
}

class _MFAVerifyDialogState extends State<MFAVerifyDialog> {
  final TextEditingController _codeController = TextEditingController();
  bool _isVerifying = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      setState(() => _errorMessage = "Enter the 6-digit code");
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      final authProv = AuthProvider(context: context);
      final factors = await authProv.getMFAFactors();
      
      if (factors.isEmpty) {
        if (mounted) Navigator.pop(context, false);
        return;
      }

      await authProv.verifyMFA(factors.first.id, code);
      
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isVerifying = false;
          _errorMessage = "Invalid code. Please try again.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        "Identity Verification",
        style: TextStyle(fontFamily: "Saira", fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Please enter the 6-digit code from your authenticator app to authorize this upload.",
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontFamily: "Saira",
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _codeController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              counterText: "",
              hintText: "000000",
              errorText: _errorMessage,
              filled: true,
              fillColor: theme.colorScheme.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text("CANCEL", style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
        ),
        ElevatedButton(
          onPressed: _isVerifying ? null : _verify,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: _isVerifying
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text("AUTHORIZE", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
