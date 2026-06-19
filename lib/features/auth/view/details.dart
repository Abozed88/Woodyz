import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/view/widgets/details_widgets.dart';
import 'package:woodyz/features/controller/products_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:woodyz/features/controller/auth_controller.dart';

class Details extends StatefulWidget {
  final Product p;
  final Artisan a;
  final Customer? u;
  bool asArtisan;
  final bool already_saved;

  Details({super.key, required this.p, required this.a,required this.u, required this.already_saved, this.asArtisan = false});

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
    print(widget.u);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(252, 184, 25, 1),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_rounded)),
        actions:(widget.asArtisan == true || widget.u == null) ? null :
        [
          IconButton(
            onPressed: () async {
              Products_controller product_control = Products_controller();

              if (!_saved) {
                print(widget.u!.id.toString());
                print(widget.p.pid.toString());

                bool success = await product_control.saveProduct(widget.p, widget.u!);

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
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, color: Colors.red,),
                          Text("Failed to save. Please try again."),
                        ],
                      ),
                      backgroundColor: Colors.black54,
                    ),
                  );
                }
              } else {
                bool success = await product_control.unsaveProduct(widget.p, widget.u!);

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
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, color: Colors.red,),
                          Text("Couldn't remove. Please try again."),
                        ],
                      ),
                      backgroundColor: Colors.black54,
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
                padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                child: Column(
                    children: [
                      Image.network(
                        widget.p.img as String,
                        fit: BoxFit.cover,
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
                      SizedBox(height: 20),
                      Text(widget.p.name as String, style: TextStyle(color: Colors.white, fontFamily: "Saira", fontSize: 30, fontWeight: FontWeight.bold),),
                      TextButton(onPressed: (){}, child: Text(widget.p.category as String, style: TextStyle(color: Color.fromRGBO(252, 184, 25, 1), fontFamily: "Saira",fontSize: 12))),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("\$${widget.p.price}", style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: "Saira"),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star, color: Color.fromRGBO(252, 184, 25, 1),),
                              Text("4.5",style: TextStyle(color: Color.fromRGBO(252, 184, 25, 1), fontSize: 25, fontFamily: "Saira"),),
                              Text("(128 reviews)", style: TextStyle(color: Colors.grey[350], fontSize: 18, fontFamily: "Saira"),),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20,),
                      Divider(color: Colors.grey, thickness: 2,),
                      SizedBox(height: 20,),
                      Widget1(p: widget.p),
                      SizedBox(height: 20,),
                      Divider(color: Colors.grey, thickness: 2,),
                      SizedBox(height: 20,),
                      Text("Description", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, fontFamily: "Saira"),),
                      Text(widget.p.description as String, style: TextStyle(color: Colors.grey[350], fontSize: 18, fontStyle: FontStyle.italic, fontFamily: "Saira"),),
                      SizedBox(height: 20,),
                      Widget2(artisan: widget.a),
                      SizedBox(height: 20,),
                      Divider(color: Colors.grey, thickness: 2,),
                      SizedBox(height: 20,),
                      SizedBox(
                        height: 60,
                        width: width*0.9,
                        child: TextButton.icon(
                          label: Text("ORDER VIA INSTAGRAM", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "Saira"),),
                          onPressed: (){
                            _launchURL(widget.p.link as String);
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Color.fromRGBO(252, 184, 25, 1)),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          ),
                          icon: ImageIcon(
                            AssetImage('assets/icons/icons8-instagram-50.png'),
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                    ]
                )
            ),
          ],
        ),
      )
    );
  }
}
