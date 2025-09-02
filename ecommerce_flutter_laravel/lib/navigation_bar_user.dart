
import 'package:ecommerce_flutter_laravel/home_pagebackup.dart';
import 'package:ecommerce_flutter_laravel/profileUser.dart';
import 'package:flutter/material.dart';


class ButtomNavigationBarUser extends StatefulWidget {
  const ButtomNavigationBarUser({super.key});

  @override
  State<ButtomNavigationBarUser> createState() => _ButtomNavigationBarUserState();
}

class _ButtomNavigationBarUserState extends State<ButtomNavigationBarUser> {

  int _selectedIndex = 0;

  List<Widget> _screenList = [
    HomePage(),
    ProfilePage()
  ];

  void screenChanging(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screenList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:  Colors.deepOrange,
        selectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: screenChanging,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ]
      ) ,
    );
  }
}