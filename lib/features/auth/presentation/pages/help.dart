import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support", style: TextStyle(fontFamily: "Saira", fontWeight: FontWeight.bold)),
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
            const Text(
              "How can we help you?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: "Saira",
              ),
            ),
            const SizedBox(height: 24),
            _buildSearchBar(theme),
            const SizedBox(height: 32),
            _buildSectionTitle(theme, "Frequently Asked Questions"),
            FAQTile(
              "How do I order a product?",
              "Woodyz acts as a bridge. Go to the product details page and tap 'REQUEST TO ORDER'. You will be redirected to the artisan's Instagram where you can finalize the deal.",
            ),
            FAQTile(
              "Are the artisans verified?",
              "We encourage artisans to provide their business address and social links. Always check reviews and ratings before making a purchase.",
            ),
            FAQTile(
              "How can I sell my woodcraft?",
              "Register as an 'Artisan' during signup. Once logged in, use the 'Upload' tab to list your masterpieces.",
            ),
            FAQTile(
              "Is there a shipping fee?",
              "Shipping is handled directly between you and the artisan. Costs vary based on location and the size of the piece.",
            ),
            const SizedBox(height: 32),
            _buildSectionTitle(theme, "Contact Support"),
            _buildContactCard(
              theme,
              Icons.email_outlined,
              "Email Us",
              "support@woodyz.com",
              () {
                // TODO: Launch email
              },
            ),
            _buildContactCard(
              theme,
              Icons.chat_bubble_outline,
              "Live Chat",
              "Available 9 AM - 5 PM",
              () {
                // TODO: Launch chat
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search help articles...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          fontFamily: "Saira",
        ),
      ),
    );
  }
}

class FAQTile extends StatelessWidget {
  final String question;
  final String answer;

  const FAQTile(this.question, this.answer, {super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: "Saira", fontSize: 14),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            answer,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildContactCard(ThemeData theme, IconData icon, String title, String subtitle, VoidCallback onTap) {
  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
    ),
    child: ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Saira")),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    ),
  );
}
