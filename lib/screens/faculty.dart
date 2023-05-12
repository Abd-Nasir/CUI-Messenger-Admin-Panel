import 'package:admin_panel_cui/model/user_model.dart';
import 'package:admin_panel_cui/screens/side_drawer.dart';
import 'package:admin_panel_cui/style/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

// class Faculty {
//   late String email;
//   late String name;
//   late String image;
//   late bool value;
//   Faculty(
//       {required this.email,
//       required this.name,
//       required this.image,
//       this.value = false});
// }

// class FacultyList with ChangeNotifier {
//   List<Faculty> students = [
//     Faculty(
//         email: 'faisalshafiquebutt@ciit.edu.pk',
//         name: 'Dr. Faisal Shafique Butt',
//         value: false,
//         image:
//             "https://www.dlf.pt/dfpng/middlepng/247-2479526_round-profile-picture-png-transparent-png.png"),
//     Faculty(
//         email: 'faisalshafiquebutt@ciit.edu.pk',
//         name: 'Dr. Faisal Shafique Butt',
//         value: false,
//         image:
//             "https://www.pngmart.com/files/21/Account-Avatar-Profile-PNG-Photo.png"),
//     Faculty(
//         email: 'faisalshafiquebutt@ciit.edu.pk',
//         name: 'Dr. Faisal Shafique Butt',
//         value: false,
//         image:
//             "https://www.pngmart.com/files/21/Account-Avatar-Profile-PNG-Photo.png")
//   ];
// }

class FacultyAdminPanel extends StatefulWidget {
  static const routeName = '/faculty-screen';
  const FacultyAdminPanel({super.key});

  @override
  State<FacultyAdminPanel> createState() => _FacultyAdminPanelState();
}

class _FacultyAdminPanelState extends State<FacultyAdminPanel> {
  bool isLoading = true;
  bool isChecked = false;
  var charLength;
  bool textFieldSelected = false;
  List multipleSelected = [];
  List<UserModel> teachers = [];

  void loadTeachers() {
    FirebaseFirestore.instance
        .collection("registered-users")
        .get()
        .then((users) {
      users.docs.forEach((element) {
        UserModel user = UserModel.fromJson(element.data());
        if (user.role == 'faculty') {
          teachers.add(user);
        }
      });
      print(teachers.first.email);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    loadTeachers();
    // TODO: implement initState
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    setState(() {
      charLength = enteredKeyword.length;
      print(charLength);
      if (charLength < 1) {
        textFieldSelected = false;
      } else {
        textFieldSelected = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    // final studentData = FacultyList().students;
    // final studentList =
    //     Provider.of<FacultyList>(context, listen: false).students;
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
                  SizedBox(
                    height: mediaQuery.size.height * 0.1,
                  ),
                  const Text(
                    'Faculty',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          onTap: () {
                            textFieldSelected = true;
                          },
                          onChanged: (value) => _runFilter(value),
                          // controller: searchController,
                          decoration: InputDecoration(
                            prefixIcon: GestureDetector(
                                onTap: ((() {
                                  // onSearch();
                                  print('Search Pressed');
                                })),
                                child: const Icon(
                                  Icons.search,
                                  color: Palette.cuiPurple,
                                )),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide:
                                  const BorderSide(color: Palette.cuiPurple),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide:
                                  const BorderSide(color: Palette.cuiPurple),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(color: Palette.cuiPurple),
                            ),
                            filled: true,
                            hintStyle: const TextStyle(color: Colors.grey),
                            hintText: "Search User",
                            fillColor: Palette.cuiPurple.withOpacity(0.1),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Palette.cuiPurple)),
                          onPressed: () {},
                          child: const Text('Add')),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Palette.cuiPurple)),
                        onPressed: () {},
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => setState(() {
                            multipleSelected.clear();
                            for (var element in teachers) {
                              if (element.isSelected == false) {
                                element.isSelected = true;
                                multipleSelected.add(element);
                              } else {
                                element.isSelected = false;
                                multipleSelected.remove(element);
                              }
                            }
                          }),
                          child: const Text(
                            "Select All",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: teachers.length,
                            itemBuilder: (BuildContext context, index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CheckboxListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  checkboxShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  title: Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            teachers[index].profilePicture),
                                      ),
                                    ),
                                    Text(
                                      '${teachers[index].firstName} (${teachers[index].regNo})',
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ]),
                                  value: teachers[index].isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      teachers[index].isSelected = value!;
                                    });
                                  },
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
