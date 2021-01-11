import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:kbc_pos/models/model_order_info/table_no.dart';
import 'package:kbc_pos/models/model_order_info/waiter.dart';
import 'package:kbc_pos/models/objects/location.dart';
import 'package:kbc_pos/models/objects/member.dart';
import 'package:kbc_pos/models/objects/session.dart';

class MyOrderInfoStates extends Equatable {
  final List<Member> membersList;
  final List<DropdownMenuItem<Location>> locationList;
  final List<DropdownMenuItem<Session>> sessionList;
  final String error;
  final bool withSpouse;
  final bool atParty;
  final Location selectedLocation;
  final Session selectedSession;
  final FormzStatus status;
  final Waiter waiter;
  final TableNo tableNo;
  final Member selectedMember;

  MyOrderInfoStates(
      {this.membersList = const [],
      this.locationList = const [],
      this.sessionList = const [],
      this.error = '',
      this.withSpouse = false,
      this.atParty = false,
      this.selectedLocation = const Location(),
      this.selectedSession = const Session(),
      this.status = FormzStatus.pure,
      this.waiter = const Waiter.pure(),
      this.tableNo = const TableNo.pure(),
      this.selectedMember = const Member()
      });

  MyOrderInfoStates copyWith(
      {List<Member> membersList,
      List<DropdownMenuItem<Location>> venueList,
      List<DropdownMenuItem<Session>> sessionList,
      String error,
      String hintText,
      bool withSpouse,
      bool atParty,
      String byCode,
      String byName,
      String radioGroupValue,
      Location selectedLocation,
      Session selectedSession,
      Waiter waiter,
      TableNo tableNo,
      Member selectedMember,
      FormzStatus status}) {
    return MyOrderInfoStates(
        membersList: membersList ?? this.membersList,
        locationList: venueList ?? this.locationList,
        sessionList: sessionList ?? this.sessionList,
        error: error ?? this.error,
        status: status ?? this.status,
        atParty: atParty ?? this.atParty,
        selectedLocation: selectedLocation ?? this.selectedLocation,
        selectedSession: selectedSession ?? this.selectedSession,
        withSpouse: withSpouse ?? this.withSpouse,
        waiter: waiter ?? this.waiter,
        tableNo: tableNo ?? this.tableNo,
        selectedMember: selectedMember ?? this.selectedMember
    );
  }

  @override
  List<Object> get props => [
        membersList,
        locationList,
        sessionList,
        error,
        status,
        atParty,
        selectedLocation,
        selectedSession,
        withSpouse,
        waiter,
        tableNo,
        selectedMember
      ];
}

class FetchingListInProgress extends MyOrderInfoStates {}
