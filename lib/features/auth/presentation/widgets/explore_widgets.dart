import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/presentation/pages/homescreen.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';

class SearchCont extends StatelessWidget {
  final TextEditingController searchcontroller;
  final Customer u;

  const SearchCont({super.key, required this.searchcontroller, required this.u});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
        width: 0.85*width,
        height: 170,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(46, 46, 45, 1),
              Color.fromRGBO(74, 36, 7, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Discover unique handcrafted products",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, fontFamily: "Saira"
                ),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                width: 0.75*width,
                child: TextField(
                    controller: searchcontroller,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: "search crafts",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    onSubmitted: (v){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Searched(query: v, u: u)));
                    },
                ),
              )
            ],
          ),
        )
    );
  }
}

const Color color = Color.fromRGBO(252, 184, 25, 1);
const List<(String, Icon)> categories = [("all" , Icon(Icons.all_inclusive, color: color)),
  ("Furniture" , Icon(Icons.chair, color: color)),("Decor", Icon(Icons.table_bar,color:  color)),
  ("Bedroom", Icon(Icons.bed, color: color)),("Bowls", Icon(Icons.coffee, color: color)),
  ("Kitchenware", Icon(Icons.restaurant, color: color)),("Outdoor", Icon(Icons.park, color: color,)),
  ("Art", Icon(Icons.palette, color: color)),
  ("Toys", Icon(Icons.toys, color: color)),("Others", Icon(Icons.inventory, color: color))
];

class Categories extends StatelessWidget {
  final Customer u;
  const Categories({super.key, required this.u});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.85,
      height: 125,
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Category(u: u, category: categories[i].$1)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color.fromRGBO(46, 46, 45, 1),
                        border: Border.all(
                          width: 1.6,
                          color: color,
                        ),
                      ),
                      child: categories[i].$2,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      categories[i].$1,
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
              )
            );
          },
        ),
      ),
    );
  }
}

class Category extends StatelessWidget {
  final Customer u;
  final String category;
  const Category({super.key, required this.u, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(252, 184, 25, 1),
        title: Text(category, style: const TextStyle(color: Colors.white),),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_rounded)),
      ),
      backgroundColor: Colors.black,
      body: Homescreen(c: u, category: category,),
    );
  }
}

class Searched extends StatelessWidget {
  final String query;
  final Customer u;
  const Searched({super.key, required this.query, required this.u});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(252, 184, 25, 1),
        title: Text("'$query'", style: const TextStyle(color: Colors.white),),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded)
        ),
      ),
      backgroundColor: Colors.black,
      body: Homescreen(c: u, query: query,),
    );
  }
}
