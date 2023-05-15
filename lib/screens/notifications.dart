import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:admin_panel_cui/model/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel_cui/screens/side_drawer.dart';
import 'package:file_picker/file_picker.dart';
import '../model/my_notification.dart';
import '../model/user_model.dart';
import '../style/colors.dart';

class NotificationPanel extends StatefulWidget {
  static const routeName = '/notification-screen';

  const NotificationPanel({super.key});

  @override
  State<NotificationPanel> createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _titleController = TextEditingController();

  String notificationType = "notification";
  bool isNotification = true;
  FilePickerResult? result;
  Uint8List? uploadFile;
  void getToken({required String title, required String text}) {
    String? token;

    FirebaseFirestore.instance
        .collection('registered-users')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        UserModel userModel = UserModel.fromJson(element.data());
        print(userModel.token);
        token = userModel.token;
        sendNotification(token, title, text);
      });
    });

    // token = snapshot.docs.first.id;

    // print(token);
  }

  void sendNotification(String? token, String? title, String? body) {
    createNotification(MyNotification(
        to: token, notification: NotificationBody(title: title, body: body)));
  }

  Future<bool> createNotification(MyNotification notification) async {
    try {
      // print(order.billing!.firstName);
      final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      // var fbody = notification.toJson();
      // print(fbody);
      final body = jsonEncode(notification.toJson());
      // print(body);
      final response = await http.post(url, body: body, headers: {
        "Content-Type": "application/json",
        "Authorization":
            "key =AAAA4wmJZQk:APA91bF0s_ccic5EdZZl_Pd39YOOnHRzYnr5A7IupsPvMNy3ERpAUHTRPZfHjeQjkmFZqfHomXEbUiIto9ItvQ2Yc_VMtUjyFk98xv6X8htx3fUQCOyY4vquerz9FS75391KIehSBHOn"
      });

      if (response.statusCode == 201) {
        print('done');
        return true;
      }
      print(response.body);
    } catch (e) {
      print(e);
    }
    return false;
  }

  void uploadNotification(NotificationModel notification) async {
    print(notification.notificationText);
    if (uploadFile != null) {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('notifications')
          .child(result!.files.first.name);

      final UploadTask uploadTask = storageRef.putData(uploadFile!);

      final TaskSnapshot downloadUrl = await uploadTask;

      final String attchurl = (await downloadUrl.ref.getDownloadURL());
      print(attchurl);

      notification.fileUrl = attchurl;
      notification.fileName = result!.files.first.name;
    }

    final reference =
        FirebaseFirestore.instance.collection('notifications').doc();
    notification.notificationId = reference.id;
    reference.set(notification.toJson()).then((value) {
      getToken(title: _titleController.text, text: _descriptionController.text);
      _titleController.clear();
      _descriptionController.clear();
      uploadFile = null;
      result = null;
      setState(() {});
    });
  }

//FirebaseStorage storage = FirebaseStorage.instance;
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
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
            Container(
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 30),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                        width: mediaQuery.size.width * 0.11,
                        child: RadioListTile(
                            activeColor: Palette.cuiPurple,
                            title: Text("Notification"),
                            value: "notification",
                            groupValue: notificationType,
                            onChanged: (newValue) {
                              setState(() {
                                notificationType = newValue!;
                              });
                            })),
                    Container(
                      width: mediaQuery.size.width * 0.15,
                      child: RadioListTile(
                          activeColor: Palette.cuiPurple,
                          title: Text("Public Notice Board"),
                          value: "public notice board",
                          groupValue: notificationType,
                          onChanged: (newValue) {
                            setState(() {
                              notificationType = newValue!;
                            });
                          }),
                    ),
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: mediaQuery.size.width * 0.5,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Palette.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      controller: _titleController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          floatingLabelStyle:
                              TextStyle(color: Palette.cuiPurple),
                          labelText: "Notification title",
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: _descriptionController,
                      decoration: InputDecoration(
                          floatingLabelStyle:
                              TextStyle(color: Palette.cuiPurple),
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          focusColor: Palette.white,
                          labelText: "Notification text",
                          hintText: "Enter notification text"),
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      width: mediaQuery.size.width * 0.13,
                      height: mediaQuery.size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Palette.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton.icon(
                          onPressed: () async {
                            result = await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                            );
                            uploadFile = result!.files.first.bytes;
                            if (result == null) {
                              print("No file selected");
                            } else {
                              setState(() {});
                              result?.files.forEach((element) {
                                print(element.name);
                              });
                            }
                          },
                          label: Text(
                            'Upload File',
                            style: TextStyle(color: Palette.cuiPurple),
                          ),
                          icon: Icon(
                            Icons.add,
                            color: Palette.cuiPurple,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: mediaQuery.size.width * 0.1,
                        child: Column(
                          children: [
                            const Text(
                              'Selected file:',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            if (result != null)
                              Text(result?.files.single.name ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ))
                            else
                              Text(
                                  result != null
                                      ? result!.files.first.name
                                      : 'none',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ))
                          ],
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      width: mediaQuery.size.width * 0.1,
                      height: mediaQuery.size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Palette.white,
                      ),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Palette.cuiPurple)),
                          onPressed: () {
                            uploadNotification(NotificationModel(
                                notificationId: "",
                                createdAt: DateTime.now().toIso8601String(),
                                fileUrl: null,
                                fileName: null,
                                notificationTitle: _titleController.text,
                                notificationText: _descriptionController.text));
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Publishing'),
                                  backgroundColor: Palette.cuiPurple,
                                  duration: Duration(
                                    milliseconds: 400,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text("Publish")))
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
