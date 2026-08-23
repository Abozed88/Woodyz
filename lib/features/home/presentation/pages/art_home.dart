import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/presentation/pages/artisan/upload.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';
import 'package:woodyz/features/auth/presentation/pages/homescreen.dart';
import 'package:woodyz/features/auth/presentation/pages/profile.dart';

class Arthome extends StatefulWidget {
  final Artisan artisan;
  const Arthome({super.key,required this.artisan});

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
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Woodyz", 
          style: TextStyle(
            fontFamily: "Western",
            fontSize: 24,
            letterSpacing: 2,
          ),
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.colorScheme.surface,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.5),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            activeIcon: Icon(Icons.store),
            label: 'My Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
