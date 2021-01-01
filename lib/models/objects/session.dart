class Session {
  int sessionId, sessionApplyDiscount;
  String sessionName;

  Session({this.sessionId, this.sessionApplyDiscount, this.sessionName});

  @override
  String toString() {
    return 'Session{sessionId: $sessionId, sessionApplyDiscount: $sessionApplyDiscount, sessionName: $sessionName}';
  }
}
