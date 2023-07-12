import 'package:demo_wander/api.dart';
import 'package:flutter/material.dart';
import 'package:demo_wander/HomePage.dart';
import 'package:demo_wander/storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_wander/cubit/conter_cubit_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Storage().getToken().then((value) =>
      {print('token from storage: $value'), runApp(MyApp(token: value))});
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({required this.token, super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CounterCubit>(
      create: (context) => CounterCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: Scaffold(
            appBar: AppBar(),
            body: (token ?? "").isNotEmpty
                ? const HomePage()
                : const LoginRegisterPage()),
      ),
    );
  }
}

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  String username = '';
  String password = '';
  bool showHome = false;

  // submitLogin(String email, String password) {
  //   ApiClient()
  //       .loginUser(email, password)
  //       .then((value) => {
  //             print('response from network:  $value)'),
  //             // String token = value['user']['accessToken'],
  //             Storage().saveToken(value['user']['accessToken']),
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) => const HomePage()))
  //           })
  //       .catchError((error) => {print('error from network: $error')});
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Text('Wanderly'),
            const Spacer(
              flex: 1,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
              onChanged: (value) => {
                setState(() {
                  username = value;
                })
              },
            ),
            TextField(
              obscureText: !showHome,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        showHome = !showHome;
                      });
                    },
                    icon: Icon(
                        showHome ? Icons.visibility : Icons.visibility_off)),
                labelText: 'Password',
              ),
              onChanged: (value) => {
                setState(() {
                  password = value;
                })
              },
            ),
            BlocBuilder<CounterCubit, CounterState>(
              builder: (context, state) {
                if (state.value == LoginState.loading) {
                  return const CircularProgressIndicator.adaptive();
                } else if (state.value == LoginState.error) {
                  return AlertDialog(
                    title: const Text('Error Alert'),
                    content: const Text('There was an error logging in'),
                    actions: [
                      TextButton(
                        onPressed: () => BlocProvider.of<CounterCubit>(context)
                            .submitLogin(username, password),
                        child: const Text('Retry'),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Ok'))
                    ],
                  );
                } else {
                  // return empty container
                  return const SizedBox.shrink();
                }
                // return Text(state.counterValue.toString());
              },
            ),
            const Spacer(
              flex: 1,
            ),
            // BlocListener(listener: listener)
            BlocListener<CounterCubit, CounterState>(
              listener: (context, state) {
                // TODO: implement listener
                if (state.value == LoginState.loggedIn) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                }
              },
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  padding: const EdgeInsets.all(15),
                ),
                onPressed: () => {
                  BlocProvider.of<CounterCubit>(context)
                      .submitLogin(username, password),
                  // submitLogin(username, password)
                },
                child: const Text('Login'),
              ),
            ),
            const Spacer(
              flex: 1,
            ),
          ],
        ));
  }
}
