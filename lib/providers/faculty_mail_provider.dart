import 'package:admin_panel_cui/model/mailModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FacultyMailProvider {
  static FacultyMailProvider instance = FacultyMailProvider();
  void getToken({
    required String email,
  }) {
    String token;

    FirebaseFirestore.instance.collection('registeredFacultyEmails').get().then(
      (value) {
        value.docs.forEach((element) {
          MailModel mailModel = MailModel.fromJson(element.data());
          token = mailModel.email;
          print(mailModel.email);
        });
      },
    );
  }
}
