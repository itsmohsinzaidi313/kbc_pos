import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kbc_pos/bloc/order_bloc/order_event.dart';
import 'package:kbc_pos/bloc/order_bloc/order_states.dart';
import 'package:kbc_pos/data_provider/order_repo/order_service.dart';
import 'package:kbc_pos/models/objects/order.dart';

class OrderBloc extends Bloc<OrderEvent, MyOrderStates>{

  final OrderRepo orderRepo;
  OrderBloc({this.orderRepo}) : super(MyOrderStatesInit());

  @override
  Stream<MyOrderStates> mapEventToState(OrderEvent event) async*{
    if(event is FetchingOrdersList) {
      yield MyOrderStatesLoading();
      try{
        List<Order> list = await orderRepo.getOrders();
        if(list.length > 0){
          yield MyOrderStateList(order: list);
        } else{
          yield MyOrderStatesError(error: 'Something went wrong');
        }
      }catch (e){
        yield MyOrderStatesError(error: e.toString());
      }
    }
  }


}