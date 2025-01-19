import 'package:flutter/material.dart';

import 'add_new_address.dart';

import 'single_address.dart';

class UserAddress extends StatelessWidget {
  const UserAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: (){
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddNewAddress()));
        },
        child: const Icon(Icons.add, color: Colors.black,),
      ),
      appBar: AppBar(
        title: Text('Address', style: Theme.of(context).textTheme.headlineSmall),backgroundColor: Colors.blue,
      ),
      body:  const SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(Sizes.defoult),
          child: Column(
            children: [
              TSingAddress(
                icon: Icons.home ,
                title: 'ชื่อคน',
                subTitle: '18/0 ม.2 ต.ท่างิ้ว อ.บรรพตพิสัย จ.นครสวรรค์ 60180 ',
              ),
              SizedBox(height: 5,),
              TSingAddress(
                icon: Icons.home ,
                title: 'ชื่อคน',
                subTitle: '18/0 ม.2 ต.ท่างิ้ว อ.บรรพตพิสัย จ.นครสวรรค์ 60180 ',
              ),
            ],
          ),
        ),

      ),
    );
  }
}

class Sizes {
  static const double defoult = 20.0;
}