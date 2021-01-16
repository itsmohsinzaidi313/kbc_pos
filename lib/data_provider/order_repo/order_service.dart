import 'package:kbc_pos/models/objects/order.dart';

abstract class OrderRepo{
  Future<List<Order>> getOrders();
}

class OrderService extends OrderRepo{

  @override
  Future<List<Order>> getOrders() async{
    List<Order> list;
    return list;
  }

}

