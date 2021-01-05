import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kbc_pos/bloc/order_info_bloc/order_info_bloc.dart';
import 'package:kbc_pos/bloc/pos_bloc/pos_bloc.dart';
import 'package:kbc_pos/data_provider/order_info_repo/order_info_service.dart';
import 'package:kbc_pos/data_provider/pos_repo/pos_service.dart';
import 'package:kbc_pos/screens/dashboard_screen.dart';
import 'package:kbc_pos/screens/login_screen.dart';
import 'package:kbc_pos/screens/order_info_screen.dart';
import 'package:kbc_pos/screens/pos_screen.dart';
import 'package:kbc_pos/screens/settings_screen.dart';
import 'package:kbc_pos/screens/splash_screen.dart';
import 'bloc/login_bloc/login_bloc.dart';
import 'data_provider/login_repo/login_service.dart';

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
          create: (context) => LoginBloc(
            loginRepo: LoginService(),
          ),
        ),
        BlocProvider<OrderInfoBloc>(
          create: (context) => OrderInfoBloc(
            orderInfoRepo: OrderInfoService(),
          ),
        ),
        BlocProvider<PosBloc>(
          create: (context) => PosBloc(
            posRepo: PosService(),
          ),
        ),
      ],
      child: new MaterialApp(
        title: 'POS',
        initialRoute: '/posScreen',
        routes: {
          '/splashScreen': (context) => SplashScreen(),
          '/loginScreen': (context) => LoginScreen(),
          '/dashboardScreen': (context) => DashboardScreen(),
          '/orderInfoScreen': (context) => OrderInfoScreen(),
          '/posScreen': (context) => PosScreen(),
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
