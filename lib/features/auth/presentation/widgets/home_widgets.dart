import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/presentation/pages/details.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';
import 'package:woodyz/features/products/presentation/providers/products_provider.dart';

class Products extends StatelessWidget {
  final ScrollController scrollController;
  final List<Product> items;
  final Customer? u;
  final Artisan? a;

  const Products({
    super.key,
    required this.scrollController,
    required this.items,
    this.u,
    this.a,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
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
            onTap: () async {
              if (u == null) {
                final tempU = Customer(
                  username: "",
                  fullName: "",
                  location: "",
                  id: "",
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Details(
                      p: item,
                      a: a as Artisan,
                      u: tempU,
                      already_saved: false,
                      asArtisan: true,
                    ),
                  ),
                );
              } else {
                final artisan = await ProductsProvider().fetchArtisanData(
                  item.artisanId,
                );
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Details(
                        p: item,
                        a: artisan,
                        u: u as Customer,
                        already_saved: false,
                      ),
                    ),
                  );
                }
              }
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
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                            : null,
                                        color: const Color.fromRGBO(
                                          252,
                                          184,
                                          25,
                                          1,
                                        ),
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.grey[800],
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.white54,
                                      size: 40,
                                    ),
                                  ),
                            )
                          : Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.image,
                                color: Colors.white54,
                                size: 40,
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Saira",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
