import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'dart:io';

import 'package:woodyz/features/auth/domain/entities/auth_entities.dart';
export 'package:woodyz/features/auth/domain/entities/auth_entities.dart';
import 'package:woodyz/features/home/presentation/pages/art_home.dart';
import 'package:woodyz/features/home/presentation/pages/cust_home.dart';

final supabase = sb.Supabase.instance.client;

class AuthProvider {
  final BuildContext context;

  AuthProvider({required this.context});

  void navigateBasedOnRole(User profile, {Map<String, dynamic>? extraData}) {
    if (profile.role == 'customer') {
      Customer c;
      if (profile is Customer) {
        c = profile;
      } else {
        c = Customer.fromProfile(profile);
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home(customer: c)));
    } else if (profile.role == 'artisan') {
      Artisan a;
      if (profile is Artisan) {
        a = profile;
      } else if (extraData != null) {
        a = Artisan.fromJson({...profile.toJson(), 'artisans': extraData});
      } else {
        a = Artisan.fromProfile(profile);
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Arthome(artisan: a)));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final profileData = await supabase
            .from('profiles')
            .select('*, artisans(*)')
            .eq('id', response.user!.id)
            .single();
        
        debugPrint("Raw Login Data: $profileData");

        if (profileData['role'] == 'artisan') {
          final artisan = Artisan.fromJson(profileData);
          debugPrint("Mapped Artisan Address: ${artisan.address}");
          if (context.mounted) {
            navigateBasedOnRole(artisan);
          }
        } else {
          final profile = User.fromJson(profileData);
          if (context.mounted) {
            navigateBasedOnRole(profile);
          }
        }
      }
    } catch (e) {
      debugPrint("Login error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: ${e.toString()}")),
        );
      }
    }
  }

  Future<String> uploadAvatar(File image, String userId) async {
    try {
      final fileExt = image.path.split('.').last.toLowerCase();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = fileName;

      final bytes = await image.readAsBytes();

      await supabase.storage.from('avatars').uploadBinary(
            filePath,
            bytes,
            fileOptions: sb.FileOptions(
              cacheControl: '3600',
              upsert: false,
              contentType: _getContentType(fileExt),
            ),
          );

      final String publicUrl =
          supabase.storage.from('avatars').getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      debugPrint("Upload error: $e");
      rethrow;
    }
  }

  String _getContentType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }

  Future<User?> signUp({
    required String email,
    required String password,
    required User profileData,
    File? avatarFile,
    Map<String, dynamic>? artisanData,
  }) async {
    try {
      final authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.user != null) {
        String? avatarUrl;
        if (avatarFile != null) {
          avatarUrl = await uploadAvatar(avatarFile, authResponse.user!.id);
        }

        final newUser = profileData;
        newUser.id = authResponse.user!.id;
        newUser.avatarUrl = avatarUrl;

        // Insert into profiles
        await supabase.from('profiles').insert(newUser.toProfileJson());

        // If artisan, insert into artisans table
        if (newUser.role == 'artisan' && artisanData != null) {
          final fullArtisanData = {
            ...artisanData,
            'id': newUser.id,
          };
          await supabase.from('artisans').insert(fullArtisanData);
          
          if (context.mounted) {
            navigateBasedOnRole(newUser, extraData: fullArtisanData);
          }
        } else {
          if (context.mounted) {
            navigateBasedOnRole(newUser);
          }
        }
        
        return newUser;
      }
      return null;
    } catch (e) {
      debugPrint("Signup error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup failed: ${e.toString()}")),
        );
      }
      return null;
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<bool> updateUserField({
    required String userId,
    required String role,
    required String label,
    required String value,
  }) async {
    try {
      final String field = label.toLowerCase();
      
      // Determine columns and tables based on label
      if (field == 'phone') {
        await supabase.from('profiles').update({'phone': value}).eq('id', userId);
      } else if (field == 'bio') {
        // Update both if artisan
        await supabase.from('profiles').update({'bio': value}).eq('id', userId);
        if (role == 'artisan') {
          await supabase.from('artisans').update({'bio': value}).eq('id', userId);
        }
      } else if (field == 'address') {
        if (role == 'artisan') {
          await supabase.from('artisans').update({'address': value}).eq('id', userId);
        } else {
          await supabase.from('profiles').update({'address': value}).eq('id', userId);
        }
      } else if (field == 'location') {
        await supabase.from('profiles').update({'location': value}).eq('id', userId);
      } else if (field == 'skills' && role == 'artisan') {
        // Assume skills is a comma separated string when editing
        final List<String> skillsList = value.split(',').map((s) => s.trim()).toList();
        await supabase.from('artisans').update({'skills': skillsList}).eq('id', userId);
      } else if (field == 'instagram') {
        await supabase.from('artisans').update({'insta_username': value}).eq('id', userId);
      } else {
        return false;
      }
      return true;
    } catch (e) {
      debugPrint("Update error: $e");
      return false;
    }
  }

  Future<String?> updateAvatar(File image, String userId) async {
    try {
      // 1. Get current avatar URL to delete later
      final profile = await supabase
          .from('profiles')
          .select('avatar_url')
          .eq('id', userId)
          .single();
      
      final String? oldUrl = profile['avatar_url'];

      // 2. Upload new avatar
      final url = await uploadAvatar(image, userId);
      
      if (url.isNotEmpty) {
        // 3. Update profile with new URL
        await supabase.from('profiles').update({'avatar_url': url}).eq('id', userId);
        
        // 4. Delete old avatar from storage if it exists
        if (oldUrl != null && oldUrl.isNotEmpty) {
          try {
            final Uri uri = Uri.parse(oldUrl);
            final List<String> pathSegments = uri.pathSegments;
            // The path in Supabase storage URL is usually: /storage/v1/object/public/bucket/path
            // So if pathSegments contains 'avatars', the next segment is the filename
            final int avatarsIndex = pathSegments.indexOf('avatars');
            if (avatarsIndex != -1 && avatarsIndex < pathSegments.length - 1) {
              final String oldFileName = pathSegments.last;
              await supabase.storage.from('avatars').remove([oldFileName]);
            }
          } catch (e) {
            debugPrint("Failed to delete old avatar file: $e");
            // Don't rethrow, the update was successful
          }
        }
        
        return url;
      }
      return null;
    } catch (e) {
      debugPrint("Update avatar error: $e");
      return null;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.woodyz://login-callback',
      );
      return true;
    } catch (e) {
      debugPrint("Reset password error: $e");
      return false;
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    try {
      await supabase.auth.updateUser(sb.UserAttributes(password: newPassword));
      return true;
    } catch (e) {
      debugPrint("Update password error: $e");
      return false;
    }
  }

  // --- Account Deletion ---
  Future<bool> deleteAccount() async {
    try {
      await supabase.rpc('delete_user');
      await signOut();
      return true;
    } catch (e) {
      debugPrint("Delete account error: $e");
      return false;
    }
  }

  // --- MFA (2FA) Support ---
  Future<sb.AuthMFAEnrollResponse> enrollMFA() async {
    return await supabase.auth.mfa.enroll(factorType: sb.FactorType.totp);
  }

  Future<void> verifyMFA(String factorId, String code) async {
    await supabase.auth.mfa.challengeAndVerify(
      factorId: factorId,
      code: code,
    );
  }

  Future<void> unenrollMFA(String factorId) async {
    await supabase.auth.mfa.unenroll(factorId);
  }

  Future<List<sb.Factor>> getMFAFactors() async {
    final res = await supabase.auth.mfa.listFactors();
    return res.all;
  }

  Future<bool> isMFAEnabled() async {
    final factors = await getMFAFactors();
    return factors.any((f) => f.status == sb.FactorStatus.verified);
  }
}
