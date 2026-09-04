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
        width: 0.9*width,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2E2E2D),
              const Color(0xFF4A2407),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDark ? [] : [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Discover unique\nhandcrafted products",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: Colors.white, 
                fontFamily: "Saira"
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
                controller: searchcontroller,
                style: const TextStyle(color: Colors.white),
                cursorColor: theme.colorScheme.primary,
                decoration: InputDecoration(
                  hintText: "Search crafts...",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  fillColor: Colors.white.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (v){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Searched(query: v, u: u)));
                },
            ),
          ],
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
    double width = MediaQuery.of(context).size.width;
    
    return Container(
      width: width,
      height: 110,
      margin: const EdgeInsets.only(top: 10),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.transparent,
              Colors.white.withOpacity(0.1),
              Colors.white,
              Colors.white,
            ],
            stops: const [0.0, 0.05, 0.2, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Category(u: u, category: categories[i].$1)));
                },
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: isDark ? const Color(0xFF2E2E2D) : Colors.white,
                        border: Border.all(
                          width: 1.2,
                          color: color.withOpacity(0.4),
                        ),
                        boxShadow: isDark ? [] : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Icon(
                        categories[i].$2.icon,
                        color: color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      categories[i].$1,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface, 
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Saira",
                      ),
                    )
                  ],
                ),
              ),
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

class FilterDialog extends StatefulWidget {
  final Customer u;
  const FilterDialog({super.key, required this.u});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String selectedCategory = "all";
  String selectedLocation = "Any";
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  final List<String> locations = ["Any", "Beirut", "Tripoli", "Sidon", "Tyre", "Byblos", "Baalbek", "Zahle"];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Filter Products",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Saira",
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),
              
              // Price Range
              Text("Price Range", style: _labelStyle(theme)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _priceField("Min", _minPriceController, theme, isDark),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _priceField("Max", _maxPriceController, theme, isDark),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Location
              Text("Artisan Location", style: _labelStyle(theme)),
              const SizedBox(height: 12),
              _dropdownField(
                value: selectedLocation,
                items: locations,
                onChanged: (v) => setState(() => selectedLocation = v!),
                theme: theme,
                isDark: isDark,
              ),
              const SizedBox(height: 24),

              // Category
              Text("Category", style: _labelStyle(theme)),
              const SizedBox(height: 12),
              _dropdownField(
                value: selectedCategory,
                items: categories.map((e) => e.$1).toList(),
                onChanged: (v) => setState(() => selectedCategory = v!),
                theme: theme,
                isDark: isDark,
              ),
              const SizedBox(height: 32),

              // Search Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    final min = double.tryParse(_minPriceController.text);
                    final max = double.tryParse(_maxPriceController.text);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilteredResults(
                          u: widget.u,
                          category: selectedCategory,
                          location: selectedLocation,
                          minPrice: min,
                          maxPrice: max,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(252, 184, 25, 1),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Search",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Saira",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _labelStyle(ThemeData theme) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: "Saira",
    color: theme.colorScheme.onSurface.withOpacity(0.8),
  );

  Widget _priceField(String hint, TextEditingController controller, ThemeData theme, bool isDark) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4)),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _dropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontFamily: "Saira",
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class FilteredResults extends StatelessWidget {
  final Customer u;
  final String category;
  final String? location;
  final double? minPrice;
  final double? maxPrice;

  const FilteredResults({
    super.key,
    required this.u,
    this.category = "all",
    this.location,
    this.minPrice,
    this.maxPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filtered Results"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
      ),
      body: Homescreen(
        c: u,
        category: category,
        location: location,
        minPrice: minPrice,
        maxPrice: maxPrice,
      ),
    );
  }
}
