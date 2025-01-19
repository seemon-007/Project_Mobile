import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'BasePage.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return const BasePage(body: Center(child: Text('Main Page')),index: 0,
    );
  }
}
