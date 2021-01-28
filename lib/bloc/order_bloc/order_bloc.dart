import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kbc_pos/bloc/order_bloc/order_event.dart';
import 'package:kbc_pos/bloc/order_bloc/order_states.dart';
import 'package:kbc_pos/data_provider/order_repo/order_service.dart';
import 'package:kbc_pos/models/generic/response_detail.dart';
import 'package:kbc_pos/models/objects/order.dart';

class OrderBloc extends Bloc<OrderEvent, MyOrderStates>{

  final OrderRepo orderRepo;
  OrderBloc({this.orderRepo}) : super(MyOrderStatesInit());
  List<Order> _list = [];

  @override
  Stream<MyOrderStates> mapEventToState(OrderEvent event) async* {
    if (event is FetchingOrdersList) {
      yield MyOrderStatesLoading();
      try {
        _list = await orderRepo.getOrders();
        if (_list.length > 0) {
          yield MyOrderStateList(order: _list);
        } else {
          yield MyOrderStatesError(error: 'Something went wrong');
        }
      } catch (e) {
        yield MyOrderStatesError(error: e.toString());
      }
    } else if (event is PaymentOrder) {
      yield MyOrderStatesLoading();
      ResponseDetail responseDetail = await orderRepo.payOrder(event.orderKey);
      Order order;
      if (responseDetail.status) {
        _list.forEach((element) {
          if (element.orderKey == event.orderKey) {
            order = element;
          }
        });
        _list.remove(order);
        yield OrderPaymentSuccessfully();
        yield MyOrderStateList(order: _list);
      } else {
        yield MyOrderStatesError(error: responseDetail.message);
      }
    } else if (event is DeleteOrder) {
      yield MyOrderStatesLoading();
      ResponseDetail responseDetail = await orderRepo.deleteOrder(
          event.orderKey);
      if (responseDetail.status) {
        Order order;
        if (responseDetail.status) {
          _list.forEach((element) {
            if (element.orderKey == event.orderKey) {
              order = element;
            }
          });
          _list.remove(order);
          yield OrderDeletedSuccessfully();
          yield MyOrderStateList(order: _list);
        } else {
          yield MyOrderStatesError(error: responseDetail.message);
        }
      }
    }
  }
}