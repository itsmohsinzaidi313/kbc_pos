import 'package:equatable/equatable.dart';
import 'package:kbc_pos/models/objects/category.dart';
import 'package:kbc_pos/models/objects/item.dart';

enum PosStates { init, inProgress, categoryListInProgress, categoryListLoaded,
  itemListInProgress, itemListLoaded, successful, failed}

class MyPosStates{

  final List<Category> categoriesList;
  final List<Item> itemsList;
  final List<Item> cartItemsList;
  final PosStates states;
  final Category selectedCategory;
  final error;

  MyPosStates({
    this.categoriesList = const [],
    this.itemsList = const [],
    this.cartItemsList = const [],
    this.error = "",
    this.selectedCategory = const Category(),
    this.states = PosStates.init});

  MyPosStates copyWith({
    List<Category> categoriesList,
    List<Item> itemsList,
    List<Item> cartItemsList,
    final error,
    Category selectedCategory,
    PosStates states
  }){
    return MyPosStates(
        categoriesList: categoriesList ?? this.categoriesList,
        itemsList: itemsList ?? this.itemsList,
        cartItemsList: cartItemsList ?? this.cartItemsList,
        states: states ?? this.states,
      error: error ?? this.error,
      selectedCategory: selectedCategory ?? this.selectedCategory
    );
  }

}

