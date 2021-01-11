import 'package:flutter/material.dart';

class Member{

  final int memberId;
  final String memberNo, memberType, memberStatus, memberName;
  final String memberElectDate, memberBirthDate;

  const Member(
      { this.memberId,
       this.memberNo,
       this.memberType,
       this.memberStatus, this.memberName, this.memberElectDate, this.memberBirthDate});

  @override

  String toString() {
    return 'Member{memberId: $memberId, memberNo: $memberNo, memberType: $memberType, memberStatus: $memberStatus, memberName: $memberName, memberElectDate: $memberElectDate, memberBirthDate: $memberBirthDate}';
  }
}