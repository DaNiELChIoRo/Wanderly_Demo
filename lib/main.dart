import 'package:demo_wander/api.dart';
import 'package:flutter/material.dart';
import 'package:demo_wander/HomePage.dart';
import 'package:demo_wander/storage.dart';

void main() {
  Storage().getToken().then((value) =>
      {print('token from storage: $value'), runApp(MyApp(token: value))});
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String? token = '';

  MyApp({this.token, super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: Scaffold(
          appBar: AppBar(),
          body:
              token!.isNotEmpty ? const HomePage() : const LoginRegisterPage()),
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

  submitLogin(String email, String password) {
    ApiClient()
        .loginUser(email, password)
        .then((value) => {
              print('response from network:  $value)'),
              // String token = value['user']['accessToken'],
              Storage().saveToken(value['user']['accessToken']),
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()))
            })
        .catchError((error) => {print('error from network: $error')});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text('Wanderly'),
            Spacer(
              flex: 1,
            ),
            TextField(
              decoration: InputDecoration(
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
            Spacer(
              flex: 1,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.deepOrange,
                onPrimary: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.all(15),
                // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () => {
                print('username: $username'),
                print('password $password'),
                submitLogin(username, password)
              },
              child: Text('Login'),
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ));
  }
}
