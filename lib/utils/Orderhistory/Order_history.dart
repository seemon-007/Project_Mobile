import 'package:flutter/material.dart';



class OrderHistory extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ประวัติสั่งซื้อ'),backgroundColor: Colors.blue,),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}