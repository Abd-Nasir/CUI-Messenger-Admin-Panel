class PublicNoticeBoardModel {
  late String noticeId;
  late String createdAt;
  late String? fileUrl;
  late String? fileName;
  late String noticeTitle;
  late String noticeText;
  late String? fileType;

  PublicNoticeBoardModel({
    required this.noticeId,
    required this.createdAt,
    required this.fileUrl,
    required this.fileName,
    required this.noticeTitle,
    required this.noticeText,
    required this.fileType,
  });
  PublicNoticeBoardModel.fromJson(Map<String, dynamic> json) {
    noticeId = json['noticeId'];
    createdAt = json['createdAt'];
    fileUrl = json['fileUrl'];
    fileName = json['fileName'];
    noticeTitle = json['noticeTitle'];
    noticeText = json['noticeText'];
    fileType = json['file-type'];
  }
  Map<String, dynamic> toJson() {
    late Map<String, dynamic> data = <String, dynamic>{};
    data['noticeId'] = noticeId;
    data['createdAt'] = createdAt;
    data['fileUrl'] = fileUrl;
    data['fileName'] = fileName;
    data['noticeTitle'] = noticeTitle;
    data['noticeText'] = noticeText;
    data['file-type'] = fileType;
    return data;
  }
}
