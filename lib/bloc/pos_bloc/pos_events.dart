import 'package:equatable/equatable.dart';
import 'package:kbc_pos/models/objects/category.dart';
import 'package:kbc_pos/models/objects/item.dart';

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
  final Item item;
  AddCartItem({ this.item });
}

class PlusCartItem extends PosEvent{

  final int index;
  PlusCartItem({this.index});
}

class MinusCartItem extends PosEvent{

  final int index;
  MinusCartItem({this.index});
}

class RemoveCartItem extends PosEvent{

  final int index;
  RemoveCartItem({this.index});
}

class CategoryChanged extends PosEvent{
  final Category category;
  CategoryChanged({this.category});
}

class PosOrderSubmitted extends PosEvent{}