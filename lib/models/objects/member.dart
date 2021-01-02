import 'package:flutter/material.dart';

class Member{

  int memberId;
  String memberNo, memberType, memberStatus, memberName;
  String memberElectDate, memberBirthDate;

  Member(
      {@required this.memberId,
      @required this.memberNo,
      @required this.memberType,
      @required this.memberStatus,
      @required this.memberName, this.memberElectDate, this.memberBirthDate});

  @override

  String toString() {
    return 'Member{memberId: $memberId, memberNo: $memberNo, memberType: $memberType, memberStatus: $memberStatus, memberName: $memberName, memberElectDate: $memberElectDate, memberBirthDate: $memberBirthDate}';
  }
}