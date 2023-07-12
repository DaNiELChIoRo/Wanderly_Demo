import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// import 'package:dio/dio.dart'
import 'package:demo_wander/storage.dart';

import 'models/Recruiter.dart';

class ApiClient {
  final _baseLoginUrl = "https://wapi.wanderly.dev";
  final _baseUrl = "https://wapi.staging.wanderly.dev";

  var _token = "";

  getHeaders(String? token) {
    token ??= _token;
    return {
      // Adding authorization
      'content-type': 'application/json',
      'Accept': 'application/json',
      'wap_access_token': '',
      'Authorization': 'Bearer $token',
      'Connection': 'keep-alive',
      'X-WANDA-APPNAME': 'Recruit',
      'Accept-Encoding': 'br;q=1.0, gzip;q=0.9, deflate;q=0.8'
    };
  }

  bool get isAuth => _token.isNotEmpty;

  static final ApiClient _singleton = ApiClient._internal();

  factory ApiClient() {
    return _singleton;
  }

  ApiClient._internal();

  Map<String, dynamic> validate(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // print('response from network getChatToken: $response');
      return jsonDecode(response.body); //['data']['token'].toString();
    } else {
      // throw Exception('Failed to load album');
      print('error from network getChatToken: $response');
      final error = jsonDecode(response.body)['message'] ?? '';
      throw Exception('unvalid response status code: $error');
    }
  }

  Future<Map<String, dynamic>> loginUser(
      String username, String password) async {
    print('username: $username , password: $password');
    final url = '$_baseLoginUrl/api/v1/auth/login/';
    var params = {
      'email': username,
      'password': password,
    };
    final response = await http.post(Uri.parse(url), body: params);
    print('response from network: $response');
    var json = jsonDecode(response.body);
    _token = json['user']['accessToken'];
    return jsonDecode(response.body);
    // return response;
  }

  Future<String> getAccessToken(String? token) async {
    final url = '$_baseLoginUrl/api/v1/auth/me';
    final response = await http.get(Uri.parse(url), headers: getHeaders(token));

    print('response from network getAccessToken: $response');
    return jsonDecode(response.body)['accessToken'].toString();
  }

  Future<String> getChatToken(String? token) async {
    final url = '$_baseLoginUrl/api/v1/chat-token';
    final response = await http
        .get(Uri.parse(url), headers: getHeaders(token))
        .catchError(
            (error) => {print('error from network getChatToken: $error')});
    print('response from network getChatToken: $response');
    return jsonDecode(response.body)['data']['token'].toString();
  }

  Future<List<Candidate>> getUsers(String? token) async {
    const url =
        'https://wapi.wanderly.dev/api/v1/candidates/?connection=mine&favorite=false&order_by=last_login&last_activity=60&unread=false&propose=false&page=1&limit=25&order=desc&anonymous=false&anonymous=0&candidates_tab=true&=null';

    const headers = {
      'content-type': 'application/json',
      'Accept': 'application/json',
      'wap_access_token': '',
      // 'Authorization': 'Bearer $token',
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZWVkYzEzMmZlODgwYjQ1ZjRiOWNkZjQwNmUwZjRjOGQ3ZTFlZTIxNGFlYmM5MGViMTA2MzA2MmFjNmVmNzU1ODA3MzYzZGM0MDM1OTJkYzgiLCJpYXQiOjE2ODkwMzEyNjIsIm5iZiI6MTY4OTAzMTI2MiwiZXhwIjoxNzIwNjUzNjYyLCJzdWIiOiI2MTYiLCJzY29wZXMiOltdfQ.hhB6BeZ5DzukzA_KQEAfygzxNqHk6FJ8P-xOcAdRrmHUNGTZ2O3XXFHOkjqdZftl31JdHxAQTbHuSgsLaWlM3rAcYFaSwqc22rSeKbKl35wIPHM2TUcwQJXxwxQzDONWuF7cvmgc8DYdScD2CcfWquGrLu8HgEXoJtt1W6G13jizmPOD9bZzkOu9VPOFN_FpvnaJkFkUgz-anoDYUH6wKgNWkPxkm8GQQFPkcCU-3wzWKjBD8O_9SpKS7yP3RMlo5BH_ILHFgbVerZHPoB-P5ZGbkAt_eGfj4cCJn45v8TbKYupXfIZBs9VS_03PNU_rS9soCy6DfnqF1u_Cwo6NlEUT84RrdepUumSQ4n5hiaiL0Qzj3LUndICecJTuk0YZuC_BSn61UfS-VBR92QIuKcb33KhamuFvIykgNxq1ct-jyBMOjUNx_VHSL4c1LVAhQn0_LYG1EuPqBu6F6HbMCsuT_0l2_QnSYFFON1FDdmxJAK_6PMZSx8iPc-3o1XbSx37TkpizbMoLuFMQXwIgVdFPqFI-XHqouJtDwI6FxnZEgEDbRHj5v8-qM7sLE1odXWMOEnd96HU3BJJi4pqHprtrCPzaHCQIH1Mzy0hInhtrUtpr41lqLvGew3KDw3hK6T42fjfZN40Le_zElLyHytVO78I8sLz2z3gr21jkSx4',
      'Connection': 'keep-alive',
      'X-WANDA-APPNAME': 'Recruit',
      'Accept-Encoding': 'br;q=1.0, gzip;q=0.9, deflate;q=0.8'
    };

    final body = {
      "archived": 'false',
      "favorite": 'false',
      "my_candidate": "all",
      "order_by": "last_login",
      "page": '1',
      "propose": 'false',
      "time_limit": "all_time"
    };
    // final url = Uri.https('wapi.wanderly.dev', '/api/v1/candidates', body);
    final response = await http
        .get(Uri.parse(url), headers: headers) //getHeaders(token))
        .catchError((error) {
      print('error from network getUsers: $error');
      // print('stackTrace from network getUsers: $stackTrace')
      throw Exception('error from network getUsers: $error');
    });
    print('response from network getUsers: $response');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('response from network getChatToken: $response');
      // return jsonDecode;

      final json = validate(response);
      // Encode the body to Recuiter List
      print('json from network getUsers: $json');
      final List<Candidate> users = json['data']['candidates']
          .map<Candidate>((json) => Candidate.fromJSON(json))
          .toList();
      return users;
    } else {
      print('current directory: ' + Directory.current.path);
      // final input = await File('${Directory.current.path}/candidates.json').readAsString();
      final input = await rootBundle.loadString('assets/candidates.json');
      final map = jsonDecode(input);

      final List<Candidate> users = map['data']['candidates']
          .map<Candidate>((json) => Candidate.fromJSON(json))
          .toList();
      return users;
    }
    // return jsonDecode(response.body).;
  }
}
