import 'dart:html';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel_cui/screens/side_drawer.dart';
import 'package:file_picker/file_picker.dart';
import '../style/colors.dart';
import 'dart:io' as io;

class NotificationPanel extends StatefulWidget {
  static const routeName = '/notification-screen';

  const NotificationPanel({super.key});

  @override
  State<NotificationPanel> createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel> {
  TextEditingController descriptionController = TextEditingController();
  String? not_type = "public";
  FilePickerResult? result;
  Uint8List? uploadFile;

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
              // color: Palette.white,
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 30),
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        width: mediaQuery.size.width * 0.1,
                        child: RadioListTile(
                            activeColor: Palette.cuiPurple,
                            title: Text("Public"),
                            value: "public",
                            groupValue: not_type,
                            onChanged: (newValue) {
                              setState(() {
                                not_type = newValue;
                              });
                            }),
                      ),
                      Container(
                        width: mediaQuery.size.width * 0.1,
                        child: RadioListTile(
                            activeColor: Palette.cuiPurple,
                            title: Text("Private"),
                            value: "private",
                            groupValue: not_type,
                            onChanged: (newValue) {
                              setState(() {
                                not_type = newValue;
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
                            floatingLabelStyle:
                                TextStyle(color: Palette.cuiPurple),
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            focusColor: Palette.white,
                            labelText: 'Notification text',
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
                              if (result != null) {
                                uploadFile = result!.files.single.bytes!;
                              }
                              setState(() {});
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Palette.cuiPurple)),
                            onPressed: () async {
                              Reference storageRef = FirebaseStorage.instance
                                  .ref()
                                  .child('notifications')
                                  .child(result!.files.first.name);
                              final UploadTask uploadTask =
                                  storageRef.putData(uploadFile!);

                              final TaskSnapshot downloadUrl = await uploadTask;

                              final String attchurl =
                                  (await downloadUrl.ref.getDownloadURL());
                              print(attchurl);
                              // String? filePath = result!.files.first.path;
                              // String? fileName = result!.files.first.name;
                              // // Upload file
                              // final ref = FirebaseStorage.instance
                              //     .ref()
                              //     .child('uploads')
                              //     .child('$fileName');
                              // print(ref.fullPath);
                              // await ref.putFile(io.File(filePath!));
                              // final url = await ref.getDownloadURL();
                              // print(url);
                              // if (result == null) {
                              //   print("No file selected");
                              // } else {
                              //   setState(() {});
                              //   result?.files.forEach((element) {
                              //     print(element.name);
                              //   }
                              //   );
                              // }
                            },
                            child: Text("Publish")))
                  ]),
            ),
          ]),
        ),
      ),
    );
  }
}
