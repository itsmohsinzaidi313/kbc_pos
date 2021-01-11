class ResponseDetail {
  bool status;
  int userId;
  String message;

  ResponseDetail({this.status, this.message, this.userId});

  factory ResponseDetail.fromJson(dynamic json) => ResponseDetail(
      status: json['Status'] as bool, message: json['Message'] as String, userId: json['Data'] as int);
}
