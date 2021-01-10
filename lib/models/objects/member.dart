
import 'dart:convert';

class Member{

  static final String mCode = 'MemberCode';
  static final String mStatus = 'Status';
  static final String mName = 'Name';
  static final String mYear = 'Year';

  final int memberId;
  final String memberNo, memberType, memberStatus, memberName;
  final String memberElectDate, memberBirthDate;

  const Member(
      { this.memberId,
       this.memberNo,
       this.memberType,
       this.memberStatus, this.memberName, this.memberElectDate, this.memberBirthDate});

  factory Member.fromJson(Map<String, dynamic> json) =>
      Member(
        memberNo: json[mCode],
        memberName: json[mName],
        memberStatus: json[mStatus],
        memberElectDate: json[mYear]
      );

  Map<String, dynamic> toJson() => {
    mCode : memberNo,
    mName : memberName,
    mStatus : memberStatus,
    mYear : memberElectDate
  };

  @override
  String toString() {
    return 'Member{memberId: $memberId, memberNo: $memberNo, memberType: $memberType, memberStatus: $memberStatus, memberName: $memberName, memberElectDate: $memberElectDate, memberBirthDate: $memberBirthDate}';
  }
}

List<Member> memberListFromJson(String str) => List<Member>.from(json.decode(str)['Data'].map((x) => Member.fromJson(x)));