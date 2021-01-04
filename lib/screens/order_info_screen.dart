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
import 'package:kbc_pos/models/objects/session.dart';
import 'package:kbc_pos/shared/app_theme.dart';
import 'package:kbc_pos/shared/config.dart';
import 'package:formz/formz.dart';
import 'custom_widget_classes/custom_appbar.dart';

class OrderInfoScreen extends StatefulWidget {
  @override
  _OrderInfoScreenState createState() => _OrderInfoScreenState();
}

class _OrderInfoScreenState extends State<OrderInfoScreen> {
  String radioGroupValue = 'By Code';
  final TextEditingController _autoCompleteController = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<Member>> _key = GlobalKey();
  final _waiterFocusNode = FocusNode();
  final _tableNoFocusNode = FocusNode();

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
            AppTheme.mySnackBar(
                context: context, msg: 'Order Submitted Successfully..');
          }
        },
        child: Container(
          width: Config.getDeviceWidth(context),
          height: Config.getDeviceHeight(context),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomAppBar(
                  appBarTitle: 'Order Information',
                  searchBar: autoCompleteSearchBar(),
                  radioButtons: searchRadioButton(),
                ),
                BlocBuilder<OrderInfoBloc, MyOrderInfoStates>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomLabelledTextView(
                              labelName: 'Member Name',
                              text: state.selectedMember.memberName ?? '...',
                            ),
                            CustomLabelledTextView(
                              labelName: 'Member Code',
                              text: state.selectedMember.memberNo ?? '...',
                            ),
                            CustomLabelledTextView(
                              labelName: 'Member Status',
                              text: state.selectedMember.memberStatus ?? '...',
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AtPartyCheckBox(),
                    WithSpouseCheckBox(),
                  ],
                ),
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
                    context.read<OrderInfoBloc>().add(OrderSubmitted());
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
              hintText: 'Search Member Here..',
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
              context.read<OrderInfoBloc>().add(SelectedMember(member: item));
            },
            key: _key,
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

  Widget autoCompleteSearchBarRow(
      {@required String item, @required Icon icon}) {
    return ListTile(
      leading: icon,
      title: Text(item),
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
      fit: FlexFit.loose,
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
                Text(
                  text,
                  style: GoogleFonts.ubuntu(
                    color: Colors.grey[800],
                    fontSize: 22,
                    letterSpacing: 1.5,
                    wordSpacing: 1.0,
                    fontWeight: FontWeight.normal,
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
