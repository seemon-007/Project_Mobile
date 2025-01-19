import 'package:project_app/Page/ProfilePage.dart';
import 'package:project_app/Page/HomePage.dart';
import 'package:project_app/Page/cart_provider.dart';
import 'package:project_app/Page/login.dart';
import 'package:project_app/Page/payment.dart';
import 'package:project_app/Page/product_list.dart';
import 'package:project_app/Page/CartPage.dart';
import 'package:flutter/material.dart';
import 'package:project_app/Page/register.dart';
import 'package:provider/provider.dart';
import 'BasePage.dart';

void main() => runApp(LinkPage());

class LinkPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(builder: (BuildContext context) {
        return MaterialApp(
          // home: LoginPage(),
          title: 'Flutter Link Page Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => HomePage(),
            '/product': (context) => ProductPage(),
            '/Cart': (context) => CartPage(),
            '/User':(context) => ProfilePage(),
            '/Payment':(context) => PaymentPage(),
            // '/login':(context) => LoginPage(),
            '/register':(context) => RegisterPage(),
          },
        );
      }),
    );
  }
}