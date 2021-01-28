abstract class OrderEvent{}

class FetchingOrdersList extends OrderEvent{}

class PaymentOrder extends OrderEvent{
  final String orderKey;
  PaymentOrder({ this.orderKey });
}

class DeleteOrder extends OrderEvent{
  final String orderKey;
  DeleteOrder({ this.orderKey });
}