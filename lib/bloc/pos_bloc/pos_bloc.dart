import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kbc_pos/bloc/pos_bloc/pos_events.dart';
import 'package:kbc_pos/bloc/pos_bloc/pos_states.dart';
import 'package:kbc_pos/data_provider/pos_repo/pos_service.dart';
import 'package:kbc_pos/models/generic/response_detail.dart';
import 'package:kbc_pos/models/objects/category.dart';
import 'package:kbc_pos/models/objects/item.dart';
import 'package:kbc_pos/models/objects/order.dart';

class PosBloc extends Bloc<PosEvent, MyPosStates>{

  final PosRepo posRepo;
  List<Item> _cartList = [];
  PosBloc({ @required this.posRepo}) : super(MyPosStates());

  @override
  Stream<MyPosStates> mapEventToState(PosEvent event) async*{
    if(event is FetchAllLists){
      yield state.copyWith(states: PosStates.inProgress);
      try{
        List<Category> list = await posRepo.getCategories();
        yield state.copyWith(categoriesList: list, states: PosStates.categoryListLoaded, selectedCategory: list.first);
        List<Item> items = await posRepo.getItemsById(id: list.first.id);
        yield state.copyWith(itemsList: items, states: PosStates.successful);
      } catch(e){
        yield state.copyWith(error: e.toString(), states: PosStates.failed);
      }
    } else if (event is CategoryChanged){
      try {
        yield state.copyWith(categoriesList: state.categoriesList, selectedCategory: event.category, states: PosStates.categoryListLoaded);
        List<Item> item = await posRepo.getItemsById(id: event.category.id);
        yield state.copyWith(itemsList: item, states: PosStates.successful);
      } catch (e) {
        yield state.copyWith(error: e.toString(), states: PosStates.failed);
      }
    } else if (event is AddCartItem){
      if(!_cartList.contains(event.item)){
        _cartList.add(event.item);
        yield state.copyWith(cartItemsList:_cartList);
      }
    } else if (event is PlusCartItem){
      Item x = _cartList.elementAt(event.index);
      x.quantity = x.quantity +1;
      yield state.copyWith(cartItemsList: _cartList);
    } else if (event is MinusCartItem){
      Item x = _cartList.elementAt(event.index);
      if(x.quantity > 1){
        x.quantity = x.quantity -1;
        yield state.copyWith(cartItemsList: _cartList);
      }
    } else if (event is RemoveCartItem){
      // Item x = _cartList.elementAt(event.index);
      // x.quantity = x.quantity -1;
      _cartList.removeAt(event.index);
      yield state.copyWith(cartItemsList: _cartList);
    } else if (event is PosOrderSubmitted){
      Order order = event.order;
      Order order2 = Order(item: state.cartItemsList, member: order.member, orderNo: order.orderNo,
          cover: order.cover, session: order.session, slip: order.slip, table: order.table, venue: order.venue, waiter: order.waiter);
      print(order2.toJson().toString());
      yield state.copyWith(states: PosStates.inProgress, categoriesList: state.categoriesList, cartItemsList: state.cartItemsList, itemsList: state.itemsList);
      ResponseDetail responseDetail = await posRepo.sendOrder(order2.toJson());
      if(responseDetail.status) yield state.copyWith(states: PosStates.successful);
      yield state.copyWith(states: PosStates.successful, categoriesList: state.categoriesList, cartItemsList: state.cartItemsList, itemsList: state.itemsList);
    }
  }


}