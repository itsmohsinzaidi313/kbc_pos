import 'dart:convert';

import 'package:kbc_pos/models/objects/item.dart';
import 'package:kbc_pos/models/objects/member.dart';

class Order {

  static final String orderItemsList = 'orderItemsList';
  static final String orderMembersList = 'orderMembersList';
  static final String orderOrderNo = 'orderOrderNo';
  static final String orderCover = 'orderCover';
  static final String orderSlip = 'orderSlip';
  static final String orderVenue = 'orderVenue';
  static final String orderSession = 'orderSession';
  static final String orderWaiter = 'orderWaiter';
  static final String orderTable = 'orderTable';
  static final String orderUserId = 'userId';

  final List<Item> item;
  final List<Member> member;
  final String orderNo, cover, slip, venue, session, waiter, table, userId;

  const Order({ this.item, this.member, this.orderNo, this.cover, this.slip,
    this.venue, this.session, this.waiter, this.table, this.userId });

  Map<String, dynamic> toJson() => {
    orderItemsList : item.map((e) => e.toJson()).toList(),
    orderMembersList : member.map((e) => e.toJson()).toList(),
    orderOrderNo : orderNo,
    orderCover : cover,
    orderSlip : slip,
    orderVenue : venue,
    orderSession : session,
    orderWaiter : waiter,
    orderTable :  table,
    orderUserId : userId
  };

  factory Order.fromJson(Map<String, dynamic> map) => Order(
    member: memberListFromJson(json.decode(jsonEncode(map[orderItemsList]))),
    item: itemListFromJson(json.decode(jsonEncode(map[orderMembersList]))),
    orderNo: map[orderOrderNo],
    cover: map[orderCover],
    slip: map[orderSlip],
    venue: map[orderVenue],
    session: map[orderSession],
    waiter: map[orderWaiter],
    table: map[orderTable],
    userId: map[orderUserId]
  );

  @override
  String toString() {
    return 'Order{item: $item, member: $member, orderNo: $orderNo, cover: $cover, slip: $slip, venue: $venue, session: $session, waiter: $waiter, table: $table, userId: $userId}';
  }
}

List<Order> orderListFromJson(String str) => List<Order>.from(json.decode(str)['Data'].map((x) => Order.fromJson(x)));