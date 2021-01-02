import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:kbc_pos/models/objects/location.dart';
import 'package:kbc_pos/models/objects/member.dart';
import 'package:kbc_pos/models/objects/session.dart';

abstract class OrderInfoEvent extends Equatable{

  const OrderInfoEvent();

  @override
  List<Object> get props => [];
}

class FetchingLists extends OrderInfoEvent{

}

class InsertOrderInfo extends OrderInfoEvent{

}

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

class SearchByCodeChanged extends OrderInfoEvent{

  final String byCode;
  SearchByCodeChanged({ this.byCode});

  @override
  List<Object> get props => [byCode];
}

class SearchByNameChanged extends OrderInfoEvent{

  final String byName;
  SearchByNameChanged({ this.byName});

  @override
  List<Object> get props => [byName];
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

class OrderSubmitted extends OrderInfoEvent{

}