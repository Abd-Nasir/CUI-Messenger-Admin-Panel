import 'package:admin_panel_cui/model/notification_model.dart';
import 'package:admin_panel_cui/providers/notification_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel_cui/screens/side_drawer.dart';
import 'package:file_picker/file_picker.dart';
import '../model/public_model.dart';
import '../style/colors.dart';

class NotificationPanel extends StatefulWidget {
  static const routeName = '/updates-screen';

  const NotificationPanel({super.key});

  @override
  State<NotificationPanel> createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _titleController = TextEditingController();

  String? _selectedItem = "All";

  final List<String> _items = [
    'All',
    'Student',
    'Faculty',
  ];

  int selectedRadioTile = 1;

  FilePickerResult? result;
  Uint8List? uploadFile;

  void uploadNotification(NotificationModel notification) async {
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
      notification.fileType = result!.files.first.extension;
    }

    final reference =
        FirebaseFirestore.instance.collection('notifications').doc();
    notification.notificationId = reference.id;
    reference.set(notification.toJson()).then((value) {
      NotificationProvider.instance.getToken(
          title: _titleController.text,
          text: _descriptionController.text,
          to: _selectedItem!);

      _titleController.clear();
      _descriptionController.clear();
      _selectedItem = "All";
      uploadFile = null;
      result = null;
      setState(() {});
    });
  }

  void uploadNotice(PublicNoticeBoardModel notice) async {
    if (uploadFile != null) {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('notices')
          .child(result!.files.first.name);

      final UploadTask uploadTask = storageRef.putData(uploadFile!);

      final TaskSnapshot downloadUrl = await uploadTask;

      final String attchurl = (await downloadUrl.ref.getDownloadURL());
      print(attchurl);

      notice.fileUrl = attchurl;
      notice.fileName = result!.files.first.name;
      notice.fileType = result!.files.first.extension;
    }

    final reference =
        FirebaseFirestore.instance.collection('public-noticeboard').doc();
    notice.noticeId = reference.id;
    reference.set(notice.toJson()).then((value) {
      NotificationProvider.instance.getToken(
          to: 'all',
          title: 'Noticeboard has a new notification',
          text: _titleController.text);
      _titleController.clear();
      _descriptionController.clear();
      uploadFile = null;
      result = null;
      setState(() {});
    });
  }

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
        child: Padding(
          padding: const EdgeInsets.only(
            left: 250,
            right: 250,
            top: 40,
          ),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: Palette.hintGrey)),
            width: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: mediaQuery.size.height * 0.03,
                  ),
                  Text(
                    'Updates',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(
                    endIndent: 400,
                    indent: 400,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: mediaQuery.size.height * 0.3,
                                  child: RadioListTile(
                                      activeColor: Palette.cuiPurple,
                                      title: Text(
                                        "Notification",
                                        style: TextStyle(
                                          fontSize:
                                              mediaQuery.size.height * 0.02,
                                        ),
                                      ),
                                      value: 1,
                                      groupValue: selectedRadioTile,
                                      onChanged: (newValue) {
                                        print(newValue);
                                        setState(() {
                                          selectedRadioTile = newValue!;
                                        });
                                      })),
                              Container(
                                width: mediaQuery.size.height * 0.3,
                                child: RadioListTile(
                                    activeColor: Palette.cuiPurple,
                                    title: Text("Public Notice Board",
                                        style: TextStyle(
                                          fontSize:
                                              mediaQuery.size.height * 0.02,
                                        )),
                                    value: 2,
                                    groupValue: selectedRadioTile,
                                    onChanged: (newValue) {
                                      print(newValue);
                                      setState(() {
                                        selectedRadioTile = newValue!;
                                      });
                                    }),
                              ),
                            ]),
                        SizedBox(
                          height: mediaQuery.size.height * 0.03,
                        ),
                        if (selectedRadioTile == 1)
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              buttonStyleData: ButtonStyleData(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 0.5,
                                      color: Palette.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.all(5),
                                  height: mediaQuery.size.height * 0.05,
                                  width: mediaQuery.size.width * 0.08),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.5, color: Palette.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                maxHeight: mediaQuery.size.height * 0.2,
                              ),
                              isExpanded: true,
                              items: _items
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            //color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: _selectedItem,
                              onChanged: (value) {
                                setState(() {
                                  _selectedItem = value as String;
                                });
                              },
                            ),
                          ),
                        SizedBox(
                          height: mediaQuery.size.height * 0.03,
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
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                floatingLabelStyle:
                                    TextStyle(color: Palette.cuiPurple),
                                labelText: selectedRadioTile == 1
                                    ? "Notification title"
                                    : "Notice title",
                                hintText: "Enter optional title"),
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: null,
                          ),
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.03),
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
                                labelText: selectedRadioTile == 1
                                    ? "Notification text"
                                    : "Notice Text",
                                hintText: selectedRadioTile == 1
                                    ? "Enter notification text"
                                    : "Enter notice text"),
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: null,
                          ),
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.03),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: mediaQuery.size.width * 0.13,
                                height: mediaQuery.size.height * 0.05,
                                decoration: BoxDecoration(
                                  color: Palette.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextButton.icon(
                                    onPressed: () async {
                                      result =
                                          await FilePicker.platform.pickFiles(
                                        allowedExtensions: [
                                          "pdf",
                                          'jpg',
                                          'jpeg',
                                          ''
                                        ],
                                        type: FileType.custom,
                                        allowMultiple: false,
                                      );
                                      uploadFile = result!.files.first.bytes;

                                      if (result == null) {
                                        print("No file selected");
                                      } else {
                                        setState(() {});
                                      }
                                    },
                                    label: Text(
                                      'Upload File',
                                      style:
                                          TextStyle(color: Palette.cuiPurple),
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
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
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
                          height: mediaQuery.size.height * 0.03,
                        ),
                        Container(
                            width: selectedRadioTile == 1
                                ? mediaQuery.size.width * 0.08
                                : mediaQuery.size.width * 0.1,
                            height: mediaQuery.size.height * 0.05,
                            decoration: BoxDecoration(
                              color: Palette.white,
                            ),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Palette.cuiPurple)),
                                onPressed: () {
                                  if (selectedRadioTile == 1) {
                                    uploadNotification(NotificationModel(
                                        notificationId: "",
                                        createdAt:
                                            DateTime.now().toIso8601String(),
                                        fileUrl: null,
                                        fileName: null,
                                        notificationTitle:
                                            _titleController.text,
                                        notificationText:
                                            _descriptionController.text,
                                        fileType: null));
                                  } else {
                                    uploadNotice(PublicNoticeBoardModel(
                                        noticeId: "",
                                        createdAt:
                                            DateTime.now().toIso8601String(),
                                        fileUrl: null,
                                        fileName: null,
                                        noticeTitle: _titleController.text,
                                        noticeText: _descriptionController.text,
                                        fileType: null));
                                  }

                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Publishing'),
                                        backgroundColor: Palette.cuiPurple,
                                        duration: Duration(
                                          seconds: 1,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: selectedRadioTile == 1
                                    ? Text("Send")
                                    : Text("Publish"))),
                        SizedBox(
                          height: mediaQuery.size.height * 0.03,
                        ),
                      ]),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
