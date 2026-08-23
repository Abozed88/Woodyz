import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/presentation/pages/signup_cust.dart';
import 'package:woodyz/features/auth/presentation/pages/artisan/signup_art.dart';
import 'package:woodyz/features/auth/presentation/widgets/signup_widgets.dart';
import 'package:woodyz/core/widgets/custom_text_field.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';
import 'package:woodyz/core/theme/app_theme.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _key = GlobalKey();
  String _chosenType = "cust";

  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passcontroller = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  late User _user;

  @override
  void initState() {
    super.initState();
    _user = User(
      username: "",
      fullName: "",
      role: 'customer',
      location: "Beirut",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.darkTheme,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          final primaryColor = theme.colorScheme.primary;

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
                    color: Colors.black.withValues(alpha: 0.7),
                  ),
                ),
                
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Expanded(
                              child: Text(
                                "Step 1 of 2",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontFamily: "Saira",
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 48), // Spacer for centering
                          ],
                        ),
                      ),
                      
                      // Progress Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 0.5,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                            minHeight: 4,
                          ),
                        ),
                      ),

                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                          child: Column(
                            children: [
                              const Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontFamily: "Saira",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Join the Woodyz community today",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Saira",
                                  color: Colors.white60,
                                ),
                              ),
                              const SizedBox(height: 48),

                              Form(
                                key: _key,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    CustomTextField(
                                      label: "Full Name",
                                      hint: "name",
                                      controller: _namecontroller,
                                    ),
                                    const SizedBox(height: 24),

                                    CustomTextField(
                                      label: "Email Address",
                                      hint: "you@gmail.com",
                                      controller: _emailcontroller,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    const SizedBox(height: 24),

                                    CustomTextField(
                                      label: "Username",
                                      hint: "choose a username",
                                      controller: _usernameController,
                                    ),
                                    const SizedBox(height: 24),

                                    CustomTextField(
                                      label: "Password",
                                      hint: "password",
                                      controller: _passcontroller,
                                      obscure: true,
                                    ),
                                    const SizedBox(height: 32),

                                    Text(
                                      "I am joining as a:",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 14,
                                        fontFamily: "Saira",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _RoleCard(
                                            title: "Customer",
                                            icon: Icons.person_outline,
                                            isSelected: _chosenType == "cust",
                                            onTap: () => setState(() => _chosenType = "cust"),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _RoleCard(
                                            title: "Artisan",
                                            icon: Icons.handyman_outlined,
                                            isSelected: _chosenType == "art",
                                            onTap: () => setState(() => _chosenType = "art"),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 32),

                                    Location(user: _user),
                                    const SizedBox(height: 48),

                                    ElevatedButton(
                                      onPressed: _handleNext,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(vertical: 18),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 4,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "CONTINUE",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Saira",
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(Icons.arrow_forward, size: 18, color: theme.colorScheme.onPrimary),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  void _handleNext() {
    if (_key.currentState!.validate()) {
      _user.username = _usernameController.text.trim();
      _user.fullName = _namecontroller.text.trim();
      _user.role = _chosenType == 'cust' ? 'customer' : 'artisan';

      if (_chosenType == "cust") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignupCust(
              user: _user,
              email: _emailcontroller.text.trim(),
              password: _passcontroller.text.trim(),
            ),
          ),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignupArt(
              user: _user,
              email: _emailcontroller.text.trim(),
              password: _passcontroller.text.trim(),
            ),
          ),
        );
      }
    }
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.15) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryColor : theme.colorScheme.onSurface.withOpacity(0.1),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : theme.colorScheme.onSurface.withOpacity(0.5),
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? primaryColor : theme.colorScheme.onSurface.withOpacity(0.5),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontFamily: "Saira",
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
