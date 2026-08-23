import 'dart:io';
import 'package:flutter/material.dart';
import 'package:woodyz/core/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';

class SignupArt extends StatefulWidget {
  final User user;
  final String email;
  final String password;
  const SignupArt({super.key, required this.user, required this.email, required this.password});

  @override
  State<SignupArt> createState() => _SignupArtState();
}

class _SignupArtState extends State<SignupArt> {
  late Artisan artisan = Artisan.fromProfile(widget.user);
  final GlobalKey<FormState> _key = GlobalKey();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isSigningUp = false;

  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final List<String> _skillsList = [
    "Furniture", "Decor", "Bedroom", "Bowls", "Kitchenware", "Outdoor", "Art", "Toys", "Others",];
  final List<String> _selectedSkills = [];

  @override
  void dispose() {
    _bioController.dispose();
    _addressController.dispose();
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                "Artisan Details",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontFamily: "Saira",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Showcase your woodcraft expertise",
                                textAlign: TextAlign.center,
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
                                      label: "Bio",
                                      hint: "Tell us about yourself and your craft",
                                      controller: _bioController,
                                      maxLines: 3,
                                    ),
                                    const SizedBox(height: 24),

                                    CustomTextField(
                                      label: "Business Address",
                                      hint: "address",
                                      controller: _addressController,
                                    ),
                                    const SizedBox(height: 32),

                                    Text(
                                      "Your Skills",
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                                        fontSize: 14,
                                        fontFamily: "Saira",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: _skillsList.map((skill){
                                        final isSelected = _selectedSkills.contains(skill);
                                        return FilterChip(
                                            label: Text(
                                              skill, 
                                              style: TextStyle(
                                                color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface, 
                                                fontFamily: "Saira",
                                                fontSize: 12,
                                              ),
                                            ),
                                            selected: isSelected,
                                            selectedColor: primaryColor,
                                            backgroundColor: theme.colorScheme.surface,
                                            checkmarkColor: theme.colorScheme.onPrimary,
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              side: BorderSide(
                                                color: isSelected ? primaryColor : theme.colorScheme.onSurface.withOpacity(0.1),
                                              ),
                                            ),
                                            onSelected: (bool selected){
                                              setState(() {
                                                if(selected){
                                                  _selectedSkills.add(skill);
                                                }else{
                                                  _selectedSkills.remove(skill);
                                                }
                                              });
                                            }
                                        );
                                      }).toList(),
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
                                          ? SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.onPrimary),
                                              ),
                                            )
                                          : Text(
                                              "CREATE ARTISAN ACCOUNT",
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
      if (_selectedSkills.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select at least one skill")),
        );
        return;
      }

      setState(() => _isSigningUp = true);
      try {
        final artisanData = {
          'bio': _bioController.text.trim(),
          'address': _addressController.text.trim(),
          'skills': _selectedSkills,
          'rating': 0.0,
        };

        AuthProvider auth = AuthProvider(context: context);
        final cx = await auth.signUp(
          email: widget.email,
          password: widget.password,
          profileData: widget.user,
          avatarFile: _image,
          artisanData: artisanData,
        );
        
        if(cx != null && mounted){
          // Navigation is handled in AuthProvider
        }
      } finally {
        if (mounted) setState(() => _isSigningUp = false);
      }
    }
  }
}
