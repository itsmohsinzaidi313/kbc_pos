import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kbc_pos/bloc/order_info_bloc/order_info_bloc.dart';
import 'package:kbc_pos/bloc/order_info_bloc/order_info_events.dart';
import 'package:kbc_pos/bloc/pos_bloc/pos_bloc.dart';
import 'package:kbc_pos/bloc/pos_bloc/pos_events.dart';
import 'package:kbc_pos/bloc/pos_bloc/pos_states.dart';
import 'package:kbc_pos/models/objects/category.dart';
import 'package:kbc_pos/models/objects/item.dart';
import 'package:kbc_pos/models/objects/member.dart';
import 'package:kbc_pos/screens/custom_widget_classes/custom_circular_progress_indicator.dart';
import 'package:kbc_pos/shared/app_theme.dart';
import 'package:kbc_pos/shared/config.dart';

import 'custom_widget_classes/custom_appbar.dart';

class PosScreen extends StatefulWidget {
  @override
  _PosScreenState createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  GlobalKey<AutoCompleteTextFieldState<Member>> _tKey =
      GlobalKey<AutoCompleteTextFieldState<Member>>();

  String radioGroupValue = 'By Code';
  final TextEditingController _autoCompleteController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<PosBloc>().add(FetchAllLists());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      key: _key,
      body: BlocListener<PosBloc, MyPosStates>(
        listenWhen: (pre, curr) => pre.states != curr.states,
        listener: (context, states) {
          if (states.states == PosStates.successful) {
            AppTheme.mySnackBar(
                context: context, msg: 'List Fetched Successfully..');
          } else if (states.states == PosStates.failed) {
            AppTheme.mySnackBar(context: context, msg: states.error);
            print(states.error);
          }
          /*else if (states.states == PosStates.inProgress) {
            AppTheme.mySnackBar(context: context, msg: 'Loading...');
          }*/
        },
        child: SingleChildScrollView(
          child: Container(
            height: Config.getDeviceHeight(context),
            width: Config.getDeviceWidth(context),
            child: Column(
              children: [
                CustomAppBar(
                  appBarTitle: 'POS Screen',
                  searchBar: autoCompleteSearchBar(),
                  radioButtons: searchRadioButton(),
                  onBackPressed: () => Navigator.pop(context),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: Column(
                                    children: [
                                      Text('Categories'),
                                      CategoryList(),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    Text('Items'),
                                    ItemList(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        CartItemList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget searchRadioButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Radio(
              value: 'By Code',
              groupValue: radioGroupValue,
              onChanged: (value) {
                setState(() {
                  radioGroupValue = value;
                });
              },
            ),
            Text(
              'By Code',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Radio(
              value: 'By Name',
              groupValue: radioGroupValue,
              onChanged: (value) {
                setState(() {
                  radioGroupValue = value;
                });
              },
            ),
            Text(
              'By Name',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget autoCompleteSearchBar() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData == null &&
            snapshot.connectionState == ConnectionState.none) {
          return Container(
            child: Center(
              child: Text('Progressing..'),
            ),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
        } else if (snapshot.hasData) {
          return AutoCompleteTextField<Member>(
            clearOnSubmit: false,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'Search Item Here..',
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(Icons.cancel),
                iconSize: 20,
                color: Colors.yellow[700],
                onPressed: () {
                  _autoCompleteController.text = "";
                },
              ),
              contentPadding: EdgeInsets.fromLTRB(10, 30, 10, 20),
              hintStyle: TextStyle(color: Colors.grey),
            ),
            keyboardType: TextInputType.text,
            controller: _autoCompleteController,
            textChanged: (value) {
              print(value);
            },
            itemSubmitted: (item) async {
              _autoCompleteController.text = radioGroupValue == 'By Code'
                  ? item.memberNo
                  : item.memberName;
              BlocProvider.of<OrderInfoBloc>(context)
                  .add(SelectedMember(member: item));
            },
            key: _tKey,
            suggestions: snapshot.data,
            itemBuilder: (context, item) {
              return radioGroupValue == 'By Code'
                  ? autoCompleteSearchBarRow(
                      item: item.memberNo, icon: Icon(Icons.person))
                  : autoCompleteSearchBarRow(
                      item: item.memberName, icon: Icon(Icons.person));
              // return autoCompleteSearchBarRow(
              //     item: item.memberNo, icon: Icon(Icons.person));
            },
            itemFilter: (item, query) {
              bool _itemFilter;
              if (_autoCompleteController.text.isNotEmpty) {
                _itemFilter = radioGroupValue == 'By Code'
                    ? item.memberNo
                        .toLowerCase()
                        .startsWith(query.toLowerCase())
                    : item.memberName
                        .toLowerCase()
                        .startsWith(query.toLowerCase());
              } else {
                _autoCompleteController.text = '';
                _itemFilter = false;
              }
              return _itemFilter;
              // return item.memberNo.toLowerCase().startsWith(query.toLowerCase());
            },
            itemSorter: (a, b) {
              return radioGroupValue == 'By Code'
                  ? a.memberNo.compareTo(b.memberNo.toLowerCase())
                  : a.memberName.compareTo(b.memberName.toLowerCase());
              // return a.memberNo.compareTo(b.memberNo.toLowerCase());
            },
          );
        }
        return Container();
      },
      future: getMembers(),
    );
  }

  Future<List<Member>> getMembers() async {
    List<Member> list;
    await Future.delayed(Duration(seconds: 1), () {
      list = [
        Member(
            memberId: 1,
            memberNo: '1220',
            memberType: 'PL',
            memberStatus: 'E',
            memberName: 'MR. C. G. KHARAS'),
        Member(
            memberId: 1,
            memberNo: '1856',
            memberType: 'PO',
            memberStatus: 'R',
            memberName: 'MR. USMAN AMINUDDIN'),
        Member(
            memberId: 1,
            memberNo: '2651',
            memberType: 'PE',
            memberStatus: 'E',
            memberName: 'MR. SALEENM A. THARIANI'),
      ];
    });
    return list;
  }

  Widget autoCompleteSearchBarRow(
      {@required String item, @required Icon icon}) {
    return ListTile(
      leading: icon,
      title: Text(item),
    );
  }

  Future<bool> _onWillPop() async {
    bool isYes = false;
    bool type = await AppTheme.showAlertDialogYNFutureReturn(context,
        title: 'Question?',
        message: 'Are you sure?',
        onNo: () => Navigator.of(context).pop(false),
        onYes: () =>
            // OrderController(model.orderType).launchAndReplacement(context)
            true ? isYes = true : isYes = false);

    if (isYes && type) {
      if (/*model.titleString*/ ''.isNotEmpty) {
        Navigator.pop(context);
        return true;
      } else {
        Navigator.pop(context);
        // OrderController(model.orderType).launchAndReplacement(context);
      }
      return false;
    } else {
      return false;
    }
  }

  List<Widget> getCategoryWidgets(List<Category> lstCategory) {
    List<Widget> widgets = [];
    lstCategory.forEach((category) {
      // if(_element.isEmpty){
      //   setState(() {
      //     _element = category.categoryName;
      //   });
      // }
      widgets.add(
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: /*_element == category.categoryName ? Colors.white70 : */ Colors
              .white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
/*                setState(() {
                  categoryName = category.categoryName;
                  _element = category.categoryName;
                });*/
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.yellow.shade700,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 13,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade700,
                        radius: 9,
                      ),
                    ),
                  ),
                  Container(
                    height: Config.getDeviceHeight(context) * 0.1,
                    width: Config.getDeviceHeight(context) * 0.18,
                    child: Center(
                      child: Text(
                        category.name.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntuCondensed(
                          color: Colors.red.shade700,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          wordSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
    return widgets;
  }

  List<Widget> getItemsWidgets(List<dynamic> lstItem, String categoryName) {
/*    List<Widget> widgets = [];
    lstItem.forEach((item) {
      // if (categoryName.isEmpty) {
      //   categoryName = item.categoryName;
      // }
      if (item.categoryName == _element) {
        widgets.add(
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 3,
            color: Colors.white,
            child: InkWell(
              onTap: () {
                setState(() {
                  this.model.order.addItem(item);
                });
              },
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      height: Config.getDeviceHeight(context) * 0.2,
                      width: Config.getDeviceWidth(context) * 0.159,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: item.photo != null
                              ? NetworkImage(item.photo)
                              : AssetImage('assets/no_image1.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  item.photo == null
                      ? Align(
                          alignment: Alignment.center,
                          child: Text(
                            'No Image'.toUpperCase(),
                            style: GoogleFonts.anton(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Container(),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      height: Config.getDeviceHeight(context) * 0.094,
                      width: Config.getDeviceWidth(context) * 0.158,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  item.name.toUpperCase(),
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.ubuntuCondensed(
                                    color: Colors.grey.shade800,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0,
                                    wordSpacing: 0.5,
                                  ),
                                ),
                              ),
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'PKR ${double.parse(item.salePrice).toInt().toString()}',
                                    style: GoogleFonts.ubuntuCondensed(
                                      color: Colors.grey.shade500,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      wordSpacing: 1.0,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: Colors.yellow.shade900,
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: Colors.yellow.shade900,
                                      ),
                                      Icon(
                                        Icons.star_half_outlined,
                                        size: 10,
                                        color: Colors.yellow.shade900,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
    return widgets;*/
    return [];
  }

/*
  List<Widget> getCartItemsWidgets(List<dynamic> lstItem) {
    List<Widget> widgets = [];
    lstItem.forEach((item) {
      widgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              model.order.addItem(item);
            });
          },
          child: Card(
            elevation: 4,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.yellow.shade700,
                radius: 16,
                child: CircleAvatar(
                  radius: 14,
                  backgroundImage: item.photo != null ? NetworkImage(item.photo) : AssetImage('assets/no_image1.jpg'),
                ),
              ),
              title: Text(
                  item.name.toUpperCase(),
                style: GoogleFonts.ubuntuCondensed(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  wordSpacing: 0.5,
                ),
              ),
              subtitle: Text(
                ' ${double.parse(item.salePrice).toInt().toString()} x ${item.quantity} '
                    '= ${(double.parse(item.salePrice).toInt() * int.parse(item.quantity)).toString()}',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 10,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.yellow.shade800,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    item.quantity = 1.toString();
                    this.model.order.removeItem(item);
                  });
                },
              ),
            ),
          ),
        ),
      );
    });
    return widgets;
  }
*/

  Widget _floatingActionButton({Function onPressed}) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppTheme.appBarColor,
      tooltip: 'Order Submission',
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  static List<Item> _cartList = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosBloc, MyPosStates>(
      builder: (context, states) {
        if (states.states == PosStates.itemListLoaded ||
            states.states == PosStates.successful ||
            states.states == PosStates.init) {
          return Flexible(
            flex: 1,
            child: GridView.builder(
                itemCount: states.itemsList.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        _cartList.add(states.itemsList[index]);
                        context
                            .read<PosBloc>()
                            .add(AddCartItem(item: states.itemsList[index]));
                      },
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              height: Config.getDeviceHeight(context) * 0.2,
                              width: Config.getDeviceWidth(context) * 0.159,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  image: AssetImage('assets/no_image1.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'No Image'.toUpperCase(),
                              style: GoogleFonts.anton(
                                color: Colors.white70,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              height: Config.getDeviceHeight(context) * 0.094,
                              width: Config.getDeviceWidth(context) * 0.158,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          states.itemsList[index].name
                                              .toUpperCase(),
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.ubuntuCondensed(
                                            color: Colors.grey.shade800,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0,
                                            wordSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        // mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'PKR ${double.parse(states.itemsList[index].price).toInt().toString()}',
                                            style: GoogleFonts.ubuntuCondensed(
                                              color: Colors.grey.shade500,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              wordSpacing: 1.0,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 10,
                                                color: Colors.yellow.shade900,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 10,
                                                color: Colors.yellow.shade900,
                                              ),
                                              Icon(
                                                Icons.star_half_outlined,
                                                size: 10,
                                                color: Colors.yellow.shade900,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
        }
        return CustomCircularProgressIndication();
      },
    );
  }
}

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosBloc, MyPosStates>(
      builder: (context, states) {
        if (states.states == PosStates.categoryListLoaded ||
            states.states == PosStates.successful ||
            states.states == PosStates.init) {
          return Flexible(
            flex: 1,
            child: ListView.builder(
                itemCount: states.categoriesList.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    color: states.selectedCategory.name ==
                            states.categoriesList[index].name
                        ? Colors.white70
                        : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          context.read<PosBloc>().add(CategoryChanged(
                              category: states.categoriesList[index]));
                          print(
                              'Category Item Pressed: ${states.categoriesList[index]}');
                          /*                setState(() {
                        categoryName = category.categoryName;
                        _element = category.categoryName;
                      });*/
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.yellow.shade700,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 13,
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey.shade700,
                                  radius: 9,
                                ),
                              ),
                            ),
                            Container(
                              height: Config.getDeviceHeight(context) * 0.1,
                              width: Config.getDeviceHeight(context) * 0.18,
                              child: Center(
                                child: Text(
                                  states.categoriesList[index].name
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.ubuntuCondensed(
                                    color: Colors.red.shade700,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                    wordSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
        }
        return CustomCircularProgressIndication();
      },
    );
  }
}

class CartItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosBloc, MyPosStates>(
        buildWhen: (pre, curr) => curr.cartItemsList.length > 0,
        builder: (context, state) {
          return Flexible(
            flex: 1,
            child: ListView.builder(
              itemCount: state.cartItemsList.length + 1,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              reverse: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    title: Text('You can add here..'),
                  );
                }
                return Card(
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.yellow.shade700,
                      radius: 16,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundImage: AssetImage('assets/no_image1.jpg'),
                      ),
                    ),
                    title: Text(
                      state.cartItemsList[index - 1].name.toUpperCase(),
                      style: GoogleFonts.ubuntuCondensed(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        wordSpacing: 0.5,
                      ),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8,),
                        Text(
                          ' ${double.parse(state.cartItemsList[index - 1].price).toInt().toString()} x ${state.cartItemsList[index - 1].quantity} '
                          '= ${(double.parse(state.cartItemsList[index - 1].price).toInt() * state.cartItemsList[index - 1].quantity).toString()}',
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.remove,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                context
                                    .read<PosBloc>()
                                    .add(MinusCartItem(index: index - 1));
                              },
                            ),
                            Text(
                              state.cartItemsList[index - 1].quantity
                                  .toString(),
                              style: TextStyle(
                                color: Colors.grey.shade900,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                context
                                    .read<PosBloc>()
                                    .add(PlusCartItem(index: index - 1));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.yellow.shade800,
                        size: 22,
                      ),
                      onPressed: () {
                        context
                            .read<PosBloc>()
                            .add(RemoveCartItem(index: index - 1));
                      },
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
