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
    // print(facultyMail.email);
    reference.delete().then((_) {
      loadMails();
    });
  }

  void loadMails() {
    setState(() {
      isLoading = true;
    });
    List<MailModel> tempEmails = [];
    FirebaseFirestore.instance
        .collection("registeredFacultyEmails")
        .get()
        .then((mails) {
      mails.docs.forEach((element) {
        MailModel user = MailModel.fromJson(element.data());
        tempEmails.add(user);
      });
      emails = tempEmails;
      // print(emails.first.email);
      setState(() {
        isLoading = false;
      });
    });
  }

  void addMail(MailModel facultyMail) async {
    final reference = FirebaseFirestore.instance
        .collection('registeredFacultyEmails')
        .doc(facultyMail.email);
    // print(facultyMail.email);
    reference.set(facultyMail.toJson());
    _controller.clear();
    setState(() {});
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
        body: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.1),
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
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width * 0.04, vertical: 4),
                decoration: BoxDecoration(
                    color: Palette.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Palette.cuiPurple.withOpacity(0.25),
                        blurRadius: 8.0,
                        offset: const Offset(0.0, 2.0),
                      ),
                    ]),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        // onChanged: (value) => _runFilter(value),
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.cuiPurple),
                        onPressed: () {
                          print("this is ${_controller.text}");
                          addMail(MailModel(
                            email: _controller.text,
                          ));
                          loadMails();
                        },
                        child: Text("Add")),
                  ],
                ),
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.03,
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Palette.cuiPurple,
                      ),
                    )
                  : Expanded(
                      child: emails.length > 0
                          ? ListView.builder(
                              itemCount: emails.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                      color: Palette.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Palette.cuiPurple
                                                .withOpacity(0.25),
                                            offset: Offset(0, 2),
                                            blurRadius: 5,
                                            spreadRadius: 1)
                                      ],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                      // tileColor: Palette.white,
                                      // contentPadding: EdgeInsets.all(10),
                                      leading: const Icon(Icons.email_rounded),
                                      trailing: ElevatedButton(
                                        style: ButtonStyle(
                                            elevation:
                                                MaterialStatePropertyAll(5),
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    Palette.redAccent)),
                                        onPressed: () {
                                          removeMail(MailModel(
                                            email: emails[index].email,
                                          ));
                                          emails.remove(emails[index]);
                                        },
                                        child: Text('Delete'),
                                      ),
                                      title: Text(emails[index].email)),
                                );
                              },
                            )
                          : Center(
                              child: Text(
                                'No Emails right now!',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                    )
            ])));
  }
}
