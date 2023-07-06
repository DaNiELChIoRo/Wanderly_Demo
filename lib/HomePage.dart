import 'package:flutter/material.dart';
import 'package:demo_wander/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var list = [];

  //calls API when the page loads
  @override
  initState() {
    super.initState();
    makeRequests();
  } //

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    makeRequests();
  }

  makeRequests() {
    ApiClient().getAccessToken().then((value) => {
          print('value from getting access token $value'),
          ApiClient().getChatToken().then((value) => {
                print('value from getting chat token $value'),
                ApiClient()
                    .getUsers()
                    .then((value) => {
                          print('value form getting users $value'),
                          setState(() {
                            list = value;
                          })
                        })
                    .catchError((error) =>
                        {print('error from network getting users: $error')})
              })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            if (list.isEmpty) Text('Loading...'),
            for (var item in list) Text('Home Page'),
          ],
        ));
  }
}
