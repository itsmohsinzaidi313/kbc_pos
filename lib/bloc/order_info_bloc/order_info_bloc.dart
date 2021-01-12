import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:kbc_pos/bloc/order_info_bloc/order_info_events.dart';
import 'package:kbc_pos/bloc/order_info_bloc/order_info_states.dart';
import 'package:kbc_pos/data_provider/order_info_repo/order_info_service.dart';
import 'package:kbc_pos/models/model_order_info/table_no.dart';
import 'package:kbc_pos/models/model_order_info/waiter.dart';
import 'package:kbc_pos/models/objects/location.dart';
import 'package:kbc_pos/models/objects/member.dart';
import 'package:kbc_pos/models/objects/session.dart';

class OrderInfoBloc extends Bloc<OrderInfoEvent, MyOrderInfoStates> {
  final OrderInfoRepo orderInfoRepo;

  List<Member> _membersList;
  List<Member> _selectedMembersList = [];
  List<DropdownMenuItem<Location>> _venueList;
  List<DropdownMenuItem<Session>> _sessionList;

  OrderInfoBloc({@required this.orderInfoRepo}) : super(MyOrderInfoStates());

  @override
  Stream<MyOrderInfoStates> mapEventToState(OrderInfoEvent event) async* {
    if (event is FetchingLists) {
      try {
        yield FetchingListInProgress();
        List<Location> location = await orderInfoRepo.getLocation();
        List<Session> session = await orderInfoRepo.getSession();
        locationMapListToDropdownMenuItemList(list: location);
        sessionMapListToDropdownMenuItemList(list: session);
        yield state.copyWith(
            venueList: _venueList,
            membersList: _membersList,
            sessionList: _sessionList,
            selectedLocation: location.first,
            selectedSession: session.first);
      } catch (e) {
        yield state.copyWith(
            status: FormzStatus.submissionFailure, error: e.toString());
      }
    } else if (event is AtPartyChanged) {
      yield state.copyWith(atParty: event.atParty);
    } else if (event is WithSpouseChanged) {
      yield state.copyWith(withSpouse: event.withSpouse);
    } else if (event is SelectedLocation) {
      yield state.copyWith(selectedLocation: event.location);
    } else if (event is SelectedSession) {
      yield state.copyWith(selectedSession: event.session);
    } else if (event is WaiterUnfocused) {
      final waiter = Waiter.dirty(state.waiter.value);
      yield state.copyWith(
          waiter: waiter, status: Formz.validate([waiter, state.tableNo]));
    } else if (event is TableNoUnfocused) {
      final tableNo = TableNo.dirty(state.tableNo.value);
      yield state.copyWith(
          tableNo: tableNo, status: Formz.validate([state.waiter, tableNo]));
    } else if (event is WaiterChanged) {
      final waiter = Waiter.dirty(event.waiter);
      yield state.copyWith(
          waiter: waiter.valid ? waiter : Waiter.pure(event.waiter),
          status: Formz.validate([waiter, state.tableNo]));
    } else if (event is TableNoChanged) {
      final tableNo = TableNo.dirty(event.tableNo);
      yield state.copyWith(
          tableNo: tableNo.valid ? tableNo : TableNo.pure(event.tableNo),
          status: Formz.validate([state.waiter, tableNo]));
    } else if (event is SelectedMember) {
      if(!_selectedMembersList.contains(event.member)){
        _selectedMembersList.add(event.member);
        yield state.copyWith(selectedMember: _selectedMembersList);
      }
     else{
        yield state.copyWith(error: 'Member Already Exist');
      }
    } else if(event is ByCodeChanged){
      yield state.copyWith(byCode: event.byCode, radioGroupValue: event.byCode);
    } else if(event is ByNameChanged){
      yield state.copyWith(byName: event.byName, radioGroupValue: event.byName);
    } else if(event is SearchTextChanged){
      try {
        _membersList = await orderInfoRepo.getMembers(event.text);
        yield state.copyWith(membersList: _membersList);
      } catch (e) {
        yield state.copyWith(error: e.toString());
        print(e.toString());
      }
    } else if(event is RemoveMember){
      _selectedMembersList.remove(event.member);
      yield state.copyWith(selectedMember: _selectedMembersList);
    } else if (event is OrderSubmitted) {
      final waiter = Waiter.dirty(state.waiter.value);
      final tableNo = TableNo.dirty(state.tableNo.value);
      yield state.copyWith(
        waiter: waiter,
        tableNo: tableNo,
        order: event.order,
        status: Formz.validate([waiter, tableNo],),
      );

      if (state.status.isValidated) {
        try {
          yield state.copyWith(status: FormzStatus.submissionInProgress);
          await Future<void>.delayed(
              Duration(
                seconds: 1,
              ), () async {
            await orderInfoRepo.insertOrderInfo();
          });
          final newState = state.copyWith(status: FormzStatus.submissionSuccess);
          yield newState;
        } catch (e) {
          final newSate = state.copyWith(
              status: FormzStatus.submissionFailure, error: e.toString());
          yield newSate;
        }
      }
    }
  }

  List<DropdownMenuItem<Location>> locationMapListToDropdownMenuItemList(
      {@required List<Location> list}) {
    _venueList = [];
    list.forEach((element) {
      _venueList.add(DropdownMenuItem(
        value: element,
        child: Text(element.locationName),
      ));
    });
    return _venueList;
  }

  List<DropdownMenuItem<Session>> sessionMapListToDropdownMenuItemList(
      {@required List<Session> list}) {
    _sessionList = [];
    list.forEach((element) {
      _sessionList.add(DropdownMenuItem(
        value: element,
        child: Text(element.sessionName),
      ));
    });
    return _sessionList;
  }
}
