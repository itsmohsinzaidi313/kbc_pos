import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:kbc_pos/models/objects/location.dart';
import 'package:kbc_pos/models/objects/member.dart';
import 'package:kbc_pos/models/objects/session.dart';

class MyOrderInfoStates extends Equatable {
  final List<Member> membersList;
  final List<Location> locationList;
  final List<Session> sessionList;
  final String error;
  final String hintText;
  final bool withSpouse;
  final bool atParty;
  final String byCode;
  final String byName;
  final String radioGroupValue;
  final FormzStatus status;

  MyOrderInfoStates(
      {this.membersList = const [],
      this.locationList = const [],
      this.sessionList = const [],
      this.error = '',
      this.hintText = 'Search By Code',
      this.withSpouse = false,
      this.atParty = false,
      this.byCode = 'By Code',
      this.byName = 'By Name',
      this.radioGroupValue = 'By Code',
      this.status = FormzStatus.pure});

  MyOrderInfoStates copyWith(
      {List<Member> membersList,
      List<Location> venueList,
      List<Session> sessionList,
      String error,
      String hintText,
      bool withSpouse,
      bool atParty,
      String byCode,
      String byName,
      String radioGroupValue,
      FormzStatus status}) {
    return MyOrderInfoStates(
        membersList: membersList ?? this.membersList,
        locationList: venueList ?? this.locationList,
        sessionList: sessionList ?? this.sessionList,
        error: error ?? this.error,
        hintText: hintText ?? this.hintText,
        status: status ?? this.status,
        atParty: atParty ?? this.atParty,
        byCode: byCode ?? this.byCode,
        byName: byName ?? this.byName,
        radioGroupValue: radioGroupValue ?? this.radioGroupValue,
        withSpouse: withSpouse ?? this.withSpouse);
  }

  @override
  List<Object> get props => [
        membersList,
        locationList,
        sessionList,
        error,
        hintText,
        status,
        atParty,
        byCode,
        byName,
        radioGroupValue,
        withSpouse
      ];
}

class FetchingListInProgress extends MyOrderInfoStates {}

class FetchingListSuccessful extends MyOrderInfoStates {}

class FetchingListFailed extends MyOrderInfoStates {
  final String error;

  FetchingListFailed({this.error});
}
