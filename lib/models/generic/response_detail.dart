class ResponseDetail {
  bool status;
  int userId;
  String deviceKey;
  String message;

  ResponseDetail({this.status, this.message, this.userId, this.deviceKey});

  factory ResponseDetail.fromJson(dynamic json) => ResponseDetail(
      status: json['Status'] as bool,
      message: json['Message'] as String,
      userId: json['Data'] as int);
}
