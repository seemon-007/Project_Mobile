import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  final Widget body;
  final int index;

  const BasePage({super.key, required this.body, required this.index});

  @override
  State createState(){
    return BasePageState();
  }
}

class BasePageState extends State<BasePage>{

  final List<String> routes = ['/', '/product', '/Cart','/User', '/Payment'];
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
        backgroundColor: Colors.blue,
      ),
      body: widget.body,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        currentIndex: widget.index,
        selectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(icon: Icon(Icons.business),
            label: 'Product',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),
            label: 'Cart',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle),
            label: 'Profile',
            backgroundColor: Colors.blue,
          ),

        ],
        onTap: (index) =>
            setState((){
              Navigator.pushNamed(context, routes[index]);
            }),
      ),
    );
  }
}