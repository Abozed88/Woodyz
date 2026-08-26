import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/presentation/pages/login.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';

class PImage extends StatelessWidget {
  final String? image_url;
  const PImage({super.key, this.image_url});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      height: 140,
      width: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: primaryColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(70),
        child: image_url == null || image_url!.isEmpty 
          ? Image.asset('assets/images/no-profile.jpg', fit: BoxFit.cover) 
          : Image.network(
              image_url!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                    color: primaryColor,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                print(error);
                return Container(
                  color: theme.colorScheme.surface,
                  child: Icon(Icons.broken_image,
                      color: theme.colorScheme.onSurface.withOpacity(0.2),
                      size: 40),
                );
              }
            ),
      ),
    );
  }
}

class Preferences extends StatelessWidget {
  const Preferences({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            "Account Settings",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: "Saira",
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        _buildListTile(
          context,
          icon: Icons.person_outline,
          title: "Account & Security",
        ),
        _buildListTile(
          context,
          icon: Icons.notifications_none_outlined,
          title: "Notifications",
        ),
        _buildListTile(
          context,
          icon: Icons.help_outline,
          title: "Help & Support",
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ElevatedButton(
            onPressed: () => _showLogoutDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent.withOpacity(0.1),
              foregroundColor: Colors.redAccent,
              elevation: 0,
              side: const BorderSide(color: Colors.redAccent, width: 1.5),
              minimumSize: const Size(double.infinity, 55),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout_rounded, size: 20),
                SizedBox(width: 12),
                Text("LOG OUT", style: TextStyle(letterSpacing: 1.5)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, {required IconData icon, required String title}) {
    final theme = Theme.of(context);
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05)),
        ),
        child: Icon(icon, color: theme.colorScheme.primary, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontFamily: "Saira",
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.3)),
      onTap: () {
        // TODO: Navigation
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          "Log Out", 
          style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
        ),
        content: Text(
          "Are you sure you want to log out of your account?",
          style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("CANCEL", style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6))),
          ),
          TextButton(
            onPressed: () async {
              await AuthProvider(context: context).signOut();
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              }
            },
            child: const Text("LOG OUT", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
