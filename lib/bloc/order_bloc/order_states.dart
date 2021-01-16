import 'package:kbc_pos/models/objects/order.dart';

abstract class MyOrderStates{}

class MyOrderStatesInit extends MyOrderStates{}

class MyOrderStatesLoading extends MyOrderStates{}

class MyOrderStateList extends MyOrderStates{
  final List<Order> order;
  MyOrderStateList({this.order});
}

class MyOrderStatesError extends MyOrderStates{
  final String error;
  MyOrderStatesError({this.error});
}