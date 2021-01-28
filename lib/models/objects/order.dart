import 'dart:convert';
import 'package:kbc_pos/models/objects/item.dart';
import 'package:kbc_pos/models/objects/member.dart';
import 'package:kbc_pos/shared/config.dart';

class Order {
  static final String isEditing = 'isEditing';
  static final String order = 'order';

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
  static final String orderDeviceKey = 'deviceKey';
  static final String orderAtParty = 'atParty';
  static final String orderOrderKey = 'orderKey';

  final List<Item> item;
  final List<Member> member;
  final String orderNo,
      cover,
      slip,
      venue,
      session,
      waiter,
      orderKey,
      table,
      userId,
      deviceKey;
  final int editing;
  final bool atParty;

  const Order(
      {this.atParty,
      this.item,
      this.member,
      this.orderNo,
      this.cover,
      this.slip,
      this.venue,
      this.session,
      this.waiter,
      this.table,
      this.userId,
      this.orderKey,
        this.editing,
      this.deviceKey});

  Map<String, dynamic> toJson() => {
        orderItemsList: item.map((e) => e.toJson()).toList(),
        orderMembersList: member.map((e) => e.toJson()).toList(),
        orderOrderNo: orderNo, //
        orderCover: cover,
        orderSlip: slip, //
        orderVenue: venue,
        orderSession: session,
        orderWaiter: waiter,
        orderTable: table,
        orderUserId: userId,
        orderDeviceKey: deviceKey,
        orderAtParty: atParty,
        orderOrderKey: orderKey,
        isEditing : editing
      };

  factory Order.fromJson(Map<String, dynamic> map) => Order(
      member: getMemberListFromDynamicList(map[orderMembersList]),
      item: getItemListFromDynamicList(map[orderItemsList]),
      orderNo: map[orderOrderNo],
      cover: map[orderCover].toString(),
      slip: map[orderSlip].toString(),
      venue: map[orderVenue].toString(),
      session: map[orderSession].toString(),
      waiter: map[orderWaiter].toString(),
      table: map[orderTable].toString(),
      userId: map[orderUserId].toString(),
      deviceKey: map[orderDeviceKey],
      atParty: map[orderAtParty],
      orderKey: map[orderOrderKey]);

  @override
  String toString() {
    return 'Order{item: $item, member: $member, orderNo: $orderNo, cover: $cover, slip: $slip, '
        'venue: $venue, orderKey: $orderKey, AtParty: $atParty, session: $session, waiter: $waiter, table: $table, userId: $userId, deviceKey: $deviceKey}';
  }
}

List<Order> orderListFromJson(String str) =>
    List<Order>.from(json.decode(str)['Data'].map((x) => Order.fromJson(x)));

List<Member> getMemberListFromDynamicList(List<dynamic> list) {
  List<Member> membersList = [];
  list.forEach((element) {
    membersList.add(Member.fromJson(element));
  });
  return membersList;
}

List<Item> getItemListFromDynamicList(List<dynamic> list) {
  List<Item> itemList = [];
  list.forEach((element) {
    itemList.add(Item.fromJson(element));
  });
  return itemList;
}
