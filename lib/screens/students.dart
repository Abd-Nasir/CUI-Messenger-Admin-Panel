import 'package:admin_panel_cui/model/user_model.dart';
import 'package:admin_panel_cui/style/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import 'side_drawer.dart';

class StudentAdminPanel extends StatefulWidget {
  //static const routeName = '/students-screen';
  const StudentAdminPanel({super.key});

  @override
  State<StudentAdminPanel> createState() => _StudentAdminPanelState();
}

class _StudentAdminPanelState extends State<StudentAdminPanel> {
  bool isLoading = true;
  bool isChecked = false;
  var charLength;
  bool textFieldSelected = false;
  List multipleSelected = [];
  List<UserModel> students = [];
  List<UserModel> foundUsers = [];

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    setState(() {
      charLength = enteredKeyword.length;
      if (charLength < 1) {
        textFieldSelected = false;
      } else {
        textFieldSelected = true;
      }
    });
    List<UserModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = students;
    } else {
      results = students
          .where((user) =>
              user.regNo.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      foundUsers = results;
    });
  }

  void loadStudents() {
    FirebaseFirestore.instance
        .collection("registered-users")
        .get()
        .then((users) {
      users.docs.forEach((element) {
        UserModel user = UserModel.fromJson(element.data());
        if (user.role == 'student') {
          students.add(user);
        }
      });
      print(students.first.email);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    loadStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    // final studentData = StudentList().students;
    // final studentList =
    //     Provider.of<StudentList>(context, listen: false).students;
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
              padding:
                  EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.1),
              child: Column(
                children: [
                  SizedBox(height: mediaQuery.size.height * 0.02),
                  const Text(
                    'Students',
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
                    child: TextFormField(
                      onTap: () {
                        textFieldSelected = true;
                      },
                      onChanged: (value) => _runFilter(value),
                      // controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search by registeration number",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mediaQuery.size.height * 0.01,
                  ),
                  Expanded(
                    child: !textFieldSelected
                        ? ResponsiveGridList(
                            horizontalGridMargin: 50,
                            verticalGridMargin: 10,
                            minItemWidth: 300,
                            maxItemsPerRow: 5,
                            children: List.generate(students.length,
                                (index) => userCard(context, students[index])),
                          )
                        : ResponsiveGridList(
                            horizontalGridMargin: 50,
                            verticalGridMargin: 10,
                            minItemWidth: 300,
                            maxItemsPerRow: 5,
                            children: List.generate(
                                foundUsers.length,
                                (index) =>
                                    userCard(context, foundUsers[index])),
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget userCard(BuildContext context, UserModel _user) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            spreadRadius: 5,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Palette.hintGrey),
              color: Colors.white,
              borderRadius: BorderRadius.circular(100.0),
              boxShadow: [
                BoxShadow(
                    color: Palette.cuiPurple.withOpacity(0.15),
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 8.0)
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: _user.profilePicture != ""
                  ? CachedNetworkImage(
                      imageUrl: _user.profilePicture,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress)),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : const Icon(Icons.person_rounded),
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SelectableText(
                  '${_user.firstName} ${_user.lastName}',
                  style: TextStyle(
                      color: Palette.cuiPurple,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Reg No',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SelectableText(
                      _user.regNo.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Palette.cuiPurple,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Email: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      // width: 200,
                      child: SelectableText(
                        _user.email,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Palette.cuiPurple,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Contact No: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SelectableText(
                      _user.phoneNo,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Palette.cuiPurple,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: !_user.isRestricted
                              ? Palette.cuiPurple
                              : Palette.redAccent),
                      onPressed: () {
                        _user.isRestricted = !_user.isRestricted;
                        FirebaseFirestore.instance
                            .collection("registered-users")
                            .doc(_user.uid)
                            .set(_user.toJson());
                        setState(() {});
                      },
                      child: Text(
                          !_user.isRestricted ? 'Restrict User' : "Unrestrict"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
