import 'package:flutter/cupertino.dart';
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
  List<Location> _venueList;
  List<Session> _sessionList;

  OrderInfoBloc({@required this.orderInfoRepo}) : super(MyOrderInfoStates());

  @override
  Stream<MyOrderInfoStates> mapEventToState(OrderInfoEvent event) async* {
    if (event is FetchingLists) {
      try {
        yield FetchingListInProgress();
        _membersList = await orderInfoRepo.getMembers();
        _venueList = await orderInfoRepo.getVenue();
        _sessionList = await orderInfoRepo.getSession();
        yield FetchingListSuccessful();
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
  }
}
