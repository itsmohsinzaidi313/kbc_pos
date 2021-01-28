import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kbc_pos/bloc/pos_bloc/pos_events.dart';
import 'package:kbc_pos/bloc/pos_bloc/pos_states.dart';
import 'package:kbc_pos/data_provider/pos_repo/pos_service.dart';
import 'package:kbc_pos/models/generic/response_detail.dart';
import 'package:kbc_pos/models/objects/category.dart';
import 'package:kbc_pos/models/objects/item.dart';
import 'package:kbc_pos/models/objects/order.dart';
import 'package:kbc_pos/shared/config.dart';

class PosBloc extends Bloc<PosEvent, MyPosStates>{

  final PosRepo posRepo;
  List<Item> _cartList = [];
  PosBloc({ @required this.posRepo}) : super(MyPosStates());

  @override
  Stream<MyPosStates> mapEventToState(PosEvent event) async*{
    if(event is FetchAllLists){

      if(Config.isEditing == 1){
        // _cartList.clear();
        _cartList = Config.selectedOrder.item;

      } else if(Config.isEditing == 0){
        _cartList.clear();
        yield state.copyWith(cartItemsList: _cartList, totalCartAmount: 0.0);
      }
      yield state.copyWith(states: PosStates.inProgress);
      try{
        List<Category> list = await posRepo.getCategories();
        if (Config.isEditing == 0) {
          yield state.copyWith(categoriesList: list, states: PosStates.categoryListLoaded, selectedCategory: list.first);
        } else if (Config.isEditing == 1) {
          yield state.copyWith(categoriesList: list, states: PosStates.categoryListLoaded,
              selectedCategory: list.first, cartItemsList: _cartList, totalCartAmount: getCartTotalAmount(cartList: _cartList ?? []));
        }
        List<Item> items = await posRepo.getItemsById(id: list.first.id);
        yield state.copyWith(itemsList: items, states: PosStates.init);
      } catch(e){
        yield state.copyWith(error: e.toString(), states: PosStates.failed);
      }
    } else if (event is CategoryChanged){
      try {
        yield state.copyWith(categoriesList: state.categoriesList, selectedCategory: event.category, states: PosStates.categoryListLoaded);
        List<Item> item = await posRepo.getItemsById(id: event.category.id);
        yield state.copyWith(itemsList: item, states: PosStates.init);
      } catch (e) {
        yield state.copyWith(error: e.toString(), states: PosStates.failed);
      }
    } else if (event is AddCartItem){
      Item item = event.item;
      if(!_cartList.contains(item)){
        _cartList.add(item);
        yield state.copyWith(cartItemsList:_cartList, totalCartAmount: getCartTotalAmount(cartList: _cartList));
      }
      else {
        _cartList.forEach((element) {
          if(element == item)
          {
            element.quantity = element.quantity +1;
          }
        });
        yield state.copyWith(cartItemsList:_cartList, totalCartAmount: getCartTotalAmount(cartList: _cartList));
      }
    } else if (event is PlusCartItem){
      Item x = _cartList.elementAt(event.index);
      x.quantity = x.quantity +1;
      yield state.copyWith(cartItemsList:_cartList, totalCartAmount: getCartTotalAmount(cartList: _cartList));
    } else if (event is MinusCartItem){
      Item x = _cartList.elementAt(event.index);
      if(x.quantity > 1){
        x.quantity = x.quantity -1;
        yield state.copyWith(cartItemsList:_cartList, totalCartAmount: getCartTotalAmount(cartList: _cartList));
      }
    } else if (event is RemoveCartItem){
      Item x = _cartList.elementAt(event.index);
      x.quantity = 1;
      _cartList.removeAt(event.index);
      yield state.copyWith(cartItemsList:_cartList, totalCartAmount: getCartTotalAmount(cartList: _cartList));
    } else if (event is PosOrderSubmitted){
      try {
        Order order = event.order;
        Order order2 = Order(editing: Config.isEditing, atParty: order.atParty ,item: state.cartItemsList, member: order.member, orderNo: order.orderNo,
                  cover: order.cover, session: order.session, slip: order.slip, table: order.table, venue: order.venue, orderKey: order.orderKey ?? '',
            waiter: order.waiter, userId: order.userId, deviceKey: Config.deviceKey ?? '');
        yield state.copyWith(states: PosStates.inProgress);
        ResponseDetail responseDetail = await posRepo.sendOrder(order2.toJson());
        if(responseDetail.status) {
          yield state.copyWith(states: PosStates.successful);
        } else{
          yield state.copyWith(states: PosStates.failed, error: responseDetail.message);
        }
      } catch (e) {
        yield state.copyWith(error: e.toString());
        print(e);
      }
    }

  }

  double getCartTotalAmount({List<Item> cartList}){
    double totalCartAmount = 0.0;
    cartList.forEach((element) {
      totalCartAmount +=  (element.quantity * double.tryParse(element.price));
      },
    );
    return totalCartAmount;
  }

}