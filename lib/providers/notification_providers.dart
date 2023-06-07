import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:admin_panel_cui/model/my_notification.dart';
import 'package:admin_panel_cui/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationProvider {
  static NotificationProvider instance = NotificationProvider();

  void getToken(
      {required String title, required String text, required String to}) {
    String? token;

    FirebaseFirestore.instance
        .collection('registered-users')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        UserModel userModel = UserModel.fromJson(element.data());
        if (userModel.noticeNotification == true) {
          if (userModel.role == to.toLowerCase() || to.toLowerCase() == 'all') {
            token = userModel.token;

            sendNotification(token, title, text);
          }
        }
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
}
