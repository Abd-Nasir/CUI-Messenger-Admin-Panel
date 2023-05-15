class NotificationModel {
  late String notificationId;
  late String createdAt;
  late String? fileUrl;
  late String? fileName;
  late String notificationTitle;
  late String notificationText;

  NotificationModel({
    required this.notificationId,
    required this.createdAt,
    required this.fileUrl,
    required this.fileName,
    required this.notificationTitle,
    required this.notificationText,
  });
  NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['notificationId'];
    createdAt = json['createdAt'];
    fileUrl = json['fileUrl'];
    fileName = json['fileName'];
    notificationTitle = json['notificationTitle'];
    notificationText = json['notificationText'];
  }
  Map<String, dynamic> toJson() {
    late Map<String, dynamic> data = <String, dynamic>{};
    data['notificationId'] = notificationId;
    data['createdAt'] = createdAt;
    data['fileUrl'] = fileUrl;
    data['fileName'] = fileName;
    data['notificationTitle'] = notificationTitle;
    data['notificationText'] = notificationText;
    return data;
  }
}
