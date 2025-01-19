import 'package:flutter/material.dart';

import 'package:project_app/Page/login.dart';
import 'package:project_app/utils/BtnPage.dart';
import 'package:project_app/Page/BasePage.dart';
import 'package:project_app/utils/Orderhistory/Order_history.dart';
import 'package:project_app/utils/account_setting.dart';
import 'package:project_app/utils/address/address.dart';

import '../utils/userprofile/userprofile.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    @override
    Widget body = Scaffold(
      // appBar: AppBar(title: Text('Account', style: Theme.of(context).textTheme.displaySmall!.apply(color: Colors.black)),backgroundColor: Colors.blue,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            const Userprofile(),

            ///body
            Padding(
              padding: const EdgeInsets.all(Sizes.defoult),
              child: Column(
                children: [
                  ///account setting
                  const SizedBox(height: 20, ),
                  AccountSetting(
                    icon: Icons.home ,
                    title: 'ที่อยู่จัดส่ง',
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => UserAddress()));
                    },
                  ),

                  const SizedBox(height: 10, ),
                  AccountSetting(
                    icon: Icons.timer ,
                    title: 'ประวัติการซื้อของ',
                    onTap: (){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => OrderHistory()));
                    },
                  ),

                ],
              ),
            ),
            const SizedBox(height: 20, ),

            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => LoginPage()));
                },
                child: const Text('Logout', style: TextStyle(color: Colors.red)),
              ),
            )

          ],
        ),
      ),
    );
    return BasePage(body: body, index: 3);
  }
}