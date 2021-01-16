import 'dart:convert';

class Session {

  static final String sesId = 'Id';
  static final String sesName = 'Name';
  static final String sesApplyDiscount = 'ApplyDiscount';

  final String sessionId;
  final bool sessionApplyDiscount;
  final String sessionName;

  const Session({this.sessionId, this.sessionApplyDiscount, this.sessionName});

  factory Session.fromJson(Map<String , dynamic> map) => Session(
    sessionId: map[sesId],
    sessionName: map[sesName],
    sessionApplyDiscount: map[sesApplyDiscount]
  );

  @override
  String toString() {
    return 'Session{sessionId: $sessionId, sessionApplyDiscount: $sessionApplyDiscount, sessionName: $sessionName}';
  }
}

List<Session> sessionListFromJson (String str) => List<Session>.from(json.decode(str)['Data'].map((x) => Session.fromJson(x)));
