import 'package:equatable/equatable.dart';

abstract class PosEvent extends Equatable{

  const PosEvent();

  @override
  List<Object> get props => [];
}

class FetchAllLists extends PosEvent{}

class FetchCategoriesList extends PosEvent{}

class FetchItemsList extends PosEvent{}

class FetchItemListById extends PosEvent{
  final String id;
  FetchItemListById({ this.id});
}

class AddCartItem extends PosEvent{
  final dynamic item;
  AddCartItem({ this.item });
}

class ModifyCartItem extends PosEvent{

  final int index, plusItem, minusItem;
  ModifyCartItem({this.index, this.plusItem, this.minusItem});
}

class RemoveCartItem extends PosEvent{

  final int index;
  RemoveCartItem({this.index});
}

class PosOrderSubmitted extends PosEvent{}