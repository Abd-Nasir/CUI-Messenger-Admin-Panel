import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String uid;
  late String firstName;
  late String lastName;
  late String email;
  late String profilePicture;
  // late String location;
  late String token;
  late bool isOnline;
  late bool isInCall;
  late List blockList;
  late String role;
  late String regNo;
  late String phoneNo;
  bool? isSelected = false;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicture,
    // required this.location,
    required this.token,
    required this.isOnline,
    // required this.isInCall,
    required this.blockList,
    required this.role,
    required this.regNo,
    required this.phoneNo,
    this.isSelected,
  });
  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];

    firstName = json['first-name'];
    lastName = json['last-name'];
    email = json['email'];
    profilePicture = json["profile-picture"];
    token = json['token'];
    isOnline = json['isOnline'];
    blockList = json['blockList'];
    role = json["role"];
    // isInCall= json['']
    regNo = json['reg-no'];
    phoneNo = json['phone'];
    // dateOfBirth = json['date-of-birth'];
  }
  Map<String, dynamic> toJson() {
    late Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['first-name'] = firstName;
    data['last-name'] = lastName;
    data['email'] = email;
    data["profile-picture"] = profilePicture;
    data['token'] = token;
    data['isOnline'] = isOnline;
    data['bloackList'] = blockList;
    data["role"] = role;
    data['reg-no'] = regNo;
    data['phone'] = phoneNo;
    // data['date-of-birth'] = dateOfBirth;

    return data;
  }

  static UserModel getValuesFromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      uid: snap['uid'],
      firstName: snap['first-name'],
      lastName: snap['last-name'],
      email: snap['email'],
      profilePicture: snap['profile-picture'],
      token: snap['token'],
      isOnline: snap['isOnline'],
      blockList: snap['blockList'],
      role: snap['role'],
      regNo: snap['reg-no'],
      phoneNo: snap['phone'],
    );
  }
}
