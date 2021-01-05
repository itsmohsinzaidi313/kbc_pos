import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kbc_pos/shared/app_theme.dart';

class CustomCircularProgressIndication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Center(
        child: ListTile(
          tileColor: Colors.white,
          title: Text(
            'Loading...',
            style: GoogleFonts.aBeeZee(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.normal,
              letterSpacing: 0.5,
            ),
          ),
          trailing: SizedBox(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(
              backgroundColor: AppTheme.appBarColor,
            ),
          ),
        ),
      ),
    );
  }
}
