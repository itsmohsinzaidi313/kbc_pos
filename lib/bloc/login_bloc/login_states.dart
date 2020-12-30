part of 'login_bloc.dart';

class MyLoginState extends Equatable{

  final Username username;
  final Password password;
  final FormzStatus status;

  const MyLoginState({
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure
  });

  MyLoginState copyWith({
    Username username,
    Password password,
    FormzStatus status}){
    return MyLoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [username, password, status];

}

class LoginError extends MyLoginState {
  final error;
  LoginError({this.error});
}
