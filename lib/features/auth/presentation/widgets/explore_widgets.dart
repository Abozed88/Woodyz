import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/presentation/pages/homescreen.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';

class SearchCont extends StatelessWidget {
  final TextEditingController searchcontroller;
  final Customer u;

  const SearchCont({super.key, required this.searchcontroller, required this.u});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    double width = MediaQuery.of(context).size.width;
    
    return Container(
        width: 0.85*width,
        height: 170,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark ? [
              const Color.fromRGBO(46, 46, 45, 1),
              const Color.fromRGBO(74, 36, 7, 1),
            ] : [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.primary.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: isDark ? null : Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Discover unique handcrafted products",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : theme.colorScheme.onSurface, 
                  fontFamily: "Saira"
                ),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                width: 0.75*width,
                child: TextField(
                    controller: searchcontroller,
                    style: TextStyle(color: isDark ? Colors.white : theme.colorScheme.onSurface),
                    cursorColor: theme.colorScheme.primary,
                    decoration: InputDecoration(
                      hintText: "search crafts",
                      hintStyle: TextStyle(color: isDark ? Colors.grey : theme.colorScheme.onSurface.withOpacity(0.5)),
                      prefixIcon: Icon(Icons.search, color: isDark ? Colors.grey : theme.colorScheme.primary),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      fillColor: isDark ? const Color.fromRGBO(46, 46, 45, 1) : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: isDark ? BorderSide.none : BorderSide(color: theme.colorScheme.primary.withOpacity(0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: isDark ? const BorderSide(color: Colors.grey, width: 1.0) : BorderSide(color: theme.colorScheme.primary.withOpacity(0.3)),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: isDark ? const Color.fromRGBO(46, 46, 45, 1) : Colors.white,
                        border: Border.all(
                          width: 1.6,
                          color: color,
                        ),
                        boxShadow: isDark ? null : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Icon(
                        categories[i].$2.icon,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      categories[i].$1,
                      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 12),
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
        title: Text(category),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios_new, size: 20)),
      ),
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
        title: Text("'$query'"),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, size: 20)
        ),
      ),
      body: Homescreen(c: u, query: query,),
    );
  }
}
