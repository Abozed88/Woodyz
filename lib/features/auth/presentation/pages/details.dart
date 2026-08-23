import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/presentation/widgets/details_widgets.dart';
import 'package:woodyz/features/products/presentation/providers/products_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';

class Details extends StatefulWidget {
  final Product p;
  final Artisan a;
  final Customer? u;
  final bool asArtisan;
  final bool already_saved;

  const Details({super.key, required this.p, required this.a,required this.u, required this.already_saved, this.asArtisan = false});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late bool _saved;

  @override
  void initState() {
    super.initState();
    _saved = widget.already_saved;
  }

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
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context), 
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
        actions:(widget.asArtisan == true || widget.u == null) ? null :
        [
          IconButton(
            onPressed: () async {
              ProductsProvider productControl = ProductsProvider();

              if (!_saved) {
                bool success = await productControl.saveProduct(widget.p.id!, widget.u!.id);

                if (!mounted) return;
                if (success) {
                  setState(() {
                    _saved = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite, color: primaryColor),
                          const SizedBox(width: 8),
                          Text("Added to favorites!", style: TextStyle(color: primaryColor)),
                        ],
                      ),
                      backgroundColor: theme.colorScheme.surface,
                      showCloseIcon: true,
                      closeIconColor: primaryColor,
                      duration: const Duration(seconds: 4),
                    ),
                  );
                }
              } else {
                bool success = await productControl.unsaveProduct(widget.p.id!, widget.u!.id);

                if (!mounted) return;

                if (success) {
                  setState(() {
                    _saved = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_border_outlined, color: primaryColor),
                          const SizedBox(width: 8),
                          Text("Removed from favorites!", style: TextStyle(color: primaryColor)),
                        ],
                      ),
                      backgroundColor: theme.colorScheme.surface,
                      duration: const Duration(seconds: 4),
                    ),
                  );
                }
              }
            },
            icon: !_saved
                ? const Icon(Icons.favorite_border_outlined)
                : const Icon(Icons.favorite, color: Colors.red),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: widget.p.imageUrl != null
                          ? Image.network(
                              widget.p.imageUrl!,
                              width: double.infinity,
                              height: 400,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 400,
                                color: theme.colorScheme.surface,
                                child: const Icon(Icons.broken_image, size: 64, color: Colors.white24),
                              ),
                            )
                          : Container(
                              height: 400,
                              color: theme.colorScheme.surface,
                              child: const Icon(Icons.image, size: 64, color: Colors.white24),
                            ),
                      ),
                      const SizedBox(height: 24),

                      // Category Chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: primaryColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          widget.p.category.toUpperCase(),
                          style: TextStyle(
                            color: primaryColor,
                            fontFamily: "Saira",
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Title and Rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.p.title,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Saira",
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.star_rounded, color: primaryColor, size: 20),
                                const SizedBox(width: 4),
                                const Text("4.5", style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Price
                      Text(
                        "\$${widget.p.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Saira",
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Divider(thickness: 1),
                      const SizedBox(height: 24),

                      // Info Widgets
                      Widget1(p: widget.p),
                      const SizedBox(height: 32),

                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Saira",
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.p.description,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 16,
                          height: 1.5,
                          fontFamily: "Saira",
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Artisan Card
                      const Text(
                        "About the Artisan",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Saira",
                        ),
                      ),
                      const SizedBox(height: 16),
                      Widget2(artisan: widget.a),
                      const SizedBox(height: 40),

                      // Order Button
                      ElevatedButton(
                        onPressed: () => _launchURL(widget.a.username),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 60),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const ImageIcon(
                              AssetImage('assets/icons/icons8-instagram-50.png'),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "REQUEST TO ORDER",
                              style: TextStyle(letterSpacing: 1.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ]
                )
            ),
          ],
        ),
      )
    );
  }
}
