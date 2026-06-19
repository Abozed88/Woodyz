import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/view/saved.dart';
import 'package:woodyz/features/controller/auth_controller.dart';
import 'package:woodyz/features/auth/view/explore.dart';
import 'package:woodyz/features/auth/view/homescreen.dart';
import 'package:woodyz/features/auth/view/profile.dart';
import 'package:woodyz/features/controller/products_controller.dart';


class Home extends StatefulWidget {
  final Customer customer;
  const Home({super.key,required this.customer});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedIndex = 0;

  List<Widget> get _screens => [
    Homescreen(c: widget.customer),
    Explore(u: widget.customer,),
    Saved(u: widget.customer),
    Profile(c: widget.customer,),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    print("Customer found from DB: ${widget.customer.toString()}");
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(252, 184, 25, 1),
        title: Text("Woodyz", style: TextStyle(color: Colors.white, fontFamily: "Western",),)
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromRGBO(46, 46, 45, 1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromRGBO(252, 184, 25, 1),
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        onTap: _onItemTapped,
      ),
    );
  }
}
