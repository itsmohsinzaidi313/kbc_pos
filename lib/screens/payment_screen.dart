import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kbc_pos/shared/app_theme.dart';
import 'package:kbc_pos/shared/config.dart';

class PaymentScreen extends StatefulWidget {

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  List<TextEditingController> controllers = [
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController()
  ];

//List<bool> check = [Amount, credit number, discount];
  List<bool> check = [false, false, false];
  double discount = 0.0;
  String _type;
  Color cashColor = Colors.grey, percentageColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _type = '0';
  }

  @override
  Widget build(BuildContext context) {
    // controllers[0].text = model.salesMaster.dueAmount;
    // selectedPayment = model.paymentMethodList[0];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: AppTheme.appBarColor,
        title: Text('Payment'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            elevation: 5,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Container(
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                // color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
              width: Config.getDeviceWidth(context) * 0.43,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.redAccent,
                    ),
                    child: Text(
                      'Payment'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ubuntuCondensed(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 3.0,
                        // backgroundColor: Colors.redAccent
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Net Amount: ',
                        style: GoogleFonts.ubuntuCondensed(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          backgroundColor: Colors.grey[200],
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        // model.map['due_amount'],
                        'Rs. model.salesMaster.dueAmount/=',
                        style:  GoogleFonts.ubuntuCondensed(
                          color: Colors.grey[500],
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15
                  ),
                  Container(
                    width: double.infinity,
                    child: Card(
                      color: Colors.grey[100],
                      ///dropdown code
                      // child: DropdownButtonHideUnderline(
                      //   child: DropdownButton<PaymentMethod>(
                      //     isExpanded: true,
                      //     hint: Center(child: Text("Select Your Payment Method")),
                      //     value: selectedPayment,
                      //     onChanged: (PaymentMethod payment) {
                      //       setState(() {
                      //         selectedPayment = payment;
                      //         _type = payment.serverId;
                      //       });
                      //     },
                      //     items: model.paymentMethodList
                      //         .map((PaymentMethod payment) {
                      //       return DropdownMenuItem<PaymentMethod>(
                      //         value: payment,
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: <Widget>[
                      //             Icon(
                      //               Icons.style,
                      //               color: Colors.green,
                      //             ),
                      //             SizedBox(
                      //               width: 10,
                      //             ),
                      //             Text(
                      //               payment.name,
                      //               style: TextStyle(color: Colors.black),
                      //             ),
                      //           ],
                      //         ),
                      //       );
                      //     }).toList(),
                      //   ),
                      // ),
                    ),
                  ),
                  getWidget(_type),
                  _type != '0' ? Container(
                    margin: EdgeInsets.only(
                      top: 20,
                    ),
                    child: Card(
                      color: Colors.grey[100],
                      child: ListTile(
                        leading: Icon(
                          Icons.wallet_giftcard_rounded,
                          color: Colors.yellow[800],
                        ),
                        title: TextField(
                          keyboardType: TextInputType.number,
                          controller: controllers[2],
                          decoration: InputDecoration(
                            // suffixIcon: Icon(
                            //   Icons.cancel,
                            // ),
                            border: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.amberAccent, width: 1),
                            ),
                            hintText: 'Discount',
                          ),
                        ),
                        trailing: Container(
                          width: Config.getDeviceHeight(context) * 0.15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: IconButton(
                                  icon: Icon(
                                      Icons.attach_money_outlined,
                                      color: cashColor
                                  ),
                                  onPressed: () {
                                    if (controllers[2].text.isNotEmpty) {
                                      setState(() {
                                        cashColor = Colors.redAccent;
                                        percentageColor = Colors.grey[300];
                                      });
                                      discount =
                                          double.parse(controllers[2].text);
                                      print('Discount by Cash: $discount');
                                    } else{
                                      // controllers[2].text = '0';
                                      discount = 0.0;
                                    }
                                  },
                                ),
                              ),
                              Expanded(child: VerticalDivider(color: Colors.grey[400],)),
                              Expanded(
                                child: IconButton(
                                  icon: Text(
                                    '%',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: percentageColor
                                    ),
                                  ),
                                  onPressed: () {
                                    ///checking discount field
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ) : SizedBox(),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: RaisedButton(
                        elevation: 0.0,
                        onPressed: () {
                          ///Adding payment in the DB
                        },
                        color: Colors.yellow[700],
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            // fontStyle: FontStyle.italic,
                            letterSpacing: 3.0,
                            fontSize: 15,
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
      ),
    );
  }

  Widget getWidget(String type) {
    if (type == '1') {
      return Container(
        margin: EdgeInsets.only(
          top: 20,
        ),
        child: Card(
          color: Colors.grey[100],
          child: ListTile(
            leading: Icon(Icons.monetization_on, color: Colors.yellow[700]),
            title: TextField(
              keyboardType: TextInputType.number,
              readOnly: true,
              controller: controllers[0],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amberAccent, width: 1),
                ),
                hintText: 'Amount',
                errorText: check[0] ? 'Required' : null,
              ),
            ),
          ),
        ),
      );
    }
    else if (type == '2') {
      return Container(
        margin: EdgeInsets.only(
          top: 20,
        ),
        child: Card(
          color: Colors.grey[100],
          child: ListTile(
            leading: Icon(
              Icons.credit_card,
              color: Colors.yellow[700],
            ),
            title: TextField(
              keyboardType: TextInputType.number,
              controller: controllers[1],
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amberAccent, width: 1),
                  ),
                  hintText: 'Credit Number',
                  errorText: check[1] ? 'Required' : null),
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 10,
      );
    }
  }
}
