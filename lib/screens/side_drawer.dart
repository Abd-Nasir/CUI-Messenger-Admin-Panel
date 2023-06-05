import 'package:flutter/material.dart';
import '../style/colors.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: <Widget>[
        const UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Palette.cuiPurple),
          accountName: Text(
            'Administrator',
          ),
          accountEmail: null,
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              "A",
              style: TextStyle(fontSize: 40.0, color: Palette.cuiPurple),
            ),
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed('/');
          },
          title: Text("Students"),
          trailing: Icon(
            Icons.school,
            color: Palette.cuiPurple,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/faculty-screen');
          },
          title: Text("Faculty"),
          trailing: Icon(
            Icons.people,
            color: Palette.cuiPurple,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/updates-screen');
          },
          title: Text("Updates"),
          trailing: Icon(
            Icons.update_outlined,
            color: Palette.cuiPurple,
          ),
        ),
      ],
    ));
  }
}
