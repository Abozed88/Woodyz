import 'package:flutter/material.dart';
import 'package:woodyz/features/controller/products_controller.dart';
import 'package:woodyz/features/controller/auth_controller.dart';

import '../artisan_view.dart';

class Widget1 extends StatelessWidget {
  final Product p;
  const Widget1({super.key, required this.p});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: width*0.4,
          height: 200,
          decoration: BoxDecoration(
           color: const Color.fromRGBO(46, 46, 45, 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              SizedBox(height: 30),
              Icon(Icons.production_quantity_limits, color: const Color.fromRGBO(252, 184, 25, 1), size: 50,),
              Text("Stock Quantity", style: TextStyle(color: Colors.grey[350], fontSize: 14, fontFamily: "Saira"),),
              Text(p.stock.toString(), style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
            ],
          ),
        ),
        Container(
          width: width*0.4,
          height: 200,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(46, 46, 45, 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              SizedBox(height: 30),
              Icon(Icons.access_time_filled_sharp, color: const Color.fromRGBO(252, 184, 25, 1), size: 50,),
              Text("Uploaded At", style: TextStyle(color: Colors.grey[350], fontSize: 14, fontFamily: "Saira"),),
              Text(p.date as String, style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
            ],
          ),
        ),
      ],
    );
  }
}

class Widget2 extends StatelessWidget {
  final Artisan artisan;

  const Widget2({super.key, required this.artisan});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(82, 55, 10, 1),
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(width: 1, color: Color.fromRGBO(112, 75, 13, 1))
      ),
      child: InkWell(
        onTap: () async{
          List<Product> newItems = await Products_controller().fetchData(0, 100, "all", null, artisan.id);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArtisanView(artisan: artisan, items: newItems,),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.white10,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color.fromRGBO(252, 184, 25, 1),),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: artisan.image == "" || artisan.image == null
                      ? const CircleAvatar(backgroundImage: AssetImage("assets/images/profile.webp"))
                      : CircleAvatar(backgroundImage: NetworkImage(artisan.image!))
              ),
              const SizedBox(width: 15,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artisan.shop ?? "No Shop Name",
                      style: const TextStyle(color: Color.fromRGBO(252, 184, 25, 1), fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "Saira"),
                    ),
                    Text(
                      artisan.name,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Saira"),
                    ),
                    Text(
                      artisan.location,
                      style: TextStyle(color: Colors.grey[350], fontSize: 14, fontFamily: "Saira"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}