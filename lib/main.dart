import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kbc_pos/screens/dashboard_screen.dart';
import 'package:kbc_pos/screens/login_screen.dart';
import 'package:kbc_pos/screens/settings_screen.dart';
import 'package:kbc_pos/screens/splash_screen.dart';

import 'bloc/login_bloc/login_bloc.dart';
import 'data_provider/login_repo/login_svc.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  EquatableConfig.stringify = kDebugMode;
  //Screen orientation set to landscape
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) {
    runApp(MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(loginRepo: LoginService()),
        ),

      ],
      child: new MaterialApp(
        title: 'POS',
        initialRoute: '/splashScreen',
        routes: {
          '/dashboardScreen': (context) => DashboardScreen(),
          '/loginScreen': (context) => LoginScreen(),
          '/splashScreen': (context) => SplashScreen(),
          '/settingScreen': (context) => SettingsScreen(),
        },
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.red,
          primaryColor: Colors.redAccent,
          accentColor: Colors.yellow[800],
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
    ));
  });
}
