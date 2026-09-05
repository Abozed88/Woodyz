import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';
import 'package:woodyz/features/auth/presentation/pages/change_password.dart';
import 'package:woodyz/features/auth/presentation/pages/login.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AccountSecurity extends StatefulWidget {
  const AccountSecurity({super.key});

  @override
  State<AccountSecurity> createState() => _AccountSecurityState();
}

class _AccountSecurityState extends State<AccountSecurity> {
  bool _twoFactorEnabled = false;
  String? _mfaFactorId;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final authProv = AuthProvider(context: context);
    final factors = await authProv.getMFAFactors();
    
    if (mounted) {
      setState(() {
        _twoFactorEnabled = factors.isNotEmpty;
        if (factors.isNotEmpty) {
          _mfaFactorId = factors.first.id;
        }
      });
    }
  }

  Future<void> _toggle2FA(bool enabled) async {
    if (enabled) {
      _showMFADialog();
    } else if (_mfaFactorId != null) {
      await AuthProvider(context: context).unenrollMFA(_mfaFactorId!);
      setState(() {
        _twoFactorEnabled = false;
        _mfaFactorId = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Two-Factor Authentication disabled.")),
      );
    }
  }

  void _showMFADialog() async {
    final authProv = AuthProvider(context: context);
    final res = await authProv.enrollMFA();
    final qrData = res.totp?.uri;
    final factorId = res.id;
    final codeController = TextEditingController();

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Setup 2FA", style: TextStyle(fontFamily: "Saira", fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Scan this QR code with an authenticator app (like Google Authenticator).", style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 180,
                    width: 180,
                    child: QrImageView(data: qrData.toString(), version: QrVersions.auto),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: codeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Enter 6-digit code",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await authProv.verifyMFA(factorId, codeController.text.trim());
                    if (mounted) {
                      setState(() {
                        _twoFactorEnabled = true;
                        _mfaFactorId = factorId;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(content: Text("2FA enabled successfully!")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid code. Please try again.")),
                    );
                  }
                },
                child: const Text("VERIFY"),
              ),
            ],
          );
        }
      ),
    );
  }

  void _showDeleteAccountDialog() {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: const Text(
          "Delete Account", 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
        ),
        content: const Text(
          "This action is permanent and cannot be undone. All your data, saved products, and profile information will be deleted.",
          style: TextStyle(fontFamily: "Saira"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("CANCEL", style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await AuthProvider(context: context).deleteAccount();
              if (mounted) {
                Navigator.pop(context);
                if (success) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Account deleted successfully.")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to delete account. Please try again later.")),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text("DELETE PERMANENTLY"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = supabase.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Account & Security", style: TextStyle(fontFamily: "Saira", fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Personal Info"),
            _buildInfoTile(Icons.email_outlined, "Email", user?.email ?? "N/A"),
            _buildInfoTile(Icons.badge_outlined, "User ID", user?.id ?? "N/A"),
            
            const SizedBox(height: 32),
            _buildSectionTitle("Security"),
            _buildListTile(
              icon: Icons.lock_reset_outlined,
              title: "Change Password",
              subtitle: "Update your account password",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangePassword()),
                );
              },
            ),
            _buildSwitchTile(
              icon: Icons.verified_user_outlined,
              title: "Two-Factor Auth",
              value: _twoFactorEnabled,
              onChanged: _toggle2FA,
            ),

            const SizedBox(height: 32),
            _buildSectionTitle("Advanced"),
            _buildListTile(
              icon: Icons.delete_forever_outlined,
              title: "Delete Account",
              titleColor: Colors.redAccent,
              onTap: _showDeleteAccountDialog,
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                "Last Login: ${user?.lastSignInAt?.substring(0, 16) ?? 'Unknown'}",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 12,
                  fontFamily: "Saira",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 1,
          fontFamily: "Saira",
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildListTile({
    required IconData icon, 
    required String title, 
    String? subtitle, 
    Color? titleColor,
    required VoidCallback onTap
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: titleColor ?? Theme.of(context).colorScheme.onSurface),
      title: Text(
        title, 
        style: TextStyle(
          fontFamily: "Saira", 
          fontWeight: FontWeight.w600,
          color: titleColor
        )
      ),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon, 
    required String title, 
    required bool value, 
    required ValueChanged<bool> onChanged
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: Icon(icon),
      title: Text(title, style: const TextStyle(fontFamily: "Saira", fontWeight: FontWeight.w600)),
      value: value,
      onChanged: onChanged,
      activeTrackColor: Theme.of(context).colorScheme.primary,
    );
  }
}
