import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:woodyz/core/theme/app_theme.dart';
import 'package:woodyz/core/widgets/custom_text_field.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';
import 'package:woodyz/features/auth/presentation/pages/signup.dart';
import 'package:woodyz/features/auth/presentation/pages/change_password.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passcontroller = TextEditingController();
  final TextEditingController _resetEmailController = TextEditingController();
  bool _isLoading = true;
  bool _isLoggingIn = false;
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChangePassword()),
          );
        }
      }
    });
  }

  Future<void> _checkLoginStatus() async {
    final session = supabase.auth.currentSession;
    if (session != null) {
      try {
        final profileData = await supabase
            .from('profiles')
            .select('*, artisans(*)')
            .eq('id', session.user.id)
            .single();
        
        debugPrint("Session Restore Raw Data: $profileData");

        if (mounted) {
          if (profileData['role'] == 'artisan') {
            final artisan = Artisan.fromJson(profileData);
            debugPrint("Session Restore Artisan Address: ${artisan.address}");
            AuthProvider(context: context).navigateBasedOnRole(artisan);
          } else {
            final profile = User.fromJson(profileData);
            AuthProvider(context: context).navigateBasedOnRole(profile);
          }
        }
      } catch (e) {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    _emailcontroller.dispose();
    _passcontroller.dispose();
    _resetEmailController.dispose();
    super.dispose();
  }

  void _showForgotPasswordDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Reset Password",
          style: TextStyle(fontFamily: "Saira", fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter your email address to receive a password reset link.",
              style: TextStyle(
                fontFamily: "Saira",
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: "Email Address",
              hint: "you@gmail.com",
              controller: _resetEmailController,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "CANCEL",
              style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontFamily: "Saira"),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = _resetEmailController.text.trim();
              if (email.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter your email")),
                );
                return;
              }

              Navigator.pop(context);
              
              final success = await AuthProvider(context: context).resetPassword(email);

              if (context.mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password reset link sent! Check your email.")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to send reset link. Please try again.")),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text("SEND LINK", style: TextStyle(fontFamily: "Saira")),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.darkTheme,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          
          if (_isLoading) {
            return Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              body: Center(child: Lottie.asset('assets/animations/progressloading.json')),
            );
          }

          return Scaffold(
            body: Stack(
              children: [
                // Background Image with Overlay
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/log-sign-bckg.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ),
                
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "WOODYZ",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontFamily: "Western",
                              letterSpacing: 4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "CRAFTED WITH PASSION",
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.primary,
                              fontFamily: "Saira",
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 48),

                          // Login Container with Glassmorphism
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 1.5,
                                  ),
                                ),
                                child: Form(
                                  key: _key,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        "Login to your account",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: theme.colorScheme.onSurface,
                                          fontSize: 18,
                                          fontFamily: "Saira",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 32),
                                      
                                      CustomTextField(
                                        label: "Email Address",
                                        hint: "you@gmail.com",
                                        controller: _emailcontroller,
                                        keyboardType: TextInputType.emailAddress,
                                      ),
                                      const SizedBox(height: 24),
                                      
                                      CustomTextField(
                                        label: "Password",
                                        hint: "password",
                                        controller: _passcontroller,
                                        obscure: true,
                                      ),
                                      
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () => _showForgotPasswordDialog(),
                                          child: Text(
                                            "Forgot Password?",
                                            style: TextStyle(
                                              color: theme.colorScheme.primary.withValues(alpha: 0.8),
                                              fontSize: 12,
                                              fontFamily: "Saira",
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      ElevatedButton(
                                        onPressed: _isLoggingIn ? null : _handleLogin,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: theme.colorScheme.primary,
                                          foregroundColor: theme.colorScheme.onPrimary,
                                        ),
                                        child: _isLoggingIn
                                            ? Lottie.asset('assets/animations/progressloading.json', height: 40)
                                            : const Text(
                                                "LOG IN",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Saira",
                                                  letterSpacing: 1.2,
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Footer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                  fontFamily: "Saira",
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const Signup()),
                                  );
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Saira",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_key.currentState!.validate()) {
      setState(() => _isLoggingIn = true);
      try {
        await AuthProvider(context: context).login(
          email: _emailcontroller.text.trim(),
          password: _passcontroller.text.trim(),
        );
      } finally {
        if (mounted) setState(() => _isLoggingIn = false);
      }
    }
  }
}
