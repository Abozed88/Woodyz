import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woodyz/core/theme/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark || 
                   (themeProvider.themeMode == ThemeMode.system && theme.brightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontFamily: "Saira", fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSectionHeader(context, "Appearance"),
          SwitchListTile(
            secondary: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: theme.colorScheme.primary,
            ),
            title: const Text(
              "Dark Mode",
              style: TextStyle(fontFamily: "Saira", fontSize: 16),
            ),
            subtitle: Text(
              themeProvider.themeMode == ThemeMode.system ? "Following System" : (isDark ? "On" : "Off"),
              style: TextStyle(
                fontFamily: "Saira", 
                fontSize: 12, 
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            value: isDark,
            activeThumbColor: theme.colorScheme.primary,
            onChanged: (bool value) {
              themeProvider.toggleTheme(value);
            },
          ),
          ListTile(
            leading: Icon(Icons.brightness_auto, color: theme.colorScheme.primary),
            title: const Text(
              "Use System Settings",
              style: TextStyle(fontFamily: "Saira", fontSize: 16),
            ),
            trailing: themeProvider.themeMode == ThemeMode.system 
                ? Icon(Icons.check, color: theme.colorScheme.primary) 
                : null,
            onTap: () => themeProvider.setSystemTheme(),
          ),
          
          const Divider(indent: 16, endIndent: 16),
          
          _buildSectionHeader(context, "Account"),
          _buildSettingTile(
            context,
            icon: Icons.lock_outline,
            title: "Privacy & Security",
          ),
          
          const Divider(indent: 16, endIndent: 16),
          
          _buildSectionHeader(context, "Support"),
          _buildSettingTile(
            context,
            icon: Icons.help_outline,
            title: "Help Center",
          ),
          _buildSettingTile(
            context,
            icon: Icons.info_outline,
            title: "About Woodyz",
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          fontFamily: "Saira",
        ),
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, {required IconData icon, required String title}) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
      title: Text(
        title,
        style: const TextStyle(fontFamily: "Saira", fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () {
        // TODO: Navigation
      },
    );
  }
}
