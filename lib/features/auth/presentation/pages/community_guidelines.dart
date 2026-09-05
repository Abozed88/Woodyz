import 'package:flutter/material.dart';

class CommunityGuidelinesPage extends StatelessWidget {
  const CommunityGuidelinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Guidelines", style: TextStyle(fontFamily: "Saira", fontWeight: FontWeight.bold)),
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
              "Building a safe and creative woodcraft community",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: "Saira",
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Woodyz is a space dedicated to the art of woodcraft. We want to ensure that every interaction on our platform is respectful, safe, and inspiring. By using Woodyz, you agree to follow these guidelines.",
              style: TextStyle(fontSize: 14, height: 1.5, fontFamily: "Saira"),
            ),
            const SizedBox(height: 32),
            
            _guideline(
              "1. Respect and Inclusion",
              "Treat everyone with kindness. We have zero tolerance for hate speech, harassment, or discrimination based on race, religion, gender, or orientation.",
              Icons.favorite_outline,
            ),
            
            _guideline(
              "2. Authenticity in Craft",
              "Artisans should showcase their own original work. Do not use stock photos or images that do not accurately represent the product being sold. Be honest about materials and techniques used.",
              Icons.auto_awesome_outlined,
            ),
            
            _guideline(
              "3. Professional Communication",
              "Keep all interactions professional and respectful. Whether you are discussing a custom order or asking about shipping, clear and polite communication helps build a strong community.",
              Icons.chat_bubble_outline,
            ),
            
            _guideline(
              "4. Prohibited Items",
              "Woodyz is specifically for wood-based handcrafted items. Do not list unrelated products, mass-produced items, or any materials that are illegal or harmful (e.g., protected wood species without certification).",
              Icons.block_flipped,
            ),
            
            _guideline(
              "5. Safe Transactions",
              "While we facilitate the connection, transactions happen outside the app. We recommend using secure payment methods and meeting in public places if conducting local handovers.",
              Icons.verified_user_outlined,
            ),
            
            _guideline(
              "6. Honest Reviews",
              "Reviews are vital for our community. Please leave honest and constructive feedback. Fake reviews or reviews aimed at harming an artisan's reputation without cause are prohibited.",
              Icons.star_outline_rounded,
            ),

            const SizedBox(height: 32),
            _section("How to Report", 
              "If you encounter a user, product, or artisan that violates these guidelines, please use the 'Report' button found on the product details or artisan profile pages. Our team reviews all reports to maintain the integrity of our community."),
            
            const SizedBox(height: 40),
            Center(
              child: Text(
                "Together, we keep Woodyz crafted with passion.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontFamily: "Western",
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _guideline(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: const Color.fromRGBO(252, 184, 25, 1)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Saira",
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontFamily: "Saira",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, String content) {
    return Column(
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
    );
  }
}
