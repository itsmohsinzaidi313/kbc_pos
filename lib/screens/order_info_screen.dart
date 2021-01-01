import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kbc_pos/bloc/order_info_bloc/order_info_bloc.dart';
import 'package:kbc_pos/bloc/order_info_bloc/order_info_events.dart';
import 'package:kbc_pos/bloc/order_info_bloc/order_info_states.dart';
import 'package:kbc_pos/models/objects/member.dart';
import 'package:kbc_pos/shared/app_theme.dart';
import 'package:kbc_pos/shared/config.dart';

class OrderInfoScreen extends StatefulWidget {
  @override
  _OrderInfoScreenState createState() => _OrderInfoScreenState();
}

class _OrderInfoScreenState extends State<OrderInfoScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<OrderInfoBloc>().add(FetchingLists());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Config.getDeviceWidth(context),
        height: Config.getDeviceHeight(context),
        child: Column(
          children: [
            CustomAppBar(),
            Container(
              padding: EdgeInsets.all(3.0),
              height: Config.getDeviceHeight(context) * 0.08,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Member Code: ',
                    style: GoogleFonts.ubuntuCondensed(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '0213',
                        style: GoogleFonts.ubuntu(
                          color: Colors.grey[800],
                          fontSize: 18,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                      child: AutoCompleteSearchBar(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SearchRadioButton(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchRadioButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderInfoBloc, MyOrderInfoStates>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Radio(
                  value: state.byCode,
                  groupValue: state.radioGroupValue,
                  onChanged: (value) => context
                      .read<OrderInfoBloc>()
                      .add(SearchByCodeChanged(byCode: value)),
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
                  value: state.byName,
                  groupValue: state.radioGroupValue,
                  onChanged: (value) => context
                      .read<OrderInfoBloc>()
                      .add(SearchByNameChanged(byName: value)),
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
      },
    );
  }
}

class AutoCompleteSearchBar extends StatelessWidget {
  final TextEditingController _autoCompleteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderInfoBloc, MyOrderInfoStates>(
        builder: (context, state) {
      return AutoCompleteTextField<Member>(
        clearOnSubmit: false,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: state.hintText,
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
          print(_autoCompleteController.text);
        },
        itemSubmitted: (item) async {
          context.read<OrderInfoBloc>().add(SelectedMember(member: item));
        },
        key: key,
        suggestions: state.membersList,
        itemBuilder: (context, item) {
          return state.byCode == state.radioGroupValue
              ? autoCompleteSearchBarRow(
                  item: item.memberNo, icon: Icon(Icons.person))
              : autoCompleteSearchBarRow(
                  item: item.memberName, icon: Icon(Icons.person));
        },
        itemFilter: (item, query) {
          return state.byCode == state.radioGroupValue
              ? item.memberNo.toLowerCase().startsWith(query.toLowerCase())
              : item.memberName.toLowerCase().startsWith(query.toLowerCase());
        },
        itemSorter: (a, b) {
          return state.byCode == state.radioGroupValue
              ? a.memberNo.compareTo(b.memberNo.toLowerCase())
              : a.memberName.compareTo(b.memberName.toLowerCase());
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
}
