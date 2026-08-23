import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';
import 'package:woodyz/features/products/presentation/providers/products_provider.dart';
import 'package:woodyz/features/auth/presentation/pages/details.dart';

class Saved extends StatefulWidget {
  final Customer u;
  const Saved({super.key,required this.u});

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  List<Product> saved = [];
  bool isLoading = false;
  int page = 0;
  final int limit = 20;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMore();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _loadMore();
      }
    });
  }

  Future<void> _loadMore() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      List<Product> newItems = await ProductsProvider().fetchSaved(page, limit, widget.u.id);
      if (mounted) {
        setState(() {
          page++;
          // Basic de-duplication
          for (var newItem in newItems) {
            if (!saved.any((s) => s.id == newItem.id)) {
              saved.add(newItem);
            }
          }
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return saved.isEmpty ? Center(child: Text("No saved products",style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5), fontFamily: "Saira", fontSize: 20))) :
    GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: saved.length,
      itemBuilder: (context, index) {
        final item = saved[index];
        return InkWell(
          onTap: () async{
            Artisan artisan = await ProductsProvider().fetchArtisanData(item.artisanId);
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder:(context) => Details(p: item,a: artisan, u: widget.u, already_saved: true,),),
              );
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: theme.brightness == Brightness.light ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ] : null,
                border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
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
                                          value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                            : null,
                                          color: theme.colorScheme.primary,
                                        ),
                                      );
                                },
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: theme.colorScheme.surface,
                                  child: Icon(
                                    Icons.broken_image,
                                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                                    size: 40,
                                  ),
                                ),
                              )
                            :  Container(
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
                      ]
                  )
              )
          ),
        );
      },
    );
  }
}
