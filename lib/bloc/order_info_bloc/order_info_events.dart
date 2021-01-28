import 'package:flutter/material.dart';
import 'package:kbc_pos/models/objects/location.dart';
import 'package:kbc_pos/models/objects/member.dart';
import 'package:kbc_pos/models/objects/order.dart';
import 'package:kbc_pos/models/objects/session.dart';

abstract class OrderInfoEvent {

  const OrderInfoEvent();
}

class FetchingLists extends OrderInfoEvent{}

class SelectedMember extends OrderInfoEvent{

  final Member member;
  SelectedMember({ @required this.member});
}

class SelectedLocation extends OrderInfoEvent{

  final Location location;
  SelectedLocation({ this.location});
}

class SelectedSession extends OrderInfoEvent{

  final Session session;
  SelectedSession({ this.session});
}


class AtPartyChanged extends OrderInfoEvent{

  final bool atParty;
  AtPartyChanged({ this.atParty});
}

class WithSpouseChanged extends OrderInfoEvent{

  final bool withSpouse;
  WithSpouseChanged({ this.withSpouse});

}

class WaiterChanged extends OrderInfoEvent{

  final String waiter;
  const WaiterChanged({ this.waiter});
}

class CoverChanged extends OrderInfoEvent{

  final String cover;
  const CoverChanged({ this.cover});
}

class TableNoChanged extends OrderInfoEvent{

  final String tableNo;
  const TableNoChanged({ this.tableNo});
}

class ByCodeChanged extends OrderInfoEvent{

  final String byCode;
  const ByCodeChanged({ this.byCode});
}

class ByNameChanged extends OrderInfoEvent{

  final String byName;
  const ByNameChanged({ this.byName});
}

class SearchTextChanged extends OrderInfoEvent{

  final String text;
  const SearchTextChanged({ this.text});
}

class RemoveMember extends OrderInfoEvent{
  final Member member;
  RemoveMember({this.member});
}

class WaiterUnfocused extends OrderInfoEvent{}

class TableNoUnfocused extends OrderInfoEvent{}

class CoverUnfocused extends OrderInfoEvent{}

class OrderSubmitted extends OrderInfoEvent{
  final Order order;
  OrderSubmitted({ this.order});
}

class OrderEditing extends OrderInfoEvent{
  final Order order;
  OrderEditing({this.order});
}

