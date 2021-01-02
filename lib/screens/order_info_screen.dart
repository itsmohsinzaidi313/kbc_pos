import 'package:autocomplete_textfield/autocomplete_textfield.dart';
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

class OrderInfoScreen extends StatefulWidget {
  @override
  _OrderInfoScreenState createState() => _OrderInfoScreenState();
}

class _OrderInfoScreenState extends State<OrderInfoScreen> {

  String radioGroupValue = 'By Code';
  final TextEditingController _autoCompleteController = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<Member>> _key = GlobalKey();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OrderInfoBloc, MyOrderInfoStates>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is FetchingListInProgress) {
            AppTheme.mySnackBar(context: context, msg: 'Loading..');
          }
        },
        child: Container(
          width: Config.getDeviceWidth(context),
          height: Config.getDeviceHeight(context),
          child: Column(
            children: [
              customAppBar(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomLabelledTextView(
                    labelName: 'Member Name',
                    text: 'Dr. Sahab',
                  ),
                  CustomLabelledTextView(
                    labelName: 'Member Code',
                    text: '01234',
                  ),
                  CustomLabelledTextView(
                    labelName: 'Member Status',
                    text: 'A',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomLabelledTextView(
                    labelName: 'Order No.',
                    text: '12345',
                  ),
                  CustomLabelledTextView(
                    labelName: 'Covers',
                    text: 'Covers',
                  ),
                  CustomLabelledTextView(
                    labelName: 'Slip',
                    text: 'Slip',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [LocationDropdown(), SessionDropdown()],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customAppBar(){
    return Container(
      width: double.infinity,
      height: Config.getDeviceHeight(context) * 0.25,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: Config.getDeviceHeight(context) * 0.15,
            color: AppTheme.appBarColor,
            child: Center(
              child: Text(
                'Order Information',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: Colors.grey[200],
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                      height: 50,
                      child: autoCompleteSearchBar(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: searchRadioButton(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchRadioButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Radio(
              value: 'By Code',
              groupValue: radioGroupValue,
              onChanged: (value){
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
              onChanged: (value){
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
        }
        else if(snapshot.hasError){
          print(snapshot.error);
        }
        else if(snapshot.hasData){
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
              _autoCompleteController.text = radioGroupValue == 'By Code' ? item.memberNo : item.memberName;
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
              if(_autoCompleteController.text.isNotEmpty) {
                _itemFilter = radioGroupValue == 'By Code'
                    ? item.memberNo
                        .toLowerCase()
                        .startsWith(query.toLowerCase())
                    : item.memberName
                        .toLowerCase()
                        .startsWith(query.toLowerCase());
              } else{
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
  const WaiterInput({Key key, this.focusNode, this.obscureText})
      : super(key: key);

  final FocusNode focusNode;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderInfoBloc, MyOrderInfoStates>(
      builder: (context, state) {
        return Flexible(
          flex: 1,
          child: TextFormField(
            // initialValue: state.password.value,
            focusNode: focusNode,
            decoration: InputDecoration(
              icon: const Icon(Icons.person),
              labelText: 'Waiter',
              // helperText: 'Please enter valid password',
              helperMaxLines: 2,
              errorMaxLines: 2,
              // errorText: state.password.invalid
              //     ? 'Please ensure the password entered is valid'
              //     : null,
            ),
            keyboardType: TextInputType.text,
            obscureText: obscureText,
            onChanged: (value) {
            },
            textInputAction: TextInputAction.done,
          ),
        );
      },
    );
  }
}

class TableInput extends StatelessWidget {
  const TableInput({Key key, this.focusNode, this.obscureText})
      : super(key: key);

  final FocusNode focusNode;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderInfoBloc, MyOrderInfoStates>(
      builder: (context, state) {
        return Flexible(
          flex: 1,
          child: TextFormField(
            // initialValue: state.password.value,
            focusNode: focusNode,
            decoration: InputDecoration(
              icon: const Icon(Icons.wine_bar),
              labelText: 'Table',
              // helperText: 'Please enter valid password',
              helperMaxLines: 2,
              errorMaxLines: 2,
              // errorText: state.password.invalid
              //     ? 'Please ensure the password entered is valid'
              //     : null,
            ),
            keyboardType: TextInputType.text,
            obscureText: obscureText,
            onChanged: (value) {
            },
            textInputAction: TextInputAction.done,
          ),
        );
      },
    );
  }
}

