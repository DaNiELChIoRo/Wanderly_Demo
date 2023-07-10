part of 'conter_cubit_cubit.dart';

enum LoginState { initial, loading, loggedIn, error }

class CounterState {
  LoginState value;

  CounterState({required this.value});
}
