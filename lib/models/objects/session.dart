class Session {
  final int sessionId, sessionApplyDiscount;
  final String sessionName;

  const Session({this.sessionId, this.sessionApplyDiscount, this.sessionName});

  @override
  String toString() {
    return 'Session{sessionId: $sessionId, sessionApplyDiscount: $sessionApplyDiscount, sessionName: $sessionName}';
  }
}
