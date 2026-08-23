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
    return saved.isEmpty ? const Center(child: Text("No saved products",style: TextStyle(color: Colors.white, fontFamily: "Saira", fontSize: 20))) :
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
                              fontWeight: FontWeight.bold, fontFamily: "Saira"
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
