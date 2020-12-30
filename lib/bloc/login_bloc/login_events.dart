part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {

  const LoginEvent();

  @override
  List<Object> get props => [];
}

class UsernameChanged extends LoginEvent{

  final String username;
  const UsernameChanged({@required this.username});
  @override
  List<Object> get props => [username];
}

class PasswordChanged extends LoginEvent{

  final String password;
  const PasswordChanged({@required this.password});
  @override
  List<Object> get props => [password];
}

class UsernameUnfocused extends LoginEvent{}

class PasswordUnfocused extends LoginEvent{}

class FormSubmitted extends LoginEvent{}

/*class LoginCredentials extends LoginEvent {

  final Credentials credentials;
  LoginCredentials({@required this.credentials});
}*/
