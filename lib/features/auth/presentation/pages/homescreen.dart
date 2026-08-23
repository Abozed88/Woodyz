import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/presentation/widgets/home_widgets.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';
import 'package:woodyz/features/products/presentation/providers/products_provider.dart';

class Homescreen extends StatefulWidget {
  final Customer? c;
  final Artisan? artisan;
  final String category;
  final String? query;
  const Homescreen({super.key,this.c, this.artisan,this.category = "all", this.query,});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Product> items = [];
  bool isLoading = false;
  bool continueLoading = true;
  bool noProducts = false;
  int timesLoaded = 0;
  int page = 0;
  final int limit = 20;
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _loadMore();
    timesLoaded++;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && continueLoading) {
        _loadMore();
        timesLoaded++;
      }
    });
  }

  Future<void> _loadMore() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    List<Product> newItems = await ProductsProvider().fetchData(page, limit, widget.category, widget.query, widget.artisan?.id);
    if (mounted) {
      if (newItems.isEmpty) {
        setState(() {
          continueLoading = false;
          isLoading = false;
          if(timesLoaded == 1){
            noProducts = true;
          }
        });
        return;
      }
      setState(() {
        page++;
        items.addAll(newItems);
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !noProducts ?
      Column(
      children: [
        Products(scrollController: _scrollController, items: items, u: widget.c, a: widget.artisan,),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(252, 184, 25, 1),
              ),
            ),
          ),
      ],
    ):
        const Center(
          child:  Text("No products found", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "Saira"),),
        );
  }
}
