import 'package:demo_wander/storage.dart';
import 'package:flutter/material.dart';
import 'package:demo_wander/api.dart';

import 'models/Recruiter.dart';

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
    Storage().getToken().then((value) => {makeRequests(value)});
    // makeRequests();
  } //

  // @override
  // void didUpdateWidget(covariant HomePage oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   makeRequests();
  // }

  makeRequests(String? token) {
    ApiClient().getAccessToken(token).then((value) => {
          print('value from getting access token $value'),
          ApiClient().getChatToken(token).then((value) => {
                print('value from getting chat token $value'),
                ApiClient()
                    .getUsers(value)
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
        appBar: AppBar(title: const Text('Candidates')),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            if (list.isEmpty) const CircularProgressIndicator.adaptive(),
            for (var item in list)
              // print(item),
              CandidateRow(
                candidate: item,
              )
          ],
        ));
  }
}

class CandidateRow extends StatelessWidget {
  final Candidate candidate;
  const CandidateRow({required this.candidate, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 45x45 Image from networking using candidate.photo
        Expanded(
          flex: 1,
          child: FadeInImage.assetNetwork(
              placeholder: 'assets/place_holder.png',
              image: candidate.photo.toString()),
        ),
        // Expanded(
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${candidate.first_name} ${candidate.last_name}',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(candidate.photo.toString() ?? 'no image'),
              // Text(candidate.),
            ],
          ),
        )
      ],
    );
  }
}
