import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kbc_pos/bloc/login_bloc/login_bloc.dart';
import 'package:kbc_pos/shared/app_theme.dart';
import 'package:kbc_pos/shared/config.dart';
import 'package:formz/formz.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscureText = true;

  Icon _icon = Icon(Icons.visibility_off);
  String errorEmail = '', errorPassword = '';
  Color activeColor = Colors.yellow[700];

  @override
  initState() {
    super.initState();
    _usernameFocusNode.addListener(() {
      if (!_usernameFocusNode.hasFocus) {
        context.read<LoginBloc>().add(UsernameUnfocused());
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<LoginBloc>().add(PasswordUnfocused());
      }
    });
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
      _icon =
          _obscureText ? Icon(Icons.visibility_off) : Icon(Icons.visibility);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: BlocListener<LoginBloc, MyLoginState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            Navigator.pushReplacementNamed(context, '/dashboardScreen');
          }
          if (state.status.isSubmissionInProgress) {
            AppTheme.mySnackBar(context: context, msg: 'Submitting...');
          }
          if (state is LoginError) {
            AppTheme.mySnackBar(context: context, msg: 'ERROR: ${state.error}');
          }
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              // margin: EdgeInsets.all(8.0),
              height: Config.getDeviceHeight(context),
              width: Config.getDeviceWidth(context),
              child: Row(
                children: <Widget>[
                  Container(
                    height: Config.getDeviceHeight(context),
                    width: Config.getDeviceWidth(context) * 0.4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.amber,
                          Colors.redAccent,
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(Config.getDeviceHeight(context)),
                      ),
                      color: Colors.amber,
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/dt1.png',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(10, 10),
                                      color: Colors.grey[300],
                                      blurRadius: 20),
                                  BoxShadow(
                                      offset: Offset(-10, -10),
                                      color: Colors.grey[300],
                                      blurRadius: 20)
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[100]))),
                                    child: UsernameInput(
                                      focusNode: _usernameFocusNode,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          child: PasswordInput(
                                            focusNode: _passwordFocusNode,
                                            obscureText: _obscureText,
                                          ),
                                        ),
                                        Positioned(
                                          right: 5,
                                          child: IconButton(
                                            icon: _icon,
                                            color: Colors.grey,
                                            onPressed: _toggle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            SubmitButton(),
                          ],
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
}

class UsernameInput extends StatelessWidget {
  const UsernameInput({Key key, this.focusNode}) : super(key: key);

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, MyLoginState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.username.value,
          focusNode: focusNode,
          decoration: InputDecoration(
            icon: const Icon(Icons.email),
            labelText: 'Username',
            helperText: 'A complete, valid username e.g. admin',
            errorText: state.username.invalid
                ? 'Please ensure the username entered is valid'
                : null,
          ),
          keyboardType: TextInputType.name,
          onChanged: (value) {
            context.read<LoginBloc>().add(UsernameChanged(username: value));
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({Key key, this.focusNode, this.obscureText})
      : super(key: key);

  final FocusNode focusNode;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, MyLoginState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.password.value,
          focusNode: focusNode,
          decoration: InputDecoration(
            icon: const Icon(Icons.lock),
            labelText: 'Password',
            helperText: 'Please enter valid password',
            helperMaxLines: 2,
            errorMaxLines: 2,
            errorText: state.password.invalid
                ? 'Please ensure the password entered is valid'
                : null,
          ),
          keyboardType: TextInputType.text,
          obscureText: obscureText,
          onChanged: (value) {
            context.read<LoginBloc>().add(PasswordChanged(password: value));
          },
          textInputAction: TextInputAction.done,
        );
      },
    );
  }
}

class SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, MyLoginState>(
      // buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Colors.redAccent,
                Colors.amber,
              ],
            ),
            boxShadow:
            [
              BoxShadow(
                  offset: Offset(10, 10),
                  color: Colors.grey[300],
                  blurRadius: 20),
              BoxShadow(
                  offset: Offset(-10, -10),
                  color: Colors.grey[300],
                  blurRadius: 20),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.yellow[100],
              onTap:() {
                      print('Button Status: ${state.status.isValidated}');
                      print('Button clicked');
                      context.read<LoginBloc>().add(FormSubmitted());
                    },
              child: Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MyDialog extends StatelessWidget {
  final String message;
  final BuildContext mContext;

  MyDialog({this.message, this.mContext});

  @override
  Widget build(BuildContext mContext) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Icon(Icons.info),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      message,
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
            RaisedButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(mContext).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
