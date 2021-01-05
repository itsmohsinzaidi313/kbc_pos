import 'package:equatable/equatable.dart';
import 'package:kbc_pos/models/objects/category.dart';

enum PosStates { init, inProgress, categoryListInProgress, categoryListLoaded,
  itemListInProgress, itemListLoaded, successful, failed}

class MyPosStates extends Equatable{

  final List<dynamic> categoriesList;
  final List<dynamic> itemsList;
  final List<dynamic> cartItemsList;
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
    List<dynamic> categoriesList,
    List<dynamic> itemsList,
    List<dynamic> cartItemsList,
    final error,
    Category selectedCategory,
    PosStates states
  }){
    return MyPosStates(
        categoriesList: categoriesList ?? this.categoriesList,
        itemsList: itemsList ?? this.itemsList,
        cartItemsList: cartItemsList ?? this.categoriesList,
        states: states ?? this.states,
      error: error ?? this.error,
      selectedCategory: selectedCategory ?? this.selectedCategory
    );
  }

  @override
  List<Object> get props => [categoriesList, itemsList, cartItemsList, states, error, selectedCategory];
}

