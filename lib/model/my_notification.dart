class MyNotification {
  String? to;
  NotificationBody? notification;

  MyNotification({this.to, this.notification});

  MyNotification.fromJson(Map<String, dynamic> json) {
    to = json['to'];
    notification = json['notification'] != null
        ? NotificationBody.fromJson(json['notification'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['to'] = to;
    if (notification != null) {
      data['notification'] = notification!.toJson();
    }
    return data;
  }
}

class NotificationBody {
  String? body;
  String? title;

  NotificationBody({this.body, this.title});

  NotificationBody.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['body'] = body;
    data['title'] = title;
    return data;
  }
}
