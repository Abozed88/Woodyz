import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/view/artisian/upload.dart';
import 'package:woodyz/features/controller/auth_controller.dart';

import '../auth/view/homescreen.dart';
import '../auth/view/profile.dart';

class Arthome extends StatefulWidget {
  final Artisan artisan;
  Arthome({super.key,required this.artisan});

  @override
  State<Arthome> createState() => _ArthomeState();
}

class _ArthomeState extends State<Arthome> {

  int _selectedIndex = 0;

  List<Widget> get _screens => [
    Homescreen(artisan: widget.artisan,),
    Upload(artisan: widget.artisan),
    Profile(a: widget.artisan),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
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
            icon: Icon(Icons.store),
            label: 'My Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
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
