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
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(252, 184, 25, 1),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_rounded)),
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
                    const SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite, color: Color.fromRGBO(252, 184, 25, 1),),
                          Text("Added to favorites!", style: TextStyle(color: Color.fromRGBO(252, 184, 25, 1),),),
                        ],
                      ),
                      backgroundColor: Colors.black54,
                      showCloseIcon: true,
                      closeIconColor: Color.fromRGBO(252, 184, 25, 1),
                      duration: Duration(seconds: 4),
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
                    const SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_border_outlined, color: Color.fromRGBO(252, 184, 25, 1),),
                          Text("Removed from favorites!", style: TextStyle(color: Color.fromRGBO(252, 184, 25, 1),),),
                        ],
                      ),
                      backgroundColor: Colors.black54,
                      duration: Duration(seconds: 4),
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
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                    children: [
                      if (widget.p.imageUrl != null)
                        Image.network(
                          widget.p.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[800],
                            child: const Icon(Icons.broken_image, color: Colors.white54, size: 40),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Text(widget.p.title, style: const TextStyle(color: Colors.white, fontFamily: "Saira", fontSize: 30, fontWeight: FontWeight.bold),),
                      TextButton(onPressed: (){}, child: Text(widget.p.category, style: const TextStyle(color: Color.fromRGBO(252, 184, 25, 1), fontFamily: "Saira",fontSize: 12))),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("\$${widget.p.price}", style: const TextStyle(color: Colors.white, fontSize: 25, fontFamily: "Saira"),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star, color: Color.fromRGBO(252, 184, 25, 1),),
                              const Text("4.5",style: TextStyle(color: Color.fromRGBO(252, 184, 25, 1), fontSize: 25, fontFamily: "Saira"),),
                              Text("(128 reviews)", style: TextStyle(color: Colors.grey[350], fontSize: 18, fontFamily: "Saira"),),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 20,),
                      const Divider(color: Colors.grey, thickness: 2,),
                      const SizedBox(height: 20,),
                      Widget1(p: widget.p),
                      const SizedBox(height: 20,),
                      const Divider(color: Colors.grey, thickness: 2,),
                      const SizedBox(height: 20,),
                      const Text("Description", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, fontFamily: "Saira"),),
                      Text(widget.p.description, style: TextStyle(color: Colors.grey[350], fontSize: 18, fontStyle: FontStyle.italic, fontFamily: "Saira"),),
                      const SizedBox(height: 20,),
                      Widget2(artisan: widget.a),
                      const SizedBox(height: 20,),
                      const Divider(color: Colors.grey, thickness: 2,),
                      const SizedBox(height: 20,),
                      SizedBox(
                        height: 60,
                        width: width*0.9,
                        child: TextButton.icon(
                          label: const Text("ORDER VIA INSTAGRAM", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "Saira"),),
                          onPressed: (){
                            // Assuming link is stored somewhere, maybe profile bio? Or product has a link?
                            // For now using artisan's username as handle
                            _launchURL(widget.a.username);
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
                      const SizedBox(height: 20,),
                    ]
                )
            ),
          ],
        ),
      )
    );
  }
}
