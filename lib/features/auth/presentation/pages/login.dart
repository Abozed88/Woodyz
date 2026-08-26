import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:woodyz/core/theme/app_theme.dart';
import 'package:woodyz/core/widgets/custom_text_field.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';
import 'package:woodyz/features/auth/presentation/pages/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passcontroller = TextEditingController();
  bool _isLoading = true;
  bool _isLoggingIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
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
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.darkTheme,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          
          if (_isLoading) {
            return Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              body: Center(child: CircularProgressIndicator(color: theme.colorScheme.primary)),
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
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
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
                                          onPressed: () {
                                            // TODO: Forgot Password
                                          },
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
                                            ? SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.onPrimary),
                                                ),
                                              )
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
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
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
