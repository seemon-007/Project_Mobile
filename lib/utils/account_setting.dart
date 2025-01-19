import 'package:flutter/material.dart';

class AccountSetting extends StatelessWidget {
  const AccountSetting({
    super.key,
    required this.icon,
    required this.title,

    this.trailing,
    this.onTap
  });

  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 20, color: Colors.black,),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),

      trailing: trailing,
      onTap: onTap,
    );
  }
}