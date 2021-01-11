import 'dart:async';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kbc_pos/bloc/order_info_bloc/order_info_bloc.dart';
import 'package:kbc_pos/bloc/order_info_bloc/order_info_events.dart';
import 'package:kbc_pos/bloc/order_info_bloc/order_info_states.dart';
import 'package:kbc_pos/models/objects/location.dart';
import 'package:kbc_pos/models/objects/member.dart';
import 'package:kbc_pos/models/objects/order.dart';
import 'package:kbc_pos/models/objects/session.dart';
import 'package:kbc_pos/shared/app_theme.dart';
import 'package:kbc_pos/shared/config.dart';
import 'package:formz/formz.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class OrderInfoScreen extends StatefulWidget {
  @override
  _OrderInfoScreenState createState() => _OrderInfoScreenState();
}

class _OrderInfoScreenState extends State<OrderInfoScreen> {
  String radioGroupValue = 'By Code';
  final TextEditingController _autoCompleteController = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<Member>> _key = GlobalKey();
  final controller = FloatingSearchBarController();
  final _waiterFocusNode = FocusNode();
  final _tableNoFocusNode = FocusNode();
  bool isProgressing = false;

  @override
  void initState() {
    super.initState();
    context.read<OrderInfoBloc>().add(FetchingLists());
    _waiterFocusNode.addListener(() {
      if (!_waiterFocusNode.hasFocus) {
        context.read<OrderInfoBloc>().add(WaiterUnfocused());
        FocusScope.of(context).requestFocus(_tableNoFocusNode);
      }
    });
    _tableNoFocusNode.addListener(() {
      if (!_tableNoFocusNode.hasFocus) {
        context.read<OrderInfoBloc>().add(TableNoUnfocused());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Info'),
        backgroundColor: Colors.red,
      ),
      body: BlocListener<OrderInfoBloc, MyOrderInfoStates>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is FetchingListInProgress) {
            AppTheme.mySnackBar(context: context, msg: 'Loading..');
          } else if (state.status.isSubmissionFailure) {
            AppTheme.mySnackBar(context: context, msg: state.error);
          } else if (state.status.isSubmissionInProgress) {
            CircularProgressIndicator();
            // AppTheme.mySnackBar(context: context, msg: 'Please Wait..');
          } else if (state.status.isSubmissionSuccess) {
            // AppTheme.mySnackBar(
            //     context: context, msg: 'Order Submitted Successfully..');
            Navigator.pushNamed(context, '/posScreen');
          }
        },
        child: Container(
          width: Config.getDeviceWidth(context),
          height: Config.getDeviceHeight(context),
          child: Stack(
            children: [
              Container(
                height: Config.getDeviceHeight(context),
                width: Config.getDeviceWidth(context),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BlocBuilder<OrderInfoBloc, MyOrderInfoStates>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              SizedBox(
                                height: Config.getDeviceHeight(context) * 0.13,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  seeMultipleMembers(
                                      context: context,
                                      member: state.selectedMember),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomLabelledTextView(
                                    labelName: 'Member Name',
                                    text: state.selectedMember.length > 0
                                        ? state.selectedMember.last?.memberName
                                        : '...',
                                    // text: state.selectedMember[0].memberName ?? '...',
                                  ),
                                  CustomLabelledTextView(
                                    labelName: 'Member Code',
                                    text: state.selectedMember.length > 0
                                        ? state.selectedMember.last?.memberNo
                                        : '...',
                                    // text: state.selectedMember[0].memberNo ?? '...',
                                  ),
                                  CustomLabelledTextView(
                                    labelName: 'Member Status',
                                    text: state.selectedMember.length > 0
                                        ? state
                                            .selectedMember.last?.memberStatus
                                        : '...',
                                    // text: state.selectedMember[0].memberStatus ?? '...',
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomLabelledTextView(
                                    labelName: 'Order No.',
                                    text: '...',
                                  ),
                                  CustomLabelledTextView(
                                    labelName: 'Covers',
                                    text: '...',
                                  ),
                                  CustomLabelledTextView(
                                    labelName: 'Slip',
                                    text: '...',
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LocationDropdown(),
                          SessionDropdown(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WaiterInput(
                            focusNode: _waiterFocusNode,
                          ),
                          TableInput(
                            focusNode: _tableNoFocusNode,
                          ),
                        ],
                      ),
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AtPartyCheckBox(),
                          WithSpouseCheckBox(),
                        ],
                      ),*/
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            submitButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: Container(
                  height: Config.getDeviceHeight(context),
                  width: Config.getDeviceWidth(context),
                  child: autoCompleteSearchBar(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget submitButton() {
    return BlocBuilder<OrderInfoBloc, MyOrderInfoStates>(
      builder: (context, state) {
        return SizedBox(
          width: Config.getDeviceWidth(context) * 0.4,
          height: Config.getDeviceHeight(context) * 0.08,
          child: RaisedButton.icon(
            onPressed: state.status.isValidated
                ? () {
                    context.read<OrderInfoBloc>().add(
                        OrderSubmitted(order: Order(
                          member: state.selectedMember,
                          orderNo: state.orderNo,
                          slip: state.slip,
                          cover: state.cover,
                          waiter: state.waiter.value,
                          table: state.tableNo.value,
                          session: state.selectedSession.sessionId.toString(),
                          venue: state.selectedLocation.locationId.toString()
                        )));
                  }
                : null,
            color: AppTheme.listTextColor,
            label: Text(
              'SUBMIT',
              style: GoogleFonts.ubuntuCondensed(
                color: Colors.white,
                letterSpacing: 1.0,
                fontSize: 20,
              ),
            ),
            icon: Icon(
              Icons.check,
              color: Colors.green,
              size: 20,
            ),
          ),
        );
      },
    );
  }

  Widget searchRadioButton() {
    return BlocBuilder<OrderInfoBloc, MyOrderInfoStates>(
        builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Radio(
                value: 'By Code',
                groupValue: state.radioGroupValue,
                onChanged: (value) {
                  context
                      .read<OrderInfoBloc>()
                      .add(ByCodeChanged(byCode: value));
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
                groupValue: state.radioGroupValue,
                onChanged: (value) {
                  context
                      .read<OrderInfoBloc>()
                      .add(ByNameChanged(byName: value));
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
    });
  }

  Widget autoCompleteSearchBar() {
    Timer _debounce;

    return BlocBuilder<OrderInfoBloc, MyOrderInfoStates>(
        builder: (context, state) {
      final isPortrait =
          MediaQuery.of(context).orientation == Orientation.portrait;

      return FloatingSearchBar(
        hint: 'Search...',
        controller: controller,
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 800),
        automaticallyImplyBackButton: true,
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        maxWidth: isPortrait ? 600 : 500,
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: (query) {
          if (query.isNotEmpty) {
            setState(() => isProgressing = true);
            if (_debounce?.isActive ?? false) _debounce.cancel();
            _debounce = Timer(const Duration(seconds: 2), () {
              context.read<OrderInfoBloc>().add(SearchTextChanged(text: query));
            });
          }
        },
        onSubmitted: (query) {
          setState(() => isProgressing = false);
          context.read<OrderInfoBloc>().add(SearchTextChanged(text: query));
        },
        onFocusChanged: (value) {
          if (value) setState(() => isProgressing = !isProgressing);
        },
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: true,
            child: CircularButton(
              icon: Icon(
                Icons.search,
                color: Colors.blueGrey,
              ),
              onPressed: () {
                context
                    .read<OrderInfoBloc>()
                    .add(SearchTextChanged(text: controller.query));
              },
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: true,
          ),
        ],
        progress: isProgressing,
        closeOnBackdropTap: true,
        isScrollControlled: true,
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              child: ListView.builder(
                itemCount: state.membersList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.person),
                    title: Text(state.membersList[index].memberName ?? '...'),
                    onTap: () {
                      setState(() => isProgressing = false);
                      controller.close();
                      context.read<OrderInfoBloc>().add(
                          SelectedMember(member: state.membersList[index]));
                    },
                  );
                },
              ),
            ),
          );
        },
      );
    });
  }

  Widget autoCompleteSearchBarRow(
      {@required String item, @required Icon icon}) {
    return ListTile(
      leading: icon,
      title: Text(item),
    );
  }

  Widget seeMultipleMembers({BuildContext context, List<Member> member}) {
    return Material(
      child: InkWell(
        onTap: () async {
          await _showDialog(member);
        },
        child: Container(
          padding: EdgeInsets.all(12.0),
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            color: Colors.green,
          ),
          child: Row(
            children: [
              Text(
                member.length > 1 ? 'Multiple Members' : '...',
                style: GoogleFonts.ubuntuCondensed(
                  fontSize: 25,
                  color: Colors.green[50],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.touch_app_rounded,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _showDialog(List<Member> member) async{
    return AppTheme.showAlertDialog(
      context,
      title: 'ALERT',
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 20,
      buttons: [
        FlatButton(
          color: Colors.redAccent,
          child: Text('Cancel', style: TextStyle(color: Colors.white),),
          onPressed: () => Navigator.pop(context),
        ),
      ],
      content: member.length == 0
          ? Text('List is Empty')
          : SizedBox(
        height: Config.getDeviceHeight(context) * 0.5,
        width: Config.getDeviceHeight(context) * 0.5,
        child: BlocBuilder<OrderInfoBloc, MyOrderInfoStates>(
          builder: (context, state){
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.selectedMember.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  tileColor: Colors.grey[200],
                  leading: Icon(Icons.person),
                  title: Text(state.selectedMember[index].memberName),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red,),
                    onPressed: () {
                      context.read<OrderInfoBloc>().add(
                          RemoveMember(member: state.selectedMember[index]));
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class CustomLabelledTextView extends StatelessWidget {
  final String labelName, text;

  CustomLabelledTextView({this.labelName, this.text});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Container(
        padding: EdgeInsets.all(3.0),
        margin: EdgeInsets.all(5.0),
        height: Config.getDeviceHeight(context) * 0.1,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$labelName: ',
              style: GoogleFonts.ubuntuCondensed(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.ubuntu(
                      color: Colors.grey[800],
                      fontSize: 22,
                      letterSpacing: 1.5,
                      wordSpacing: 1.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LocationDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderInfoBloc, MyOrderInfoStates>(
      builder: (context, state) {
        return Flexible(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(3.0),
            margin: EdgeInsets.all(5.0),
            height: Config.getDeviceHeight(context) * 0.1,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: DropdownButton<Location>(
              icon: Icon(Icons.arrow_drop_down_circle),
              iconSize: 24,
              elevation: 16,
              value: state.selectedLocation,
              isExpanded: true,
              style: TextStyle(
                color: Colors.grey[700],
              ),
              onChanged: (newValue) {
                context
                    .read<OrderInfoBloc>()
                    .add(SelectedLocation(location: newValue));
              },
              items: state.locationList,
            ),
          ),
        );
      },
    );
  }
}

class SessionDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderInfoBloc, MyOrderInfoStates>(
      builder: (context, state) {
        return Flexible(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(3.0),
            margin: EdgeInsets.all(5.0),
            height: Config.getDeviceHeight(context) * 0.1,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: DropdownButton<Session>(
              icon: Icon(Icons.arrow_drop_down_circle),
              iconSize: 24,
              elevation: 16,
              value: state.selectedSession,
              isExpanded: true,
              style: TextStyle(
                color: Colors.grey[700],
              ),
              onChanged: (newValue) {
                context
                    .read<OrderInfoBloc>()
                    .add(SelectedSession(session: newValue));
              },
              items: state.sessionList,
            ),
          ),
        );
      },
    );
  }
}

class WaiterInput extends StatelessWidget {
  const WaiterInput({Key key, this.focusNode}) : super(key: key);

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderInfoBloc, MyOrderInfoStates>(
      builder: (context, state) {
        return Flexible(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(3.0),
            margin: EdgeInsets.all(5.0),
            child: TextFormField(
              // initialValue: state.password.value,
              focusNode: focusNode,
              decoration: InputDecoration(
                icon: const Icon(Icons.person),
                labelText: 'Waiter',
                helperText: 'Please enter valid waiter',
                helperMaxLines: 2,
                errorMaxLines: 2,
                errorText: state.waiter.invalid
                    ? 'Please ensure the waiter entered is valid'
                    : null,
              ),
              keyboardType: TextInputType.text,
              onChanged: (value) {
                context.read<OrderInfoBloc>().add(WaiterChanged(waiter: value));
              },
              textInputAction: TextInputAction.done,
            ),
          ),
        );
      },
    );
  }
}

class TableInput extends StatelessWidget {
  const TableInput({Key key, this.focusNode}) : super(key: key);

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderInfoBloc, MyOrderInfoStates>(
      builder: (context, state) {
        return Flexible(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(3.0),
            margin: EdgeInsets.all(5.0),
            child: TextFormField(
              // initialValue: state.password.value,
              focusNode: focusNode,
              decoration: InputDecoration(
                icon: const Icon(Icons.wine_bar),
                labelText: 'Table',
                helperText: 'Please enter valid table no',
                helperMaxLines: 2,
                errorMaxLines: 2,
                errorText: state.tableNo.invalid
                    ? 'Please ensure the table no entered is valid'
                    : null,
              ),
              keyboardType: TextInputType.text,
              onChanged: (value) {
                context
                    .read<OrderInfoBloc>()
                    .add(TableNoChanged(tableNo: value));
              },
              textInputAction: TextInputAction.done,
            ),
          ),
        );
      },
    );
  }
}

class AtPartyCheckBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderInfoBloc, MyOrderInfoStates>(
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              value: state.atParty,
              onChanged: (value) {
                print('At Party CheckBox Value: $value');
                context
                    .read<OrderInfoBloc>()
                    .add(AtPartyChanged(atParty: value));
              },
            ),
            Text(
              'Party',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
          ],
        );
      },
    );
  }
}

class WithSpouseCheckBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderInfoBloc, MyOrderInfoStates>(
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              value: state.withSpouse,
              onChanged: (value) {
                print('With Spouse CheckBox Value: $value');
                context
                    .read<OrderInfoBloc>()
                    .add(WithSpouseChanged(withSpouse: value));
              },
            ),
            Text(
              'With Spouse',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
          ],
        );
      },
    );
  }
}
