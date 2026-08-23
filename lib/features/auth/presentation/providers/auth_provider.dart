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
      Customer c = Customer.fromProfile(profile);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home(customer: c)));
    } else if (profile.role == 'artisan') {
      Artisan a;
      if (extraData != null) {
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
        
        if (profileData['role'] == 'artisan') {
          final artisan = Artisan.fromJson(profileData);
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
      final fileExt = image.path.split('.').last;
      final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = fileName;

      await supabase.storage.from('avatars').upload(
            filePath,
            image,
            fileOptions: const sb.FileOptions(cacheControl: '3600', upsert: false),
          );

      final String publicUrl =
          supabase.storage.from('avatars').getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      debugPrint("Upload error: $e");
      return "";
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
        await supabase.from('profiles').insert(newUser.toJson());

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
}
