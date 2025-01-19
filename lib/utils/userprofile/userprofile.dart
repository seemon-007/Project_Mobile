import 'package:flutter/material.dart';


import '../profile/body_profile.dart';

class Userprofile extends StatelessWidget {
  const Userprofile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        height: 50,
        width: 50,
        child: CircleAvatar(backgroundImage: AssetImage('assetName')),
      ),
      title: Text('ชื่อ', style: Theme.of(context).textTheme.headlineSmall!.apply(color: Colors.black),),
      subtitle: Text('อีเมล', style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.black),),
      trailing: IconButton(onPressed: () {Navigator.push(
          context, MaterialPageRoute(builder: (_) => BodyProfile()));},
          icon: const Icon(Icons.edit, color: Colors.black,)),
    );
  }
}