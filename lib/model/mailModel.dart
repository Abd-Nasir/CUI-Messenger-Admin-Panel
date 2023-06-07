import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MailModel with ChangeNotifier {
  late String email;

  MailModel({
    required this.email,
  });
  MailModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    late Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;

    return data;
  }

  static MailModel getValuesFromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return MailModel(
      email: snap['email'],
    );
  }
}
