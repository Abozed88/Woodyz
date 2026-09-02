import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/presentation/widgets/explore_widgets.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';

class Explore extends StatelessWidget {
  final Customer u;
  Explore({super.key, required this.u});

  final TextEditingController _searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24,),
          Center(child: SearchCont(searchcontroller: _searchcontroller, u: u,)),
          const SizedBox(height: 32,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Categories",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontFamily: "Saira",
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          Categories(u: u,),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}
