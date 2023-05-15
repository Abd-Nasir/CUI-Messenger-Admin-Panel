class PublicNoticeBoardModel {
  late String noticeId;
  late String createdAt;
  late String? fileUrl;
  late String? fileName;
  late String noticeTitle;
  late String noticeText;

  PublicNoticeBoardModel({
    required this.noticeId,
    required this.createdAt,
    required this.fileUrl,
    required this.fileName,
    required this.noticeTitle,
    required this.noticeText,
  });
  PublicNoticeBoardModel.fromJson(Map<String, dynamic> json) {
    noticeId = json['notificationId'];
    createdAt = json['createdAt'];
    fileUrl = json['fileUrl'];
    fileName = json['fileName'];
    noticeTitle = json['notificationTitle'];
    noticeText = json['notificationText'];
  }
  Map<String, dynamic> toJson() {
    late Map<String, dynamic> data = <String, dynamic>{};
    data['notificationId'] = noticeId;
    data['createdAt'] = createdAt;
    data['fileUrl'] = fileUrl;
    data['fileName'] = fileName;
    data['notificationTitle'] = noticeTitle;
    data['notificationText'] = noticeText;
    return data;
  }
}
