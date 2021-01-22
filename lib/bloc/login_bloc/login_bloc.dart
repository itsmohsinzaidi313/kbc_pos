import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:kbc_pos/data_provider/login_repo/login_service.dart';
import 'package:kbc_pos/models/generic/response_detail.dart';
import 'package:kbc_pos/models/model_login/username_password.dart';
import 'package:kbc_pos/shared/config.dart';
part 'login_states.dart';
part 'login_events.dart';

class LoginBloc extends Bloc<LoginEvent, MyLoginState> {
  final LoginRepo loginRepo;
  ResponseDetail loginStatus;
  String _username, _password;

  LoginBloc({this.loginRepo}) : super(MyLoginState());

  @override
  void onTransition(Transition<LoginEvent, MyLoginState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<MyLoginState> mapEventToState(LoginEvent event) async* {
    if (event is UsernameChanged) {
      final username = Username.dirty(event.username);
      yield state.copyWith(
        username: username.valid ? username : Username.pure(event.username),
        status: Formz.validate([username, state.password]),
      );
      _username = state.username.value;
    } else if (event is PasswordChanged) {
      final password = Password.dirty(event.password);
      yield state.copyWith(
        password: password.valid ? password : Password.pure(event.password),
        status: Formz.validate([state.username, password]),
      );
      _password = state.password.value;
    } else if (event is UsernameUnfocused) {
      final username = Username.dirty(state.username.value);
      yield state.copyWith(
        username: username,
        status: Formz.validate([username, state.password]),
      );
    } else if (event is PasswordUnfocused) {
      final password = Password.dirty(state.password.value);
      yield state.copyWith(
        password: password,
        status: Formz.validate([state.username, password]),
      );
    } else if (event is FormSubmitted) {
      final username = Username.dirty(_username);
      final password = Password.dirty(_password);
      yield state.copyWith(
        username: username,
        password: password,
        status: Formz.validate([username, password]),
      );

      if (state.status.isValidated) {
        try {
          yield state.copyWith(username: state.username, password: state.password ,status: FormzStatus.submissionInProgress);
          final response = await loginRepo.authenticateUser(
              username: state.username.value, password: state.password.value);
          if (response.status) {
            Config.userId = response.userId.toString();
            Config.deviceKey = response.deviceKey;
            yield state.copyWith(username: state.username, password: state.password ,status: FormzStatus.submissionSuccess);
          } else {
            yield state.copyWith(username: state.username, password: state.password ,status: FormzStatus.submissionFailure);
            yield LoginError(error: response.message);
          }
        } catch (e) {
          yield state.copyWith(username: state.username, password: state.password ,status: FormzStatus.submissionFailure);
          yield LoginError(error: e);
        }
      }
    }
  }
}
