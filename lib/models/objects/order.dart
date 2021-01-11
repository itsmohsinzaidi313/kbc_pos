import 'package:kbc_pos/models/objects/item.dart';
import 'package:kbc_pos/models/objects/member.dart';

class Order {

  final List<Item> item;
  final List<Member> member;
  final String orderNo, cover, slip, venue, session, waiter, table;

  const Order({ this.item, this.member, this.orderNo, this.cover, this.slip,
    this.venue, this.session, this.waiter, this.table });

  @override
  String toString() {
    return 'Order{item: $item, member: $member, orderNo: $orderNo, cover: $cover, slip: $slip, venue: $venue, session: $session, waiter: $waiter, table: $table}';
  }
}