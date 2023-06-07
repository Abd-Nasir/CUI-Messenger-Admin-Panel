import 'package:admin_panel_cui/model/mailModel.dart';

import 'package:admin_panel_cui/providers/faculty_mail_provider.dart';
import 'package:admin_panel_cui/screens/side_drawer.dart';
import 'package:admin_panel_cui/style/colors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class FacultyEmail extends StatefulWidget {
  static const routeName = '/faculty-email-screen';
  const FacultyEmail({super.key});

  @override
  State<FacultyEmail> createState() => _FacultyEmailState();
}

class _FacultyEmailState extends State<FacultyEmail> {
  bool isLoading = true;
  bool textFieldSelected = false;
  List multipleSelected = [];
  List<MailModel> emails = [];
  List<MailModel> foundEmails = [];
  TextEditingController _controller = TextEditingController();

  void removeMail(MailModel facultyMail) async {
    final reference = FirebaseFirestore.instance
        .collection('registeredFacultyEmails')
        .doc(facultyMail.email);
    print(facultyMail.email);
    reference.delete().then((value) {
      FacultyMailProvider.instance.getToken(
        email: _controller.text,
      );
    });
  }

  void loadMails() {
    FirebaseFirestore.instance
        .collection("registeredFacultyEmails")
        .get()
        .then((users) {
      users.docs.forEach((element) {
        MailModel user = MailModel.fromJson(element.data());
        emails.add(user);
      });
      print(emails.first.email);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    loadMails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    // MailModel emails;

    return Scaffold(
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
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Palette.cuiPurple,
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width * 0.1),
                child: Column(children: [
                  SizedBox(height: mediaQuery.size.height * 0.02),
                  const Text(
                    'Faculty Mails',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: mediaQuery.size.height * 0.02,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: emails.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            leading: const Icon(Icons.email_rounded),
                            trailing: ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStatePropertyAll(5),
                                  backgroundColor: MaterialStatePropertyAll(
                                      Palette.redAccent)),
                              onPressed: () {
                                removeMail(MailModel(
                                  email: _controller.text,
                                ));
                              },
                              child: Text('Delete'),
                            ),
                            title: Text("List item $index"));
                      },
                    ),
                  )
                ])));
  }
}
