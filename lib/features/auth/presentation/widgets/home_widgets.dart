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
    final theme = Theme.of(context);
    
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
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: theme.brightness == Brightness.light ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ] : null,
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
                                        color: theme.colorScheme.primary,
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: theme.colorScheme.surface,
                                    child: Icon(
                                      Icons.broken_image,
                                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                                      size: 40,
                                    ),
                                  ),
                            )
                          : Container(
                              color: theme.colorScheme.surface,
                              child: Icon(
                                Icons.image,
                                color: theme.colorScheme.onSurface.withOpacity(0.3),
                                size: 40,
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item.title,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
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
