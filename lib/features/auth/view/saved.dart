import 'package:flutter/material.dart';
import 'package:woodyz/features/controller/auth_controller.dart';
// import 'package:woodyz/features/home/home.dart';
import 'package:woodyz/features/controller/products_controller.dart';
import 'package:woodyz/features/auth/view/details.dart';

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

    List<Product> newItems = await Products_controller().fetchSaved(page, limit, widget.u.id);
    setState(() {
      page++;
      for(int i = 0; i < newItems.length; i++){
        for(int j=0; j< saved.length; j++) {
          if (newItems[i].pid == saved[j].pid) {
            newItems.removeAt(i);
            i--;
          }
        }
      }
      saved.addAll(newItems);
      isLoading = false;
    });
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
            Artisan artisan = await Products_controller().fetchArtisanData(item.artid as int);
            Navigator.push(
              context,
              MaterialPageRoute(builder:(context) => Details(p: item,a: artisan, u: widget.u, already_saved: true,),),
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
                          child: Image.network(
                            item.img as String,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: const Color.fromRGBO(252, 184, 25, 1),
                                ),
                              );
                            },
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              return Container(
                                color: Colors.grey[800],
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.white54,
                                  size: 40,
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item.name as String,
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
