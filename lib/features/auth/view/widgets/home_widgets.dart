import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/view/details.dart';
import 'package:woodyz/features/controller/auth_controller.dart';
import 'package:woodyz/features/controller/products_controller.dart';

class Products extends StatelessWidget {
  final ScrollController scrollController;
  final List<Product> items;
  Customer? u;
  Artisan? a;

  Products({
    super.key,
    required ScrollController this.scrollController,
    required List<Product> this.items,
    this.u, this.a
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
            onTap: () async{
              if(u == null){
                u = Customer(name: "", email: "", password: "", link: "", type: "type", location: "", id: 0);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:(context) => Details(p: item,a: a as Artisan, u: u,already_saved: false, asArtisan: true,),),
                );
              }
              else{
                a = await Products_controller().fetchArtisanData(item.artid as int);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:(context) => Details(p: item,a: a as Artisan, u: u as Customer,already_saved: false,),),
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
      ),
    );
  }
}
