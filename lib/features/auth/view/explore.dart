import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/view/widgets/explore_widgets.dart';

import '../../controller/auth_controller.dart';

class Explore extends StatelessWidget {
  final Customer u;
  Explore({super.key, required this.u});

  TextEditingController _searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Search_cont(searchcontroller: _searchcontroller, u: u,),
            SizedBox(height: 10,),
            Text("Categories", style: TextStyle(color: Colors.white, fontFamily: "Saira", fontWeight: FontWeight.bold,fontSize: 20),),
            Categories(u: u,),
          ],
        ),
      ),
    );
  }
}
