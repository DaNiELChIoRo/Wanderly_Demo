import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../api.dart';
import '../storage.dart';

part 'conter_cubit_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterState(value: LoginState.initial));

  void submitLogin(String email, String password) {
    emit(CounterState(value: LoginState.loading));

    ApiClient()
        .loginUser(email, password)
        .then((value) => {
              print('response from network:  $value)'),
              // String token = value['user']['accessToken'],
              Storage().saveToken(value['user']['accessToken']),
              emit(CounterState(value: LoginState.loggedIn))
            })
        .catchError((error) => {
              emit(CounterState(value: LoginState.error)),
              print('error from network: $error')
            });
  }
}
