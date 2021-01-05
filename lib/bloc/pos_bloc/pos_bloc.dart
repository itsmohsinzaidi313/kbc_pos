import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kbc_pos/bloc/pos_bloc/pos_events.dart';
import 'package:kbc_pos/bloc/pos_bloc/pos_states.dart';
import 'package:kbc_pos/data_provider/pos_repo/pos_service.dart';
import 'package:kbc_pos/models/objects/category.dart';
import 'package:kbc_pos/models/objects/item.dart';

class PosBloc extends Bloc<PosEvent, MyPosStates>{

  final PosRepo posRepo;
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
    }
  }


}