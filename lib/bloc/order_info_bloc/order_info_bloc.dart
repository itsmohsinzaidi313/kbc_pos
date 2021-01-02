import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kbc_pos/bloc/order_info_bloc/order_info_events.dart';
import 'package:kbc_pos/bloc/order_info_bloc/order_info_states.dart';
import 'package:kbc_pos/data_provider/order_info_repo/order_info_service.dart';
import 'package:kbc_pos/models/objects/location.dart';
import 'package:kbc_pos/models/objects/member.dart';
import 'package:kbc_pos/models/objects/session.dart';

class OrderInfoBloc extends Bloc<OrderInfoEvent, MyOrderInfoStates> {
  final OrderInfoRepo orderInfoRepo;

  List<Member> _membersList;
  List<DropdownMenuItem<Location>> _venueList;
  List<DropdownMenuItem<Session>> _sessionList;

  OrderInfoBloc({@required this.orderInfoRepo}) : super(MyOrderInfoStates());

  @override
  Stream<MyOrderInfoStates> mapEventToState(OrderInfoEvent event) async* {
    if (event is FetchingLists) {
      try {
        yield FetchingListInProgress();
        _membersList = await orderInfoRepo.getMembers();
        List<Location> location = await orderInfoRepo.getLocation();
        List<Session> session = await orderInfoRepo.getSession();
        locationMapListToDropdownMenuItemList(list: location);
        sessionMapListToDropdownMenuItemList(list: session);
        yield state.copyWith(venueList: _venueList, membersList: _membersList,
            sessionList: _sessionList, selectedLocation: location.first, selectedSession: session.first);
        // yield FetchingListSuccessful();
      } catch (e) {
        yield FetchingListFailed(error: e.toString());
      }
    } else if (event is SearchByCodeChanged) {
      yield state.copyWith(
          byCode: event.byCode,
          radioGroupValue: event.byCode,
          hintText: 'Search Member By Code');
    } else if (event is SearchByNameChanged) {
      yield state.copyWith(
          byName: event.byName,
          radioGroupValue: event.byName,
          hintText: 'Search Member By Name');
    } else if (event is AtPartyChanged) {
      yield state.copyWith(atParty: event.atParty);
    } else if (event is WithSpouseChanged) {
      yield state.copyWith(atParty: event.withSpouse);
    } else if (event is OrderSubmitted) {}
    else if (event is SelectedLocation){
      yield state.copyWith(selectedLocation: event.location);
    } else if (event is SelectedSession){
      yield state.copyWith(selectedSession: event.session);
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
