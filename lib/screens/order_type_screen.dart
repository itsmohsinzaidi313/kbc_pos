import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kbc_pos/shared/app_theme.dart';
import 'package:kbc_pos/shared/config.dart';

class OrderTypeScreen extends StatefulWidget {
  @override
  _OrderTypeScreenState createState() => _OrderTypeScreenState();
}

class _OrderTypeScreenState extends State<OrderTypeScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  int _viewType = 0;
  bool customerExists = true;
  int customerId = 0;
  String errorMsg;
  bool takeawaySearchButton = false;
  bool deliverySearchButton = false;
  ImageProvider dineIn, takeAway, delivery;

  List<TextEditingController> controllers = [
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
  ];

//List<bool> check = [person, TA-name, TA-contact, D-name, D-contact, D-address]
  List<bool> check = [false, false, false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    gridViewType = 1;
    errorMsg = '';
    dineIn = AssetImage('assets/dine_in.jpg');
    takeAway = AssetImage('assets/takeaway.jpg');
    delivery = AssetImage('assets/delivery.jpg');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(dineIn, context);
    precacheImage(takeAway, context);
    precacheImage(delivery, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      key: _key,
      appBar: AppTheme.appBarNormal(
        appBarTitle: 'Order Type',
        appBarBgColor: AppTheme.appBarColor,
        appBarElevation: 0.0,
        context: context,
      ),
      body: Container(
        height: Config.getDeviceHeight(context),
        width: Config.getDeviceWidth(context),
        child: Row(
          children: [
            Expanded(
              child: getLayout(_viewType),
            ),
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        color: Color(0xff7c94b6),
                        elevation: 5,
                        child: InkWell(
                          onTap: () => setState(() => _viewType = 1),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: dineIn,
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.6),
                                    BlendMode.dstATop),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 2,
                            ),
                            height: Config.getDeviceHeight(context) * 0.25,
                            width: Config.getDeviceWidth(context),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                'Dine-In',
                                style: GoogleFonts.ptSans(
                                  fontSize: 35,
                                  letterSpacing: 3.0,
                                  wordSpacing: 1.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        color: Color(0xff7c94b6),
                        elevation: 5,
                        child: InkWell(
                          onTap: () => setState(() => _viewType = 2),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: takeAway,
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.6),
                                    BlendMode.dstATop),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 2,
                            ),
                            height: Config.getDeviceHeight(context) * 0.25,
                            width: Config.getDeviceWidth(context),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                'Takeaway',
                                style: GoogleFonts.ptSans(
                                  fontSize: 35,
                                  letterSpacing: 3.0,
                                  wordSpacing: 1.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        color: Color(0xff7c94b6),
                        elevation: 5,
                        child: InkWell(
                          onTap: () => setState(() => _viewType = 3),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: delivery,
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.6),
                                    BlendMode.dstATop),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 2,
                            ),
                            height: Config.getDeviceHeight(context) * 0.25,
                            width: Config.getDeviceWidth(context),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                'Delivery',
                                style: GoogleFonts.ptSans(
                                  fontSize: 35,
                                  letterSpacing: 3.0,
                                  wordSpacing: 1.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int gridViewType;
  bool isWaiterSelected = false;

  // int listLength = DataLists.instance.listTables.length;

  Widget getLayout(int viewType) {
    switch (viewType) {
      case 1:
        return Container(
          margin: EdgeInsets.all(5.0),
          child: Column(
            children: [
              Card(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        ListTile(
                          title: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.grey.shade200,
                              border: Border(
                                left: BorderSide(
                                  color: Colors.yellow.shade700,
                                  width: 3.0,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: controllers[1],
                              cursorColor: Colors.yellow[700],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.group,
                                  color: Colors.yellow.shade800,
                                  size: 20,
                                ),
                                hintText: 'Persons',
                                border: InputBorder.none,
                                errorText: check[1] ? errorMsg : null,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          title: FlatButton(
                            child: Text('OK',
                                style: TextStyle(color: Colors.white)),
                            color: isWaiterSelected ? Colors.red : null,
                            onPressed: isWaiterSelected
                                ? () {
                                    if (!check[1]) {
                                      ///check person field validation
                                    }
                                  }
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Card(
                  color: Colors.white70,
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    children: getGridViewWidget(viewType: 1 /* 1 or 2*/),
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      case 2:
        return SingleChildScrollView(
          child: Container(
            height: Config.getDeviceHeight(context) * 0.8,
            margin: EdgeInsets.all(5.0),
            child: Card(
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    ListTile(
                      title: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.grey.shade200,
                          border: Border(
                            left: BorderSide(
                              color: Colors.yellow.shade700,
                              width: 3.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: controllers[3],
                          cursorColor: Colors.yellow.shade700,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.dialpad,
                              color: Colors.yellow.shade800,
                              size: 20,
                            ),
                            hintText: 'Contact',
                            border: InputBorder.none,
                            errorText: check[3] ? errorMsg : null,
                          ),
                        ),
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            if (!check[3]) {
                              ///Check takeaway customer contact in takeaway if exist get that else create new
                            }
                          },
                        ),
                      ),
                    ),
                    ListTile(
                      title: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.grey.shade200,
                          border: Border(
                            left: BorderSide(
                              color: Colors.yellow.shade700,
                              width: 3.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: TextField(
                          controller: controllers[2],
                          cursorColor: Colors.yellow.shade700,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.person,
                              size: 20,
                              color: Colors.yellow.shade800,
                            ),
                            border: InputBorder.none,
                            hintText: 'Name',
                            errorText: check[2] ? errorMsg : null,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: FlatButton(
                        child: Text(
                          'OK',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: takeawaySearchButton
                            ? () {
                                ///If all the takeaway fields are validated then navigate to new sale screen
                              }
                            : null,
                        color: takeawaySearchButton ? Colors.redAccent : null,
                      ),
                      // tileColor: takeawaySearchButton ? Colors.redAccent : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        break;
      case 3:
        return SingleChildScrollView(
          child: Container(
            height: Config.getDeviceHeight(context) * 0.8,
            margin: EdgeInsets.all(5.0),
            child: Card(
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    ListTile(
                      title: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.grey.shade200,
                          border: Border(
                            left: BorderSide(
                              color: Colors.yellow.shade700,
                              width: 3.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.yellow.shade700,
                          controller: controllers[5],
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.dialpad,
                              size: 20,
                              color: Colors.yellow.shade800,
                            ),
                            hintText: 'Contact',
                            border: InputBorder.none,
                            errorText: check[5] ? 'Required' : null,
                          ),
                        ),
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (!check[5]) {
                              ///Check delivery customer contact in takeaway if exist get that else create new
                            }
                          },
                        ),
                      ),
                    ),
                    ListTile(
                      title: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.grey.shade200,
                          border: Border(
                            left: BorderSide(
                              color: Colors.yellow.shade700,
                              width: 3.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: TextField(
                          controller: controllers[4],
                          cursorColor: Colors.yellow.shade700,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.person,
                              size: 20,
                              color: Colors.yellow.shade800,
                            ),
                            hintText: 'Name',
                            border: InputBorder.none,
                            errorText: check[4] ? 'Required' : null,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.grey.shade200,
                          border: Border(
                            left: BorderSide(
                              color: Colors.yellow.shade700,
                              width: 3.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: TextField(
                          controller: controllers[6],
                          cursorColor: Colors.yellow.shade700,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.home,
                              size: 20,
                              color: Colors.yellow.shade800,
                            ),
                            hintText: 'Address',
                            border: InputBorder.none,
                            errorText: check[4] ? 'Required' : null,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: FlatButton(
                        child: Text(
                          'OK',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: deliverySearchButton
                            ? () {
                                ///If all the delivery fields are validated then navigate to new sale screen
                              }
                            : null,
                        color: deliverySearchButton ? Colors.redAccent : null,
                      ),
                      // tileColor: deliverySearchButton ? Colors.redAccent : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        break;
      default:
        return Container();
        break;
    }
  }

  List<Widget> getGridViewWidget({int viewType}) {
    List<Widget> listWidget = [];

    ///getting tables list and waiters list

    if (viewType == 1) {
      ///checking table if reserved
      /*      listTables.forEach((element) {
        Icon icon = Icon(
          Icons.lock_open_rounded,
          size: 20,
          color: Colors.green,
        );
        if (element.delStatus == OrdersTable.RESERVED) {
          // color = Colors.grey;
          // textColor = Colors.white;
          icon = Icon(
            Icons.lock_rounded,
            size: 20,
            color: Colors.red,
          );
        }*/

      ///generating tables list
      listWidget.add(
        Card(
          elevation: 10,
          color: Colors.grey.shade100,
          child: InkWell(
              child: Stack(
                children: [
                  Positioned(
                    top: 2,
                    left: 2,
                    child: Text(
                      'element.name',
                      style: GoogleFonts.ubuntuCondensed(
                        color: Colors.grey.shade900,
                        fontSize: 16,
                        letterSpacing: 1.0,
                        wordSpacing: 1.0,
                        // fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    left: 2,
                    child: RichText(
                      text: TextSpan(
                        text: 'Capacity: ',
                        style: GoogleFonts.ubuntuCondensed(
                          color: Colors.grey.shade700,
                          fontSize: 15,
                          letterSpacing: 1.0,
                          wordSpacing: 1.0,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'element.sitCapacity',
                            style: GoogleFonts.ubuntuCondensed(
                                color: Colors.grey.shade500,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Image(
                        image: AssetImage('assets/table.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(-1, -1),
                            blurRadius: 2,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(Icons.hourglass_empty),
                    ),
                  ),
                ],
              ),
              onTap: () {
                ///selecting table
              }),
        ),
      );
    } else if (viewType == 2) {
      ///adding back button manually in the waiter list
      ///and generating waiter list
/*      listWidget.add(Card(
        color: Colors.grey,
        child: Center(
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
            onPressed: () => setState(() => gridViewType = 1),
          ),
        ),
      ));
      listWaiters.forEach((element) {
        listWidget.add(Container(
          child: Card(
            color: waiter == element ? Colors.redAccent[200] : Colors.white,
            child: InkWell(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 2,
                    left: 2,
                    child: Text(
                      element.fullName.toUpperCase(),
                      style: GoogleFonts.ubuntuCondensed(
                        color: waiter == element ? Colors.white : Colors.grey[800],
                        fontSize: 14,
                        letterSpacing: 1.0,
                        wordSpacing: 1.0,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Image(
                        image: AssetImage('assets/waiter.png'),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  waiter = element;
                  isWaiterSelected = true;
                });
              },
            ),
          ),
        ));
      });*/
    }
    return listWidget;
  }
}
