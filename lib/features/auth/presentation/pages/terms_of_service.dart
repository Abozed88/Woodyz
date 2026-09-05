import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms of Service", style: TextStyle(fontFamily: "Saira", fontWeight: FontWeight.bold)),
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
            _section("1. Acceptance of Terms", 
              "By accessing or using Woodyz, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the app. These terms apply to all visitors, users, and others who access or use the Service."),
            
            _section("2. Description of Service", 
              "Woodyz is a marketplace platform that connects woodcraft artisans with potential customers. We provide the tools for artisans to showcase their work and for customers to discover and contact them. Woodyz is NOT a party to any transaction between users and does not handle payments directly within the app."),
            
            _section("3. User Accounts", 
              "When you create an account, you must provide accurate and complete information. You are solely responsible for the activity that occurs on your account, and you must keep your account password secure. You must notify Woodyz immediately of any breach of security or unauthorized use of your account."),
            
            _section("4. Artisan Responsibilities", 
              "Artisans are responsible for the quality, safety, and legality of the items they list. You represent and warrant that you have the right to sell the items you post and that your descriptions are honest and accurate. You agree to fulfill your obligations to customers and maintain a professional level of service."),
            
            _section("5. Customer Responsibilities", 
              "Customers are responsible for reading the full item listing before making a request to order. By requesting an order, you agree to contact the artisan through the provided channels (e.g., Instagram) and proceed with the transaction in good faith."),
            
            _section("6. Prohibited Conduct", 
              "You agree not to use the Service for any unlawful purpose or in any way that violates these Terms. Prohibited conduct includes, but is not limited to:\n"
              "• Posting inappropriate, offensive, or illegal content.\n"
              "• Harassing or harming other users.\n"
              "• Impersonating any person or entity.\n"
              "• Using the service to spread spam or malware.\n"
              "• Violating intellectual property rights."),
            
            _section("7. Intellectual Property", 
              "The Service and its original content (excluding content provided by users), features, and functionality are and will remain the exclusive property of Woodyz and its licensors. User content remains the property of the respective users, but by posting it, you grant Woodyz a non-exclusive, worldwide license to display and promote it within the platform."),
            
            _section("8. Limitation of Liability", 
              "Woodyz shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from (i) your access to or use of or inability to access or use the Service; (ii) any conduct or content of any third party on the Service; or (iii) any content obtained from the Service."),
            
            _section("9. Changes to Terms", 
              "We reserve the right, at our sole discretion, to modify or replace these Terms at any time. We will provide notice of any material changes by posting the new Terms on this page. Your continued use of the app after such changes constitutes acceptance of the new Terms."),
            
            _section("10. Contact Us", 
              "If you have any questions about these Terms, please contact us at woodyzSupport@gmail.com."),
            
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
