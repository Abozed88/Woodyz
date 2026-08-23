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
    final scrollController = ScrollController();
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Color.fromRGBO(252, 184, 25, 1)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    PImage(image_url: artisan.avatarUrl),
                    const SizedBox(height: 10),
                    Text(artisan.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white)),
                    const Text("Artisan", style: TextStyle(color: Color.fromRGBO(252, 184, 25, 1), fontFamily: "Saira")),
                    const SizedBox(height: 30), 
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 80,
                            child: Text("Bio", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color.fromRGBO(252, 184, 25, 1), fontFamily: "Saira")),
                          ),
                          Expanded(
                            child: Text(artisan.bio ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white, fontFamily: "Saira")),
                          ),
                        ]
                    ),
                    const SizedBox(height: 15),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 80,
                            child: Text("Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color.fromRGBO(252, 184, 25, 1), fontFamily: "Saira")),
                          ),
                          Expanded(
                            child: Text(artisan.location, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white, fontFamily: "Saira")),
                          ),
                        ]
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 60,
                      width: width * 0.9,
                      child: TextButton.icon(
                        label: const Text("CONTACT VIA INSTAGRAM", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Saira")), 
                        onPressed: () {
                          _launchURL(artisan.username);
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(const Color.fromRGBO(252, 184, 25, 1)),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        ),
                        icon: const ImageIcon(
                          AssetImage('assets/icons/icons8-instagram-50.png'),
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    items.isEmpty ? const Center(child: Text("No products found", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "Saira"))) :
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      controller: scrollController,
                      padding: const EdgeInsets.all(10),
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
                          onTap: () async{
                            final u = Customer(username: "", fullName: "", location: "", id: "");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder:(context) => Details(p: item,a: artisan, u: u,already_saved: false,),),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(8),
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
                                                  color: Colors.grey[800],
                                                  child: const Icon(Icons.broken_image, color: Colors.white54, size: 40),
                                                ),
                                              )
                                            : Container(color: Colors.grey[800], child: const Icon(Icons.image, color: Colors.white54, size: 40)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            item.title,
                                            style: const TextStyle(
                                              color: Colors.white,
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
