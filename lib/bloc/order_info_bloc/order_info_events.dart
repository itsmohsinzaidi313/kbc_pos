import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kbc_pos/models/objects/location.dart';
import 'package:kbc_pos/models/objects/member.dart';
import 'package:kbc_pos/models/objects/session.dart';

abstract class OrderInfoEvent extends Equatable{

  const OrderInfoEvent();

  @override
  List<Object> get props => [];
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

  @override
  List<Object> get props => [atParty];
}

class WithSpouseChanged extends OrderInfoEvent{

  final bool withSpouse;
  WithSpouseChanged({ this.withSpouse});

  @override
  List<Object> get props => [withSpouse];
}

class WaiterChanged extends OrderInfoEvent{

  final String waiter;
  const WaiterChanged({ this.waiter});
}

class TableNoChanged extends OrderInfoEvent{

  final String tableNo;
  const TableNoChanged({ this.tableNo});
}

class WaiterUnfocused extends OrderInfoEvent{}

class TableNoUnfocused extends OrderInfoEvent{}

class OrderSubmitted extends OrderInfoEvent{}

