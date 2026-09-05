import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy", style: TextStyle(fontFamily: "Saira", fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section("Introduction", 
              "At Woodyz, we value your privacy. This Privacy Policy explains how we collect, use, and protect your information when you use our mobile application and related services."),
            
            _section("1. Information We Collect", 
              "We collect several types of information from and about users of our App, including:\n"
              "• Personal Data: Email address, full name, phone number, and profile picture provided during registration.\n"
              "• Business Data: For artisans, we collect business addresses, skills, and Instagram usernames.\n"
              "• Location Data: General location (e.g., city/region) to help users find local woodcraft.\n"
              "• Usage Data: Information about how you interact with the app, such as products saved and artisans viewed."),
            
            _section("2. How We Use Your Information", 
              "We use the information we collect to:\n"
              "• Provide and maintain the App's functionality.\n"
              "• Create and manage your user account.\n"
              "• Facilitate connections between artisans and customers.\n"
              "• Improve our services and user experience through analytics.\n"
              "• Send you important notifications and updates."),
            
            _section("3. Sharing of Your Information", 
              "We do not sell your personal information. We may share your information with:\n"
              "• Other Users: Your profile information (name, bio, location, products) is visible to other users to enable the marketplace functionality.\n"
              "• Service Providers: We use third-party services like Supabase for authentication, database storage, and image hosting.\n"
              "• Legal Requirements: If required by law or to protect our rights, we may disclose your information."),
            
            _section("4. Data Security", 
              "We implement industry-standard security measures to protect your data. However, no method of transmission over the internet or electronic storage is 100% secure. While we strive to protect your personal data, we cannot guarantee its absolute security."),
            
            _section("5. Your Rights", 
              "You have the right to:\n"
              "• Access and update your personal information through your profile settings.\n"
              "• Delete your account and associated data (available in Account & Security settings).\n"
              "• Contact us to request more information about how your data is handled."),
            
            _section("6. Children's Privacy", 
              "Our services are not intended for children under the age of 13. We do not knowingly collect personal information from children under 13."),
            
            _section("7. Changes to This Policy", 
              "We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the 'Last Updated' date."),
            
            _section("Contact Us", 
              "If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at woodyzSupport@gmail.com."),

            const SizedBox(height: 40),
            Center(
              child: Text(
                "Last Updated: September 2026",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 12,
                  fontFamily: "Saira",
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: "Saira",
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              fontFamily: "Saira",
            ),
          ),
        ],
      ),
    );
  }
}
