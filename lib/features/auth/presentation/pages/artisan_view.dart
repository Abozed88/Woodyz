import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:woodyz/features/auth/presentation/widgets/profile_widgets.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';
import 'package:woodyz/features/products/presentation/providers/products_provider.dart';
import 'package:woodyz/features/auth/presentation/pages/details.dart';

class ArtisanView extends StatelessWidget {
  final Artisan artisan;
  final List<Product> items;
  const ArtisanView({super.key, required this.artisan, required this.items});

  Future<void> _launchURL(String username) async {
    final Uri url = Uri.parse("https://instagram.com/$username");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scrollController = ScrollController();
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.primary, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    PImage(image_url: artisan.avatarUrl),
                    const SizedBox(height: 10),
                    Text(artisan.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                    Text("Artisan", style: TextStyle(color: theme.colorScheme.primary, fontFamily: "Saira")),
                    const SizedBox(height: 30), 
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Bio", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: theme.colorScheme.primary, fontFamily: "Saira")),
                    Text(artisan.bio ?? "No bio provided.", style: TextStyle(fontSize: 15, color: theme.colorScheme.onSurface.withOpacity(0.7), fontFamily: "Saira")),
                    const SizedBox(height: 15),
                    Text("Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: theme.colorScheme.primary, fontFamily: "Saira")),
                    Text(artisan.address ?? artisan.location, style: TextStyle(fontSize: 15, color: theme.colorScheme.onSurface.withOpacity(0.7), fontFamily: "Saira")),
                    const SizedBox(height: 15),
                    Text("Skills", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: theme.colorScheme.primary, fontFamily: "Saira")),
                    Wrap(
                      spacing: 8,
                      children: artisan.skills.map((skill) => Chip(
                        label: Text(skill, style: const TextStyle(fontSize: 12)),
                        backgroundColor: theme.colorScheme.surface,
                        side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.3)),
                      )).toList(),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: SizedBox(
                        height: 60,
                        width: width * 0.9,
                        child: TextButton.icon(
                          label: const Text("CONTACT VIA INSTAGRAM", style: TextStyle(fontSize: 18, fontFamily: "Saira")), 
                          onPressed: () {
                            _launchURL(artisan.username);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                          icon: const ImageIcon(
                            AssetImage('assets/icons/icons8-instagram-50.png'),
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text("Products", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, fontFamily: "Saira")),
                    items.isEmpty ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: Text("No products found", style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5), fontSize: 18, fontFamily: "Saira"))),
                    ) :
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 250,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return InkWell(
                          onTap: () {
                            final u = Customer(username: "", fullName: "", location: "", id: "");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder:(context) => Details(p: item,a: artisan, u: u,already_saved: false,),),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05)),
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: item.imageUrl != null
                                            ? Image.network(
                                                item.imageUrl!,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => Container(
                                                  color: theme.colorScheme.surface,
                                                  child: const Icon(Icons.broken_image, size: 40),
                                                ),
                                              )
                                            : Container(color: theme.colorScheme.surface, child: const Icon(Icons.image, size: 40)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            item.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Saira"
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ]
                                  )
                              )
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
