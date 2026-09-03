import 'dart:io';
import 'package:flutter/material.dart';
import 'package:woodyz/core/theme/app_theme.dart';
import 'package:woodyz/core/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/theme/app_colors.dart';

class SignupCust extends StatefulWidget {
  final User user;
  final String email;
  final String password;
  const SignupCust({super.key, required this.user, required this.email, required this.password});

  @override
  State<SignupCust> createState() => _SignupCustState();
}

class _SignupCustState extends State<SignupCust> {
  late Customer customer = Customer.fromProfile(widget.user);
  final GlobalKey<FormState> _key = GlobalKey();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isSigningUp = false;

  final TextEditingController _phonecontroller = TextEditingController();
  final TextEditingController _addresscontroller = TextEditingController();

  @override
  void dispose() {
    _phonecontroller.dispose();
    _addresscontroller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),

                SafeArea(
                  child: Column(
                    children: [
                      // AppBar area
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
                                "Step 2 of 2",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontFamily: "Saira",
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 48), // Spacer
                          ],
                        ),
                      ),
                      
                      // Progress Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: const LinearProgressIndicator(
                            value: 1.0,
                            backgroundColor: Colors.white10,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
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
                                "Profile Details",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontFamily: "Saira",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Complete your customer profile",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Saira",
                                  color: Colors.white60,
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Avatar Picker
                              Center(
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 140,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: primaryColor, width: 2),
                                        color: theme.colorScheme.surface,
                                      ),
                                      child: ClipOval(
                                        child: _image != null
                                            ? Image.file(_image!, fit: BoxFit.cover)
                                            : Icon(Icons.person, size: 80, color: theme.colorScheme.onSurface.withOpacity(0.2)),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: _pickImage,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.camera_alt, color: theme.colorScheme.onPrimary, size: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 48),

                              Form(
                                key: _key,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    CustomTextField(
                                      label: "Phone Number",
                                      hint: "phone",
                                      controller: _phonecontroller,
                                      keyboardType: TextInputType.phone,
                                    ),
                                    const SizedBox(height: 24),

                                    CustomTextField(
                                      label: "Delivery Address",
                                      hint: "village or city",
                                      controller: _addresscontroller,
                                      maxLines: 3,
                                    ),
                                    const SizedBox(height: 48),

                                    ElevatedButton(
                                      onPressed: _isSigningUp ? null : _handleSignup,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        foregroundColor: theme.colorScheme.onPrimary,
                                        padding: const EdgeInsets.symmetric(vertical: 18),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 4,
                                      ),
                                      child: _isSigningUp
                                          ? Lottie.asset('assets/animations/progressloading.json', height: 40)
                                          : Text(
                                              "CREATE ACCOUNT",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Saira",
                                                letterSpacing: 1.2,
                                                color: theme.colorScheme.onPrimary,
                                              ),
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

  Future<void> _handleSignup() async {
    if (_key.currentState!.validate()){
      setState(() => _isSigningUp = true);
      try {
        customer.phone = _phonecontroller.text.trim();
        customer.address = _addresscontroller.text.trim();
        
        AuthProvider auth = AuthProvider(context: context);
        final cx = await auth.signUp(
          email: widget.email,
          password: widget.password,
          profileData: customer,
          avatarFile: _image,
        );
        
        if(cx != null && mounted){
          // Navigation is handled in AuthProvider.navigateBasedOnRole
        }
      } finally {
        if (mounted) setState(() => _isSigningUp = false);
      }
    }
  }
}
