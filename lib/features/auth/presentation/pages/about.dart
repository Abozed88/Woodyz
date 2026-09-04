import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("About Woodyz", style: TextStyle(fontFamily: "Saira", fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildAppLogo(theme),
            const SizedBox(height: 24),
            const Text(
              "Woodyz",
              style: TextStyle(
                fontFamily: "Western",
                fontSize: 36,
                letterSpacing: 4,
              ),
            ),
            const Text(
              "Version 1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),
            _buildMissionCard(theme),
            const SizedBox(height: 40),
            _buildLinkTile(context, "Terms of Service", Icons.description_outlined),
            _buildLinkTile(context, "Privacy Policy", Icons.privacy_tip_outlined),
            _buildLinkTile(context, "Community Guidelines", Icons.group_outlined),
            _buildLinkTile(context, "Licenses", Icons.info_outline),
            const SizedBox(height: 60),
            Text(
              "© 2026 Woodyz. All rights reserved.",
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                fontSize: 12,
                fontFamily: "Saira",
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAppLogo(ThemeData theme) {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          )
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.park_outlined, // A tree-like icon for woodcraft
          size: 60,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildMissionCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text(
            "Our Mission",
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: "Saira",
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Woodyz is dedicated to bringing the soul of woodcraft into your home by connecting passionate artisans with discerning customers. We believe every piece of wood tells a story, and we're here to help you find yours.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTile(BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontFamily: "Saira")),
      trailing: const Icon(Icons.open_in_new, size: 16, color: Colors.grey),
      onTap: () {
        // TODO: Open URL
      },
    );
  }
}
