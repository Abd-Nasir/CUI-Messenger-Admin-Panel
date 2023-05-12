import 'package:flutter/material.dart';
import 'package:admin_panel_cui/screens/side_drawer.dart';

import '../style/colors.dart';

class NotificationPanel extends StatefulWidget {
  static const routeName = '/notification-screen';

  const NotificationPanel({super.key});

  @override
  State<NotificationPanel> createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel> {
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Palette.aliceBlue,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'CUI MESSENGER',
          style: TextStyle(color: Colors.black),
        ),
      ),
      drawer: const SideDrawer(),
      body: Container(
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: mediaQuery.size.height * 0.1,
          ),
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SingleChildScrollView(
            child: Container(
              // color: Palette.white,
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 20),
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: mediaQuery.size.width * 0.5,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Palette.white,
                          // border: Border.all()
                          borderRadius: BorderRadius.circular(20)),
                      child: TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            floatingLabelStyle:
                                TextStyle(color: Palette.cuiPurple),
                            labelText: 'Notification title',
                            hintText: "Enter optional title"),
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: mediaQuery.size.width * 0.5,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Palette.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            focusColor: Palette.white,
                            labelText: 'Notification text',
                            hintText: "Enter notification text"),
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: null,
                      ),
                    ),
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}
