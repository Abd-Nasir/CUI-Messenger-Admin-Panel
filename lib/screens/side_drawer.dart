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
          accountName: Text('Noor Fatima'),
          accountEmail: Text('FA19-BSE-089@cuiwah.edu.pk'),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              "N",
              style: TextStyle(fontSize: 40.0, color: Colors.purple),
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
            Navigator.of(context).pushReplacementNamed('/notification-screen');
          },
          title: Text("Notifications"),
          trailing: Icon(
            Icons.notifications,
            color: Palette.cuiPurple,
          ),
        ),
      ],
    ));
  }
}
